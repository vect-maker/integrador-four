#!/usr/bin/env python3
"""
MoviGo Operations: Numerical Methods & Least Squares Multivariable Regression
-----------------------------------------------------------------------------
Implements the Numerical Methods curricular integration for MoviGo (UNAN-Managua).
Models the physical, operational, and financial dimensions of ride-hailing mobility
via Multivariable Ordinary Least Squares (OLS) solved via Singular Value Decomposition
(SVD / LAPACK dgelsd driver) through scikit-learn.

The suite fits and evaluates three interdependent models on completed trips (N = 49,049):
  1. Operational ETA Model: duration_minutes = f(distance_km, origin_congestion_index, origin_precipitation_mm)
  2. Physical Kinematics Model: effective_speed_kmh = f(origin_congestion_index, origin_precipitation_mm)
  3. Economic Pricing Model: final_fare = f(distance_km, duration_minutes, surge_multiplier)

Theoretical Foundations in Numerical Linear Algebra:
  - Linear System: min_beta ||X beta - y||_2^2  <=>  (X^T X) beta = X^T y
  - SVD Factorization: X = U Sigma V^T  =>  beta = V Sigma^+ U^T y
  - Numerical Stability: SVD avoids condition number squaring (kappa(X^T X) = kappa(X)^2),
    guaranteeing stability even in ill-conditioned traffic/weather regimes.

Outputs:
  - JSON data: typst/data/numerical_methods.json
  - Plot 1: typst/graphs/numerical_duration.png
  - Plot 2: typst/graphs/numerical_speed.png
  - Plot 3: typst/graphs/numerical_fare.png
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, cast

import duckdb
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.linalg import svd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import train_test_split

# -----------------------------------------------------------------------------
# Configuration and Constants
# -----------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
DB_PATH = PROJECT_ROOT / "pipeline" / "data" / "analytics.duckdb"
OUTPUT_DATA_DIR = PROJECT_ROOT / "typst" / "data"
OUTPUT_GRAPHS_DIR = PROJECT_ROOT / "typst" / "graphs"

RANDOM_STATE = 42
TEST_SIZE = 0.20

# Color palette aligned with MoviGo design guidelines
COLOR_PRIMARY = "#1e3a8a"    # Dark navy blue
COLOR_SECONDARY = "#0284c7"  # Sky blue
COLOR_ACCENT = "#d97706"     # Amber / Warning
COLOR_DANGER = "#dc2626"     # Coral red
COLOR_SUCCESS = "#16a34a"    # Forest green
COLOR_MUTED = "#64748b"      # Slate grey


def load_dataset(db_path: Path) -> pd.DataFrame:
    """Extracts completed trip records with microclimate and vehicle telemetry from DuckDB."""
    if not db_path.exists():
        raise FileNotFoundError(f"Database snapshot not found at {db_path}")

    con = duckdb.connect(str(db_path), read_only=True)
    try:
        query = """
            SELECT
                trip_id,
                cast(distance_km as double) as distance_km,
                cast(duration_minutes as double) as duration_minutes,
                cast(effective_speed_kmh as double) as effective_speed_kmh,
                cast(origin_congestion_index as double) as origin_congestion_index,
                cast(origin_precipitation_mm as double) as origin_precipitation_mm,
                cast(final_fare as double) as final_fare,
                cast(surge_multiplier as double) as surge_multiplier
            FROM fct_viajes
            WHERE es_completado = true
              AND distance_km > 0
              AND duration_minutes > 0
              AND effective_speed_kmh > 0
              AND origin_congestion_index IS NOT NULL
              AND origin_precipitation_mm IS NOT NULL
            ORDER BY trip_id;
        """
        df = con.execute(query).fetchdf()
    finally:
        con.close()

    return df


def compute_svd_diagnostics(x_matrix: np.ndarray, feature_names: list[str]) -> dict[str, Any]:
    """Computes SVD singular values, condition number, and rank for design matrix X."""
    # Add intercept column of ones to match OLS design matrix
    ones = np.ones((x_matrix.shape[0], 1))
    x_full = np.hstack([ones, x_matrix])

    # Singular Value Decomposition
    _, s, _ = svd(x_full, full_matrices=False)
    sigma_max = float(s[0])
    sigma_min = float(s[-1])
    cond_number_svd = float(sigma_max / sigma_min)
    cond_number_normal_eq = float(cond_number_svd ** 2)

    return {
        "features_included": ["intercept"] + feature_names,
        "singular_values": [round(float(val), 4) for val in s],
        "condition_number_svd": round(cond_number_svd, 2),
        "condition_number_normal_equations": round(cond_number_normal_eq, 2),
        "matrix_rank": int(len(s)),
        "numerical_method": "Singular Value Decomposition (SVD / LAPACK dgelsd)",
        "stability_advantage": (
            f"SVD maintains condition number kappa(X) = {cond_number_svd:.2f}, "
            f"preventing normal equation squaring kappa(X^T X) = {cond_number_normal_eq:.2e}."
        ),
    }


def fit_and_evaluate_model(
    model_name: str,
    target_col: str,
    feature_cols: list[str],
    target_label: str,
    target_unit: str,
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """Fits LinearRegression, computes SVD diagnostics, train/test metrics, and predictions."""
    x_train = train_df[feature_cols].to_numpy()
    y_train = train_df[target_col].to_numpy()
    x_test = test_df[feature_cols].to_numpy()
    y_test = test_df[target_col].to_numpy()

    # Numerical SVD diagnostics on full feature design matrix
    svd_diagnostics = compute_svd_diagnostics(x_train, feature_cols)

    # Scikit-learn Linear Regression (internally calls scipy.linalg.lstsq / LAPACK dgelsd)
    model = LinearRegression()
    model.fit(x_train, y_train)

    # In-sample (train) metrics
    y_train_pred = model.predict(x_train)
    r2_train = float(r2_score(y_train, y_train_pred))
    rmse_train = float(np.sqrt(mean_squared_error(y_train, y_train_pred)))
    mae_train = float(mean_absolute_error(y_train, y_train_pred))

    # Out-of-sample (test) metrics
    y_test_pred = model.predict(x_test)
    r2_test = float(r2_score(y_test, y_test_pred))
    rmse_test = float(np.sqrt(mean_squared_error(y_test, y_test_pred)))
    mae_test = float(mean_absolute_error(y_test, y_test_pred))

    # Adjusted R2 on test set
    n_test = len(y_test)
    p_features = len(feature_cols)
    adj_r2_test = float(1.0 - (1.0 - r2_test) * (n_test - 1) / (n_test - p_features - 1))

    # 95% Confidence Intervals for Coefficients (Estadística II)
    n_train = len(y_train)
    p_params = len(feature_cols) + 1  # including intercept
    residuals_train = y_train - y_train_pred
    dof_train = n_train - p_params
    sigma2_train = float(np.sum(residuals_train ** 2) / max(1, dof_train))

    # Design matrix with intercept column for parameter covariance
    x_train_design = np.hstack([np.ones((n_train, 1)), x_train])
    xtx_inv = np.linalg.inv(x_train_design.T @ x_train_design)
    se_coefficients = np.sqrt(np.maximum(0.0, sigma2_train * np.diag(xtx_inv)))

    z_critical = 1.96  # 95% normal critical value for large N
    intercept = float(model.intercept_)
    coefs = [float(c) for c in model.coef_]
    all_coefs = [intercept] + coefs
    all_feat_names = ["intercept"] + feature_cols

    confidence_intervals_95_coefficients: dict[str, dict[str, float]] = {}
    for feat_name, c_val, se_val in zip(all_feat_names, all_coefs, se_coefficients):
        confidence_intervals_95_coefficients[feat_name] = {
            "estimate": round(float(c_val), 4),
            "std_error": round(float(se_val), 4),
            "ci_95_lower": round(float(c_val - z_critical * se_val), 4),
            "ci_95_upper": round(float(c_val + z_critical * se_val), 4),
        }

    # Build human-readable equation string
    terms = [f"{intercept:+.2f}"]
    for feat, coef in zip(feature_cols, coefs):
        terms.append(f"{coef:+.4f} * {feat}")
    equation_str = " ".join(terms)

    coefficients_dict = {"intercept": round(intercept, 4)}
    for feat, coef in zip(feature_cols, coefs):
        coefficients_dict[feat] = round(coef, 4)

    return {
        "model_id": model_name,
        "target_variable": target_col,
        "target_label": target_label,
        "target_unit": target_unit,
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": confidence_intervals_95_coefficients,
        "metrics_train": {
            "r2": round(r2_train, 4),
            "rmse": round(rmse_train, 2),
            "mae": round(mae_train, 2),
        },
        "metrics_test": {
            "r2": round(r2_test, 4),
            "adjusted_r2": round(adj_r2_test, 4),
            "rmse": round(rmse_test, 2),
            "mae": round(mae_test, 2),
            "n_observations": n_test,
        },
        "svd_diagnostics": svd_diagnostics,
        "_fitted_model": model,
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
        "_xtx_inv": xtx_inv,
        "_sigma2": sigma2_train,
    }


def simulate_scenarios(
    fitted_models: dict[str, Any],
) -> list[dict[str, Any]]:
    """Simulates realistic urban mobility scenarios in Managua with cascading predictions."""
    scenarios_input = [
        {
            "scenario_name": "Horario Valle en Temporada Seca",
            "description": "Viaje estándar de mediodía con tráfico fluido y sin precipitación.",
            "distance_km": 6.5,
            "origin_congestion_index": 1.10,
            "origin_precipitation_mm": 0.0,
            "surge_multiplier": 1.00,
        },
        {
            "scenario_name": "Hora Pico Vespertina Seca",
            "description": "Tránsito denso de salida laboral en pistas arteriales sin lluvia.",
            "distance_km": 9.0,
            "origin_congestion_index": 1.65,
            "origin_precipitation_mm": 0.0,
            "surge_multiplier": 1.35,
        },
        {
            "scenario_name": "Tormenta Tropical en Hora Pico",
            "description": "Lluvia torrencial severa con alta fricción y tarifa dinámica elevada.",
            "distance_km": 8.0,
            "origin_congestion_index": 1.85,
            "origin_precipitation_mm": 25.0,
            "surge_multiplier": 1.80,
        },
    ]

    model_eta: LinearRegression = fitted_models["eta_duration"]["_fitted_model"]
    model_speed: LinearRegression = fitted_models["speed_decay"]["_fitted_model"]
    model_fare: LinearRegression = fitted_models["pricing_fare"]["_fitted_model"]

    xtx_inv_eta: np.ndarray = fitted_models["eta_duration"]["_xtx_inv"]
    sigma2_eta: float = float(fitted_models["eta_duration"]["_sigma2"])

    xtx_inv_speed: np.ndarray = fitted_models["speed_decay"]["_xtx_inv"]
    sigma2_speed: float = float(fitted_models["speed_decay"]["_sigma2"])

    xtx_inv_fare: np.ndarray = fitted_models["pricing_fare"]["_xtx_inv"]
    sigma2_fare: float = float(fitted_models["pricing_fare"]["_sigma2"])

    sim_results: list[dict[str, Any]] = []

    for sc in scenarios_input:
        d = float(sc["distance_km"])
        c = float(sc["origin_congestion_index"])
        p = float(sc["origin_precipitation_mm"])
        s = float(sc["surge_multiplier"])

        # 1. Kinematics prediction: speed (km/h) + 95% Confidence / Prediction Interval
        x_speed_vec = np.array([1.0, c, p])
        pred_speed = float(model_speed.predict([[c, p]])[0])
        var_speed_pred = float(sigma2_speed * (1.0 + x_speed_vec.T @ xtx_inv_speed @ x_speed_vec))
        se_speed_pred = float(np.sqrt(max(0.0, var_speed_pred)))

        # 2. Operations prediction: duration (min) + 95% Confidence / Prediction Interval
        x_eta_vec = np.array([1.0, d, c, p])
        pred_duration = float(model_eta.predict([[d, c, p]])[0])
        var_eta_pred = float(sigma2_eta * (1.0 + x_eta_vec.T @ xtx_inv_eta @ x_eta_vec))
        se_eta_pred = float(np.sqrt(max(0.0, var_eta_pred)))

        # 3. Cascading economics prediction: fare (NIO) using predicted duration + 95% CI
        x_fare_vec = np.array([1.0, d, pred_duration, s])
        pred_fare = float(model_fare.predict([[d, pred_duration, s]])[0])
        var_fare_pred = float(sigma2_fare * (1.0 + x_fare_vec.T @ xtx_inv_fare @ x_fare_vec))
        se_fare_pred = float(np.sqrt(max(0.0, var_fare_pred)))

        sim_results.append({
            "scenario_name": sc["scenario_name"],
            "description": sc["description"],
            "inputs": {
                "distance_km": d,
                "congestion_index": c,
                "precipitation_mm": p,
                "surge_multiplier": s,
            },
            "predictions": {
                "effective_speed_kmh": {
                    "estimate": round(pred_speed, 1),
                    "ci_95_lower": round(max(0.0, pred_speed - 1.96 * se_speed_pred), 1),
                    "ci_95_upper": round(pred_speed + 1.96 * se_speed_pred, 1),
                    "margin_error": round(1.96 * se_speed_pred, 1),
                    "unit": "km/h",
                },
                "duration_minutes": {
                    "estimate": round(pred_duration, 1),
                    "ci_95_lower": round(max(0.0, pred_duration - 1.96 * se_eta_pred), 1),
                    "ci_95_upper": round(pred_duration + 1.96 * se_eta_pred, 1),
                    "margin_error": round(1.96 * se_eta_pred, 1),
                    "unit": "minutos",
                },
                "final_fare_nio": {
                    "estimate": round(pred_fare, 2),
                    "ci_95_lower": round(max(0.0, pred_fare - 1.96 * se_fare_pred), 2),
                    "ci_95_upper": round(pred_fare + 1.96 * se_fare_pred, 2),
                    "margin_error": round(1.96 * se_fare_pred, 2),
                    "unit": "NIO",
                },
            },
        })

    return sim_results


# -----------------------------------------------------------------------------
# Visualization Functions
# -----------------------------------------------------------------------------
def plot_duration_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates actual vs. predicted plot for the ETA Duration model."""
    y_test: np.ndarray = model_results["_test_actual"]
    y_pred: np.ndarray = model_results["_test_pred"]
    r2 = model_results["metrics_test"]["r2"]
    mae = model_results["metrics_test"]["mae"]

    # Sample 2000 points for clear visual rendering without clutter
    idx = np.random.choice(len(y_test), size=min(2500, len(y_test)), replace=False)
    y_sub = y_test[idx]
    p_sub = y_pred[idx]

    plt.figure(figsize=(8, 6), dpi=300)
    plt.scatter(y_sub, p_sub, alpha=0.35, color=COLOR_PRIMARY, edgecolors="none", s=22, label="Viajes Observados (Test)")

    # 45-degree reference line
    lims = [0, max(np.max(y_sub), np.max(p_sub)) + 5]
    plt.plot(lims, lims, color=COLOR_ACCENT, linestyle="--", linewidth=2.0, label="Predicción Perfecta (y = x)")

    # Linear fit of predictions
    poly = np.poly1d(np.polyfit(y_sub, p_sub, deg=1))
    x_line = np.linspace(lims[0], lims[1], 100)
    plt.plot(x_line, poly(x_line), color=COLOR_DANGER, linestyle="-", linewidth=1.5, label="Ajuste Empírico SVD")

    plt.title("Modelo 1: Estimación de Tiempo de Viaje (ETA)\nPredicción Multivariable vía Mínimos Cuadrados SVD", fontsize=12, pad=12, fontweight="bold")
    plt.xlabel("Duración Real del Viaje (minutos)", fontsize=11)
    plt.ylabel("Duración Predicha (minutos)", fontsize=11)
    plt.xlim(0, max(np.max(y_sub), np.max(p_sub)) + 2)
    plt.ylim(0, max(np.max(y_sub), np.max(p_sub)) + 2)
    plt.grid(True, linestyle=":", alpha=0.6)

    # Info box
    textstr = f"$R^2 = {r2:.4f}$\n$MAE = {mae:.2f}$ min\n$N_{{test}} = {len(y_test):,}$"
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.9)
    plt.gca().text(0.05, 0.92, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="lower right", framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


def plot_speed_decay_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates speed degradation curves across congestion and rain levels."""
    model: LinearRegression = model_results["_fitted_model"]
    r2 = model_results["metrics_test"]["r2"]

    # Congestion range: 1.0 to 2.0
    c_vals = np.linspace(1.0, 2.0, 100)

    plt.figure(figsize=(8, 6), dpi=300)

    rain_scenarios = [
        (0.0, "Sin lluvia (0 mm)", COLOR_PRIMARY, "-"),
        (10.0, "Lluvia moderada (10 mm)", COLOR_ACCENT, "--"),
        (25.0, "Tormenta severa (25 mm)", COLOR_DANGER, "-."),
    ]

    for rain, label, color, style in rain_scenarios:
        x_eval = np.column_stack([c_vals, np.full_like(c_vals, rain)])
        speed_pred = model.predict(x_eval)
        plt.plot(c_vals, speed_pred, label=label, color=color, linestyle=style, linewidth=2.2)

    plt.title("Modelo 2: Decaimiento de Velocidad Vehicular Urbana\nImpacto de la Fricción Vial y Lluvia en Managua", fontsize=12, pad=12, fontweight="bold")
    plt.xlabel("Índice de Congestión en Cuadrante de Origen", fontsize=11)
    plt.ylabel("Velocidad Media Efectiva Estimada (km/h)", fontsize=11)
    plt.xlim(1.0, 2.0)
    plt.ylim(10, 32)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = f"$R^2 = {r2:.4f}$\nPendiente Congestión: ${model.coef_[0]:.2f}$ km/h"
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.9)
    plt.gca().text(0.05, 0.25, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="upper right", framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


def plot_fare_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates actual vs. predicted plot for the dynamic pricing fare model."""
    y_test: np.ndarray = model_results["_test_actual"]
    y_pred: np.ndarray = model_results["_test_pred"]
    r2 = model_results["metrics_test"]["r2"]
    mae = model_results["metrics_test"]["mae"]

    idx = np.random.choice(len(y_test), size=min(2500, len(y_test)), replace=False)
    y_sub = y_test[idx]
    p_sub = y_pred[idx]

    plt.figure(figsize=(8, 6), dpi=300)
    plt.scatter(y_sub, p_sub, alpha=0.35, color=COLOR_SUCCESS, edgecolors="none", s=22, label="Tarifas Facturadas (Test)")

    lims = [0, max(np.max(y_sub), np.max(p_sub)) + 50]
    plt.plot(lims, lims, color=COLOR_ACCENT, linestyle="--", linewidth=2.0, label="Facturación Exacta (y = x)")

    poly = np.poly1d(np.polyfit(y_sub, p_sub, deg=1))
    x_line = np.linspace(lims[0], lims[1], 100)
    plt.plot(x_line, poly(x_line), color=COLOR_DANGER, linestyle="-", linewidth=1.5, label="Ajuste Algorítmico MCO")

    plt.title("Modelo 3: Estimación de Tarifa Final del Servicio\nModelado de Precio por Distancia, Tiempo y Multiplicador Surge", fontsize=12, pad=12, fontweight="bold")
    plt.xlabel("Tarifa Final Real (NIO)", fontsize=11)
    plt.ylabel("Tarifa Final Predicha (NIO)", fontsize=11)
    plt.xlim(0, max(np.max(y_sub), np.max(p_sub)) + 20)
    plt.ylim(0, max(np.max(y_sub), np.max(p_sub)) + 20)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = f"$R^2 = {r2:.4f}$\n$MAE = {mae:.2f}$ NIO\n$N_{{test}} = {len(y_test):,}$"
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.9)
    plt.gca().text(0.05, 0.92, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="lower right", framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


# -----------------------------------------------------------------------------
# Main Execution Pipeline
# -----------------------------------------------------------------------------
def main() -> None:
    print("=" * 80)
    print("🔬 MoviGo: Métodos Numéricos & Regresión Multivariable (SVD / LAPACK)")
    print("=" * 80)

    OUTPUT_DATA_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_GRAPHS_DIR.mkdir(parents=True, exist_ok=True)

    print("▶ 1. Extrayendo dataset analítico desde DuckDB...")
    df = load_dataset(DB_PATH)
    total_obs = len(df)
    print(f"   ✓ Registros extraídos de viajes completados: N = {total_obs:,}")

    print(f"▶ 2. Partición Train/Test Split ({int((1-TEST_SIZE)*100)}/{int(TEST_SIZE*100)})...")
    train_split, test_split = train_test_split(df, test_size=TEST_SIZE, random_state=RANDOM_STATE)
    train_df = cast(pd.DataFrame, train_split)
    test_df = cast(pd.DataFrame, test_split)
    print(f"   ✓ Conjunto de Entrenamiento: N_train = {len(train_df):,}")
    print(f"   ✓ Conjunto de Prueba:       N_test  = {len(test_df):,}")

    print("▶ 3. Ajustando y diagnosticando los 3 modelos numéricos...")

    # Model 1: ETA Duration
    res_eta = fit_and_evaluate_model(
        model_name="eta_duration",
        target_col="duration_minutes",
        feature_cols=["distance_km", "origin_congestion_index", "origin_precipitation_mm"],
        target_label="Duración del Viaje (ETA)",
        target_unit="minutos",
        train_df=train_df,
        test_df=test_df,
    )
    print(f"   ✓ Modelo 1 (ETA / Duración):     R²_test = {res_eta['metrics_test']['r2']:.4f} | MAE = {res_eta['metrics_test']['mae']:.2f} min")

    # Model 2: Effective Speed Decay
    res_speed = fit_and_evaluate_model(
        model_name="speed_decay",
        target_col="effective_speed_kmh",
        feature_cols=["origin_congestion_index", "origin_precipitation_mm"],
        target_label="Velocidad Media Efectiva",
        target_unit="km/h",
        train_df=train_df,
        test_df=test_df,
    )
    print(f"   ✓ Modelo 2 (Velocidad Efectiva): R²_test = {res_speed['metrics_test']['r2']:.4f} | MAE = {res_speed['metrics_test']['mae']:.2f} km/h")

    # Model 3: Pricing Final Fare
    res_fare = fit_and_evaluate_model(
        model_name="pricing_fare",
        target_col="final_fare",
        feature_cols=["distance_km", "duration_minutes", "surge_multiplier"],
        target_label="Tarifa Final del Servicio",
        target_unit="NIO (córdobas)",
        train_df=train_df,
        test_df=test_df,
    )
    print(f"   ✓ Modelo 3 (Tarifa Final / Pricing): R²_test = {res_fare['metrics_test']['r2']:.4f} | MAE = {res_fare['metrics_test']['mae']:.2f} NIO")

    fitted_models = {
        "eta_duration": res_eta,
        "speed_decay": res_speed,
        "pricing_fare": res_fare,
    }

    print("▶ 4. Simulando escenarios de movilidad urbana en cascada (con Intervalos al 95%)...")
    scenarios = simulate_scenarios(fitted_models)
    for sc in scenarios:
        p = sc["predictions"]
        print(
            f"   • [{sc['scenario_name']}]:\n"
            f"       - Vel:      {p['effective_speed_kmh']['estimate']} km/h (IC 95%: [{p['effective_speed_kmh']['ci_95_lower']}, {p['effective_speed_kmh']['ci_95_upper']}])\n"
            f"       - Duración: {p['duration_minutes']['estimate']} min (IC 95%: [{p['duration_minutes']['ci_95_lower']}, {p['duration_minutes']['ci_95_upper']}])\n"
            f"       - Tarifa:   {p['final_fare_nio']['estimate']} NIO (IC 95%: [{p['final_fare_nio']['ci_95_lower']}, {p['final_fare_nio']['ci_95_upper']}])"
        )

    print("▶ 5. Generando visualizaciones diagnósticas de alta resolución (300 DPI)...")
    plot_duration_model(res_eta, OUTPUT_GRAPHS_DIR / "numerical_duration.png")
    plot_speed_decay_model(res_speed, OUTPUT_GRAPHS_DIR / "numerical_speed.png")
    plot_fare_model(res_fare, OUTPUT_GRAPHS_DIR / "numerical_fare.png")
    print("   ✓ Gráficos guardados en typst/graphs/ (numerical_duration.png, numerical_speed.png, numerical_fare.png)")

    print("▶ 6. Exportando métricas, coeficientes e intervalos a typst/data/numerical_methods.json...")
    clean_models = {}
    for key, mod in fitted_models.items():
        copy_mod = {k: v for k, v in mod.items() if not k.startswith("_")}
        clean_models[key] = copy_mod

    export_payload = {
        "metadata": {
            "title": "MoviGo: Modelado de Regresión Multivariable mediante Métodos Numéricos y Estadística II",
            "academic_context": "Proyecto Integrador IV (UNAN-Managua) - Asignaturas: Métodos Numéricos (SVD / MCO) y Estadística II (Intervalos de Confianza al 95%)",
            "solver": "Descomposición en Valores Singulares (SVD) vía LAPACK dgelsd (scikit-learn)",
            "inference_framework": "Inferencia por Intervalos de Confianza al 95% para Coeficientes y Predicciones",
            "confidence_level": 0.95,
            "z_critical": 1.96,
            "n_total_observations": total_obs,
            "train_test_split_ratio": f"{int((1-TEST_SIZE)*100)}/{int(TEST_SIZE*100)}",
            "random_seed": RANDOM_STATE,
        },
        "models": clean_models,
        "simulated_scenarios": scenarios,
    }

    json_path = OUTPUT_DATA_DIR / "numerical_methods.json"
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(export_payload, f, indent=2, ensure_ascii=False)

    print(f"   ✓ JSON exportado con éxito en: {json_path}")
    print("=" * 80)
    print("🎉 Suite de Métodos Numéricos completada exitosamente.")
    print("=" * 80)


if __name__ == "__main__":
    main()
