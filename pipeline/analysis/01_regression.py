#!/usr/bin/env python3
"""
MoviGo Operations: Numerical Methods & Simple Linear Regression via Gradient Descent
-------------------------------------------------------------------------------------
Implements the Numerical Methods and Statistics II curricular integration for
MoviGo (UNAN-Managua). Models the fundamental operational and economic dimensions
of urban ride-hailing mobility via Simple Bivariate Linear Regressions (1 Input -> 1 Output)
solved through Stochastic Gradient Descent (SGD / Descenso de Gradiente) using scikit-learn.

The suite defines two dedicated, decoupled functions for fitting and testing
each simple bivariate model independently:
  1. fit_eta_duration_model():
     duration_minutes = f(distance_km)
     - Input (X): distance_km (Trip distance in km)
     - Output (Y): duration_minutes (Trip duration in minutes)
  2. fit_pricing_fare_model():
     final_fare = f(distance_km)
     - Input (X): distance_km (Trip distance in km)
     - Output (Y): final_fare (Total fare charged in NIO)

Data Partitioning:
  Divided strictly into 80% train and 20% test subsets using scikit-learn's
  train_test_split helper with fixed random seed (42), ensuring exact reproducibility
  without dataset resets.

Theoretical Foundations:
  - Numerical Methods: Gradient Descent optimization rule beta(k+1) = beta(k) - eta * grad(L).
    Minimizes the Mean Squared Error loss iteratively with standardized feature scaling,
    avoiding complex matrix inversions while demonstrating iterative optimization.
  - Statistics II: Out-of-sample metrics (R^2, RMSE, MAE) on the unseen 20% test partition,
    plus analytical 95% confidence intervals for parameter estimates (intercept & slope).

Outputs:
  - JSON data: typst/data/numerical_methods.json
  - Plot 1: typst/graphs/numerical_duration.png (Direct 2D: distance_km -> duration_minutes)
  - Plot 2: typst/graphs/numerical_fare.png (Direct 2D: distance_km -> final_fare)
  - Distribution plots: typst/graphs/distributions/
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, cast

import duckdb
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import gaussian_kde, skew
from sklearn.linear_model import SGDRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

# -----------------------------------------------------------------------------
# Configuration and Constants
# -----------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
DB_PATH = PROJECT_ROOT / "pipeline" / "data" / "analytics.duckdb"
OUTPUT_DATA_DIR = PROJECT_ROOT / "typst" / "data"
OUTPUT_GRAPHS_DIR = PROJECT_ROOT / "typst" / "graphs"
OUTPUT_DISTRIBUTIONS_DIR = OUTPUT_GRAPHS_DIR / "distributions"

RANDOM_STATE = 42
TRAIN_RATIO = 0.80
TEST_RATIO = 0.20
Z_CRITICAL_95 = 1.96

# Palette aligned with MoviGo design guidelines
COLOR_PRIMARY = "#1e3a8a"    # Dark navy blue
COLOR_SECONDARY = "#0284c7"  # Sky blue
COLOR_ACCENT = "#d97706"     # Amber / Warning
COLOR_DANGER = "#dc2626"     # Coral red
COLOR_SUCCESS = "#16a34a"    # Forest green
COLOR_MUTED = "#64748b"      # Slate grey


def load_dataset(db_path: Path) -> pd.DataFrame:
    """Extracts completed trip records with vehicle telemetry from DuckDB."""
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

    # Preprocessing: transformations for distribution logging
    df["log_origin_precipitation"] = np.log1p(df["origin_precipitation_mm"])
    df["log_origin_congestion"] = np.log(df["origin_congestion_index"])
    df["log_duration_minutes"] = np.log(df["duration_minutes"])
    df["log_final_fare"] = np.log(df["final_fare"])
    return df


def compute_gradient_descent_diagnostics(
    sgd_model: SGDRegressor,
    feature_names: list[str],
) -> dict[str, Any]:
    """Extracts iterative optimization metrics and convergence parameters (Numerical Methods)."""
    return {
        "numerical_method": "Descenso de Gradiente Estocástico (SGD / Gradient Descent)",
        "loss_function": "Squared Error (Error Cuadrático Medio: 0.5 * (y - y_hat)^2)",
        "optimization_rule": "beta^(k+1) = beta^(k) - eta * grad(L)",
        "learning_rate_schedule": str(sgd_model.learning_rate),
        "initial_learning_rate_eta0": float(sgd_model.eta0),
        "convergence_tolerance": float(sgd_model.tol) if sgd_model.tol is not None else 1e-4,
        "iterations_to_convergence": int(sgd_model.n_iter_) if sgd_model.n_iter_ is not None else 0,
        "n_samples_seen": int(sgd_model.t_) if hasattr(sgd_model, "t_") else 0,
        "features_standardized": True,
        "features_list": feature_names,
    }


def compute_parameter_confidence_intervals(
    beta_0: float,
    beta_coefs: np.ndarray,
    x_train: np.ndarray,
    y_train: np.ndarray,
    feature_names: list[str],
) -> dict[str, dict[str, float]]:
    """Calculates 95% confidence intervals for linear regression parameters (Statistics II)."""
    n_train = len(y_train)
    p_params = len(feature_names) + 1  # including intercept

    y_train_pred = beta_0 + x_train @ beta_coefs
    residuals = y_train - y_train_pred
    dof = max(1, n_train - p_params)
    sigma2 = float(np.sum(residuals ** 2) / dof)

    # Variance-covariance matrix of parameter estimates: Var(beta) = sigma^2 * (X^T X)^(-1)
    x_design = np.hstack([np.ones((n_train, 1)), x_train])
    xtx_inv = np.linalg.inv(x_design.T @ x_design)
    se_coefficients = np.sqrt(np.maximum(0.0, sigma2 * np.diag(xtx_inv)))

    all_coefs = [beta_0] + [float(c) for c in beta_coefs]
    all_names = ["intercept"] + feature_names

    ci_dict: dict[str, dict[str, float]] = {}
    for name, est, se in zip(all_names, all_coefs, se_coefficients):
        ci_dict[name] = {
            "estimate": round(est, 4),
            "std_error": round(float(se), 4),
            "ci_95_lower": round(float(est - Z_CRITICAL_95 * se), 4),
            "ci_95_upper": round(float(est + Z_CRITICAL_95 * se), 4),
        }
    return ci_dict


def extract_unscaled_coefficients(pipeline: Pipeline) -> tuple[float, np.ndarray]:
    """
    Recovers unscaled intercept and regression coefficients from standard-scaled SGD pipeline.
    y = w_scaled * ((x - mu) / sigma) + b_scaled
      = (w_scaled / sigma) * x + (b_scaled - sum(w_scaled * mu / sigma))
    """
    scaler = cast(StandardScaler, pipeline.named_steps["scaler"])
    sgd = cast(SGDRegressor, pipeline.named_steps["sgd"])

    assert scaler.mean_ is not None
    assert scaler.scale_ is not None
    assert sgd.intercept_ is not None

    w: np.ndarray = np.asarray(sgd.coef_, dtype=np.float64)
    mu: np.ndarray = np.asarray(scaler.mean_, dtype=np.float64)
    scale: np.ndarray = np.asarray(scaler.scale_, dtype=np.float64)

    beta_coefs: np.ndarray = w / scale
    beta_0 = float(sgd.intercept_[0] - np.sum(w * mu / scale))
    return beta_0, beta_coefs


def create_sgd_pipeline() -> Pipeline:
    """Instantiates a normalized Stochastic Gradient Descent regression pipeline."""
    scaler = StandardScaler()
    sgd = SGDRegressor(
        loss="squared_error",
        penalty=cast(Any, None),
        max_iter=2000,
        tol=1e-4,
        random_state=RANDOM_STATE,
        eta0=0.01,
        learning_rate="invscaling",
    )
    return Pipeline([("scaler", scaler), ("sgd", sgd)])


# =============================================================================
# DEDICATED MODEL FUNCTIONS (Independent Fitting & Testing: 1 Input -> 1 Output)
# =============================================================================

def fit_eta_duration_model(
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """
    Model 1: Operational ETA Duration Simple Model (1 Input -> 1 Output)
    -------------------------------------------------------------------
    Formula: duration_minutes = beta0 + beta1 * distance_km
    Solves for estimated trip duration directly from distance in km
    via Stochastic Gradient Descent (SGDRegressor).
    """
    feature_cols = ["distance_km"]
    target_col = "duration_minutes"

    x_train_df = train_df[feature_cols]
    y_train = train_df[target_col].to_numpy()
    x_test_df = test_df[feature_cols]
    y_test = test_df[target_col].to_numpy()

    # Numerical Methods: Descenso de Gradiente (SGD) con estandarización de variables
    pipeline = create_sgd_pipeline()
    pipeline.fit(x_train_df, y_train)

    # In-sample (train) metrics
    y_train_pred = pipeline.predict(x_train_df)
    r2_train = float(r2_score(y_train, y_train_pred))
    rmse_train = float(np.sqrt(mean_squared_error(y_train, y_train_pred)))
    mae_train = float(mean_absolute_error(y_train, y_train_pred))

    # Out-of-sample (test) metrics
    y_test_pred = pipeline.predict(x_test_df)
    r2_test = float(r2_score(y_test, y_test_pred))
    rmse_test = float(np.sqrt(mean_squared_error(y_test, y_test_pred)))
    mae_test = float(mean_absolute_error(y_test, y_test_pred))

    n_test = len(y_test)
    p_features = len(feature_cols)
    adj_r2_test = float(1.0 - (1.0 - r2_test) * (n_test - 1) / (n_test - p_features - 1))

    # Analytical unscaling of weights
    beta_0, beta_coefs = extract_unscaled_coefficients(pipeline)
    fitted_sgd = cast(SGDRegressor, pipeline.named_steps["sgd"])

    # Descenso de Gradiente optimization diagnostics
    sgd_diagnostics = compute_gradient_descent_diagnostics(fitted_sgd, feature_cols)

    # Statistics II: 95% Confidence Intervals for unscaled parameters
    ci_dict = compute_parameter_confidence_intervals(
        beta_0, beta_coefs, x_train_df.to_numpy(), y_train, feature_cols
    )

    equation_str = f"{beta_0:+.4f} + {beta_coefs[0]:.4f} * distance_km"

    coefficients_dict = {
        "intercept": round(beta_0, 4),
        "distance_km": round(float(beta_coefs[0]), 4),
    }

    return {
        "model_id": "eta_duration",
        "model_type": "Regresión Lineal Simple (1 Entrada -> 1 Salida)",
        "target_variable": target_col,
        "target_label": "Duración del Viaje (ETA)",
        "target_unit": "minutos",
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": ci_dict,
        "metrics_train": {
            "r2": round(r2_train, 4),
            "rmse": round(rmse_train, 4),
            "mae": round(mae_train, 4),
        },
        "metrics_test": {
            "r2": round(r2_test, 4),
            "adjusted_r2": round(adj_r2_test, 4),
            "rmse": round(rmse_test, 4),
            "mae": round(mae_test, 4),
            "n_observations": n_test,
        },
        "gradient_descent_diagnostics": sgd_diagnostics,
        "_pipeline": pipeline,
        "_test_x": test_df["distance_km"].to_numpy(),
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
    }


def fit_pricing_fare_model(
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """
    Model 2: Economic Pricing Fare Simple Model (1 Input -> 1 Output)
    -----------------------------------------------------------------
    Formula: final_fare = beta0 + beta1 * distance_km
    Models the fare in Nicaraguan Cordobas (NIO) directly from distance in km
    via Stochastic Gradient Descent (SGDRegressor).
    """
    feature_cols = ["distance_km"]
    target_col = "final_fare"

    x_train_df = train_df[feature_cols]
    y_train = train_df[target_col].to_numpy()
    x_test_df = test_df[feature_cols]
    y_test = test_df[target_col].to_numpy()

    pipeline = create_sgd_pipeline()
    pipeline.fit(x_train_df, y_train)

    # Train metrics
    y_train_pred = pipeline.predict(x_train_df)
    r2_train = float(r2_score(y_train, y_train_pred))
    rmse_train = float(np.sqrt(mean_squared_error(y_train, y_train_pred)))
    mae_train = float(mean_absolute_error(y_train, y_train_pred))

    # Test metrics
    y_test_pred = pipeline.predict(x_test_df)
    r2_test = float(r2_score(y_test, y_test_pred))
    rmse_test = float(np.sqrt(mean_squared_error(y_test, y_test_pred)))
    mae_test = float(mean_absolute_error(y_test, y_test_pred))

    n_test = len(y_test)
    p_features = len(feature_cols)
    adj_r2_test = float(1.0 - (1.0 - r2_test) * (n_test - 1) / (n_test - p_features - 1))

    # Unscaling
    beta_0, beta_coefs = extract_unscaled_coefficients(pipeline)
    fitted_sgd = cast(SGDRegressor, pipeline.named_steps["sgd"])

    # Diagnostics
    sgd_diagnostics = compute_gradient_descent_diagnostics(fitted_sgd, feature_cols)

    # Statistics II: 95% Confidence Intervals
    ci_dict = compute_parameter_confidence_intervals(
        beta_0, beta_coefs, x_train_df.to_numpy(), y_train, feature_cols
    )

    equation_str = f"{beta_0:+.4f} + {beta_coefs[0]:.4f} * distance_km"

    coefficients_dict = {
        "intercept": round(beta_0, 4),
        "distance_km": round(float(beta_coefs[0]), 4),
    }

    return {
        "model_id": "pricing_fare",
        "model_type": "Regresión Lineal Simple (1 Entrada -> 1 Salida)",
        "target_variable": target_col,
        "target_label": "Tarifa Final del Servicio",
        "target_unit": "NIO (Córdobas)",
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": ci_dict,
        "metrics_train": {
            "r2": round(r2_train, 4),
            "rmse": round(rmse_train, 4),
            "mae": round(mae_train, 4),
        },
        "metrics_test": {
            "r2": round(r2_test, 4),
            "adjusted_r2": round(adj_r2_test, 4),
            "rmse": round(rmse_test, 4),
            "mae": round(mae_test, 4),
            "n_observations": n_test,
        },
        "gradient_descent_diagnostics": sgd_diagnostics,
        "_pipeline": pipeline,
        "_test_x": test_df["distance_km"].to_numpy(),
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
    }


# =============================================================================
# VISUALIZATION PLOTS (High Resolution 300 DPI on Test Partition: Direct 2D)
# =============================================================================

def plot_duration_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates direct 2D regression plot: distance_km vs. duration_minutes."""
    x_test: np.ndarray = model_results["_test_x"]
    y_test: np.ndarray = model_results["_test_actual"]
    pipeline: Pipeline = model_results["_pipeline"]
    feature_cols: list[str] = model_results["predictor_variables"]
    r2 = model_results["metrics_test"]["r2"]
    mae = model_results["metrics_test"]["mae"]
    rmse = model_results["metrics_test"]["rmse"]
    b0 = model_results["coefficients"]["intercept"]
    b1 = model_results["coefficients"]["distance_km"]

    # Subsample points for crisp, non-cluttered rendering
    idx = np.random.choice(len(y_test), size=min(2500, len(y_test)), replace=False)
    x_sub = x_test[idx]
    y_sub = y_test[idx]

    plt.figure(figsize=(8, 6), dpi=300)
    plt.scatter(
        x_sub,
        y_sub,
        alpha=0.35,
        color=COLOR_PRIMARY,
        edgecolors="none",
        s=22,
        label=f"Viajes Observados (Test: N = {len(y_test):,})",
    )

    # Compute regression line directly across observed distance range
    x_grid = np.linspace(float(np.min(x_test)), float(np.percentile(x_test, 99.8)), 200)
    y_grid = pipeline.predict(pd.DataFrame(x_grid, columns=feature_cols))

    plt.plot(
        x_grid,
        y_grid,
        color=COLOR_DANGER,
        linestyle="-",
        linewidth=2.4,
        label=f"Ajuste SGD: $\\hat{{y}} = {b0:.2f} + {b1:.2f}x$",
    )

    plt.title(
        "Modelo 1: Regresión Lineal Simple de Tiempo de Viaje (ETA)\n"
        "Relación Directa: Distancia Recorrida vs. Duración del Viaje (SGD)",
        fontsize=11,
        pad=12,
        fontweight="bold",
    )
    plt.xlabel("Distancia del Viaje (kilómetros)", fontsize=11)
    plt.ylabel("Duración del Viaje (minutos)", fontsize=11)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = (
        f"$R^2 = {r2:.4f}$\n"
        f"$MAE = {mae:.2f}$ min\n"
        f"$RMSE = {rmse:.2f}$ min\n"
        f"Pendiente: {b1:.2f} min/km\n"
        f"Método: Descenso de Gradiente (SGD)"
    )
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.92)
    plt.gca().text(0.05, 0.92, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="upper left", bbox_to_anchor=(0.04, 0.63), framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


def plot_fare_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates direct 2D regression plot: distance_km vs. final_fare."""
    x_test: np.ndarray = model_results["_test_x"]
    y_test: np.ndarray = model_results["_test_actual"]
    pipeline: Pipeline = model_results["_pipeline"]
    feature_cols: list[str] = model_results["predictor_variables"]
    r2 = model_results["metrics_test"]["r2"]
    mae = model_results["metrics_test"]["mae"]
    rmse = model_results["metrics_test"]["rmse"]
    b0 = model_results["coefficients"]["intercept"]
    b1 = model_results["coefficients"]["distance_km"]

    # Subsample points for clean scatter rendering
    idx = np.random.choice(len(y_test), size=min(2500, len(y_test)), replace=False)
    x_sub = x_test[idx]
    y_sub = y_test[idx]

    plt.figure(figsize=(8, 6), dpi=300)
    plt.scatter(
        x_sub,
        y_sub,
        alpha=0.35,
        color=COLOR_SUCCESS,
        edgecolors="none",
        s=22,
        label=f"Tarifas Facturadas (Test: N = {len(y_test):,})",
    )

    # Compute regression line directly across observed distance range
    x_grid = np.linspace(float(np.min(x_test)), float(np.percentile(x_test, 99.8)), 200)
    y_grid = pipeline.predict(pd.DataFrame(x_grid, columns=feature_cols))

    plt.plot(
        x_grid,
        y_grid,
        color=COLOR_DANGER,
        linestyle="-",
        linewidth=2.4,
        label=f"Ajuste SGD: $\\hat{{y}} = {b0:.2f} + {b1:.2f}x$",
    )

    plt.title(
        "Modelo 2: Regresión Lineal Simple de Tarificación del Servicio\n"
        "Relación Directa: Distancia Recorrida vs. Tarifa Cobrada (SGD)",
        fontsize=11,
        pad=12,
        fontweight="bold",
    )
    plt.xlabel("Distancia del Viaje (kilómetros)", fontsize=11)
    plt.ylabel("Tarifa Final del Viaje (Córdobas - NIO)", fontsize=11)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = (
        f"$R^2 = {r2:.4f}$\n"
        f"$MAE = {mae:.2f}$ NIO\n"
        f"$RMSE = {rmse:.2f}$ NIO\n"
        f"Tarifa Base: {b0:.2f} NIO\n"
        f"Costo por km: {b1:.2f} NIO/km\n"
        f"Método: Descenso de Gradiente (SGD)"
    )
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.92)
    plt.gca().text(0.05, 0.92, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="upper left", bbox_to_anchor=(0.04, 0.60), framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


def plot_variable_distributions(df: pd.DataFrame, output_dir: Path) -> dict[str, Any]:
    """Generates standalone probability density histograms (300 DPI) for all regression variables."""
    output_dir.mkdir(parents=True, exist_ok=True)
    configs: list[dict[str, Any]] = [
        {
            "col": "distance_km",
            "title": "Distribución: Distancia de Recorrido",
            "xlabel": "Distancia del Viaje (km)",
            "color": COLOR_SECONDARY,
            "unit": "km",
            "bins": 40,
            "filename": "dist_distance_km.png",
        },
        {
            "col": "duration_minutes",
            "title": "Distribución: Duración del Viaje (ETA)",
            "xlabel": "Duración del Viaje (minutos)",
            "color": COLOR_PRIMARY,
            "unit": "min",
            "bins": 45,
            "filename": "dist_duration_minutes.png",
        },
        {
            "col": "final_fare",
            "title": "Distribución: Tarifa Cobrada al Pasajero",
            "xlabel": "Tarifa Final (Córdobas - NIO)",
            "color": COLOR_SUCCESS,
            "unit": "NIO",
            "bins": 45,
            "filename": "dist_final_fare.png",
        },
        {
            "col": "origin_congestion_index",
            "title": "Distribución: Congestión Vial en Origen",
            "xlabel": "Índice de Congestión en Origen",
            "color": COLOR_ACCENT,
            "unit": "índice",
            "bins": 40,
            "filename": "dist_origin_congestion_index.png",
        },
        {
            "col": "origin_precipitation_mm",
            "title": "Distribución: Precipitación Pluvial en Origen",
            "xlabel": "Precipitación Pluvial (mm)",
            "color": "#0ea5e9",
            "unit": "mm",
            "bins": 40,
            "filename": "dist_origin_precipitation_mm.png",
        },
        {
            "col": "surge_multiplier",
            "title": "Distribución: Multiplicador de Tarifa Dinámica (Surge)",
            "xlabel": "Factor Multiplicador Surge (x)",
            "color": "#8b5cf6",
            "unit": "factor",
            "bins": 30,
            "filename": "dist_surge_multiplier.png",
        },
    ]

    distribution_summary: dict[str, Any] = {}

    for cfg in configs:
        col = cfg["col"]
        data = df[col].dropna().to_numpy()

        mean_val = float(np.mean(data))
        median_val = float(np.median(data))
        std_val = float(np.std(data))
        p25_val = float(np.percentile(data, 25))
        p75_val = float(np.percentile(data, 75))
        skew_val = float(skew(data))

        distribution_summary[col] = {
            "mean": round(mean_val, 3),
            "median": round(median_val, 3),
            "std": round(std_val, 3),
            "p25": round(p25_val, 3),
            "p75": round(p75_val, 3),
            "skewness": round(skew_val, 3),
            "unit": cfg["unit"],
        }

        plt.figure(figsize=(7.5, 5.2), dpi=300)
        counts, bin_edges, _ = plt.hist(
            data,
            bins=cfg["bins"],
            density=True,
            alpha=0.65,
            color=cfg["color"],
            edgecolor="white",
            linewidth=0.8,
            label="Densidad Observada",
        )

        try:
            kde = gaussian_kde(data)
            x_eval = np.linspace(np.min(data), np.percentile(data, 99.8), 250)
            plt.plot(x_eval, kde(x_eval), color=COLOR_DANGER, linewidth=2.2, label="Curva KDE (Densidad)")
        except Exception:
            pass

        plt.axvline(mean_val, color="#0f172a", linestyle="--", linewidth=1.8, label=f"Media: {mean_val:.2f} {cfg['unit']}")
        plt.axvline(median_val, color="#7c3aed", linestyle=":", linewidth=1.8, label=f"Mediana: {median_val:.2f} {cfg['unit']}")

        plt.title(cfg["title"], fontsize=12, pad=12, fontweight="bold")
        plt.xlabel(cfg["xlabel"], fontsize=10.5)
        plt.ylabel("Densidad de Probabilidad", fontsize=10.5)
        plt.grid(True, linestyle=":", alpha=0.5)

        stats_box = (
            f"$\\mu = {mean_val:.2f}$ {cfg['unit']}\n"
            f"Mediana $= {median_val:.2f}$ {cfg['unit']}\n"
            f"$\\sigma = {std_val:.2f}$ {cfg['unit']}\n"
            f"Asimetría $= {skew_val:+.2f}$"
        )
        props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.92)
        plt.gca().text(0.72, 0.93, stats_box, transform=plt.gca().transAxes, fontsize=9.5, verticalalignment="top", bbox=props)

        plt.legend(loc="upper right", bbox_to_anchor=(0.70, 0.98), fontsize=8.8, framealpha=0.9)
        plt.tight_layout()
        plt.savefig(output_dir / cfg["filename"], dpi=300)
        plt.close()

    return distribution_summary


# =============================================================================
# MAIN PIPELINE EXECUTION
# =============================================================================

def main() -> None:
    print("=" * 80)
    print("🔬 MoviGo: Regresión Lineal Simple vía Descenso de Gradiente (SGD)")
    print("   Métodos Numéricos (Optimización Iterativa) & Estadística II (Inferencia 95% CI)")
    print("=" * 80)

    OUTPUT_DATA_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_GRAPHS_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_DISTRIBUTIONS_DIR.mkdir(parents=True, exist_ok=True)

    print("▶ 1. Extrayendo dataset analítico desde DuckDB...")
    df = load_dataset(DB_PATH)
    total_obs = len(df)
    print(f"   ✓ Registros extraídos de viajes completados: N = {total_obs:,}")

    print(f"▶ 2. Partición limpia con scikit-learn helper ({int(TRAIN_RATIO*100)}% Train / {int(TEST_RATIO*100)}% Test)...")
    train_split, test_split = train_test_split(
        df,
        train_size=TRAIN_RATIO,
        test_size=TEST_RATIO,
        random_state=RANDOM_STATE,
        shuffle=True,
    )
    train_df = cast(pd.DataFrame, train_split)
    test_df = cast(pd.DataFrame, test_split)
    print(f"   ✓ Conjunto de Entrenamiento: N_train = {len(train_df):,} (80%)")
    print(f"   ✓ Conjunto de Prueba:       N_test  = {len(test_df):,} (20%)")

    print("▶ 3. Ajustando y evaluando modelos simples (1 Input -> 1 Output) mediante Descenso de Gradiente (SGDRegressor)...")

    # Dedicated Function 1: ETA Duration Simple Model
    res_eta = fit_eta_duration_model(train_df, test_df)
    print(f"   ✓ Modelo 1 [fit_eta_duration_model] (distance_km -> duration_minutes):")
    print(f"       R² = {res_eta['metrics_test']['r2']:.4f} | MAE = {res_eta['metrics_test']['mae']:.2f} min | RMSE = {res_eta['metrics_test']['rmse']:.2f} min")
    print(f"       Convergencia: {res_eta['gradient_descent_diagnostics']['iterations_to_convergence']} épocas | Regla: {res_eta['gradient_descent_diagnostics']['optimization_rule']}")
    print(f"       Ecuación: {res_eta['equation']}")

    # Dedicated Function 2: Pricing Fare Simple Model
    res_fare = fit_pricing_fare_model(train_df, test_df)
    print(f"   ✓ Modelo 2 [fit_pricing_fare_model] (distance_km -> final_fare):")
    print(f"       R² = {res_fare['metrics_test']['r2']:.4f} | MAE = {res_fare['metrics_test']['mae']:.2f} NIO | RMSE = {res_fare['metrics_test']['rmse']:.2f} NIO")
    print(f"       Convergencia: {res_fare['gradient_descent_diagnostics']['iterations_to_convergence']} épocas | Regla: {res_fare['gradient_descent_diagnostics']['optimization_rule']}")
    print(f"       Ecuación: {res_fare['equation']}")

    fitted_models = {
        "eta_duration": res_eta,
        "pricing_fare": res_fare,
    }

    print("▶ 4. Generando visualizaciones directas 2D (300 DPI) sobre el conjunto Test...")
    plot_duration_model(res_eta, OUTPUT_GRAPHS_DIR / "numerical_duration.png")
    plot_fare_model(res_fare, OUTPUT_GRAPHS_DIR / "numerical_fare.png")
    print("   ✓ Gráficos directos 2D guardados en typst/graphs/ (numerical_duration.png, numerical_fare.png)")

    print("▶ 5. Generando gráficos individuales de distribución de variables en typst/graphs/distributions/...")
    dist_stats = plot_variable_distributions(df, OUTPUT_DISTRIBUTIONS_DIR)
    print(f"   ✓ 6 gráficos de distribución guardados en: {OUTPUT_DISTRIBUTIONS_DIR}")

    print("▶ 6. Exportando métricas, coeficientes, intervalos y distribuciones a typst/data/numerical_methods.json...")
    clean_models = {}
    for key, mod in fitted_models.items():
        copy_mod = {k: v for k, v in mod.items() if not k.startswith("_")}
        clean_models[key] = copy_mod

    export_payload = {
        "metadata": {
            "title": "MoviGo: Modelado de Regresión Simple mediante Métodos Numéricos y Estadística II",
            "academic_context": "Proyecto Integrador IV (UNAN-Managua) - Asignaturas: Métodos Numéricos (Descenso de Gradiente / SGD) y Estadística II (Intervalos de Confianza al 95%)",
            "numerical_solver": "Descenso de Gradiente Estocástico (SGDRegressor vía scikit-learn)",
            "loss_function": "Squared Error (Error Cuadrático: 0.5 * (y - y_hat)^2)",
            "inference_framework": "Inferencia por Intervalos de Confianza al 95% para Coeficientes Paramétricos",
            "confidence_level": 0.95,
            "z_critical": Z_CRITICAL_95,
            "n_total_observations": total_obs,
            "train_test_split_ratio": f"{int(TRAIN_RATIO*100)}/{int(TEST_RATIO*100)}",
            "random_seed": RANDOM_STATE,
        },
        "models": clean_models,
        "variable_distributions": dist_stats,
    }

    json_path = OUTPUT_DATA_DIR / "numerical_methods.json"
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(export_payload, f, indent=2, ensure_ascii=False)

    print(f"   ✓ JSON exportado con éxito en: {json_path}")
    print("=" * 80)
    print("🎉 Suite de Regresión Simple refactorizada con Descenso de Gradiente ejecutada exitosamente.")
    print("=" * 80)


if __name__ == "__main__":
    main()
