#!/usr/bin/env python3
"""
MoviGo Operations: Numerical Methods & Multivariable Regression via Gradient Descent
-------------------------------------------------------------------------------------
Implements the Numerical Methods and Statistics II curricular integration for
MoviGo (UNAN-Managua). Models the physical, operational, and financial dimensions
of urban ride-hailing mobility via Multivariable Linear Regression solved through
Stochastic Gradient Descent (SGD / Descenso de Gradiente) using scikit-learn.

The suite defines three dedicated, decoupled functions for fitting and testing
each model independently:
  1. fit_eta_duration_model():
     duration_minutes = f(distance_km, origin_congestion_index, origin_precipitation_mm)
  2. fit_speed_decay_model():
     effective_speed_kmh = f(origin_congestion_index, origin_precipitation_mm)
  3. fit_pricing_fare_model():
     final_fare = f(distance_km, duration_minutes, surge_multiplier)

Data Partitioning:
  Divided strictly into 80% train and 20% test subsets using scikit-learn's
  train_test_split helper with fixed random seed (42), ensuring exact reproducibility
  without dataset resets.

Theoretical Foundations:
  - Numerical Methods: Gradient Descent optimization rule beta(k+1) = beta(k) - eta * grad(L).
    Minimizes the Mean Squared Error loss iteratively with standardized features, avoiding
    complex matrix inversions and SVD while demonstrating fundamental numerical optimization.
  - Statistics II: In-sample & out-of-sample metrics (R^2, Adjusted R^2, RMSE, MAE) on the
    unseen 20% test partition, plus analytical 95% confidence intervals for parameter estimates.

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
        "convergence_tolerance": float(sgd_model.tol) if sgd_model.tol is not None else 1e-3,
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
            "estimate": round(float(est), 4),
            "std_error": round(float(se), 4),
            "ci_95_lower": round(float(est - Z_CRITICAL_95 * se), 4),
            "ci_95_upper": round(float(est + Z_CRITICAL_95 * se), 4),
        }

    return ci_dict


def extract_unscaled_coefficients(
    pipeline: Pipeline,
) -> tuple[float, np.ndarray]:
    """Extracts unscaled intercept and coefficients from a StandardScaler + SGDRegressor pipeline."""
    scaler = cast(StandardScaler, pipeline.named_steps["scaler"])
    sgd = cast(SGDRegressor, pipeline.named_steps["sgd"])

    assert sgd.coef_ is not None
    assert sgd.intercept_ is not None
    assert scaler.mean_ is not None
    assert scaler.scale_ is not None

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
        max_iter=1000,
        tol=1e-3,
        random_state=RANDOM_STATE,
        eta0=0.01,
        learning_rate="invscaling",
    )
    return Pipeline([("scaler", scaler), ("sgd", sgd)])


# =============================================================================
# DEDICATED MODEL FUNCTIONS (Independent Fitting & Testing)
# =============================================================================

def fit_eta_duration_model(
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """
    Model 1: Operational ETA Duration Model
    ---------------------------------------
    Formula: duration_minutes = beta0 + beta1*distance_km + beta2*origin_congestion_index + beta3*origin_precipitation_mm
    Solves for trip duration using trip distance and origin microclimate / traffic friction
    via Stochastic Gradient Descent (SGDRegressor).
    """
    feature_cols = ["distance_km", "origin_congestion_index", "origin_precipitation_mm"]
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

    # Analytical unscaling of weights to natural physical units
    beta_0, beta_coefs = extract_unscaled_coefficients(pipeline)
    fitted_sgd = cast(SGDRegressor, pipeline.named_steps["sgd"])

    # Descenso de Gradiente optimization diagnostics
    sgd_diagnostics = compute_gradient_descent_diagnostics(fitted_sgd, feature_cols)

    # Statistics II: 95% Confidence Intervals for unscaled parameters
    ci_dict = compute_parameter_confidence_intervals(
        beta_0, beta_coefs, x_train_df.to_numpy(), y_train, feature_cols
    )

    equation_str = (
        f"{beta_0:+.2f} + {beta_coefs[0]:.4f} * distance_km "
        f"+ {beta_coefs[1]:.4f} * origin_congestion_index "
        f"+ {beta_coefs[2]:.4f} * origin_precipitation_mm"
    )

    coefficients_dict = {
        "intercept": round(beta_0, 4),
        "distance_km": round(float(beta_coefs[0]), 4),
        "origin_congestion_index": round(float(beta_coefs[1]), 4),
        "origin_precipitation_mm": round(float(beta_coefs[2]), 4),
    }

    return {
        "model_id": "eta_duration",
        "target_variable": target_col,
        "target_label": "Duración del Viaje (ETA)",
        "target_unit": "minutos",
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": ci_dict,
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
        "gradient_descent_diagnostics": sgd_diagnostics,
        "_pipeline": pipeline,
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
    }


def fit_speed_decay_model(
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """
    Model 2: Physical Kinematics Velocity Decay Model
    --------------------------------------------------
    Formula: effective_speed_kmh = beta0 + beta1*origin_congestion_index + beta2*origin_precipitation_mm
    Models the physical degradation of circulation velocity across Managua's arterial avenues
    via Stochastic Gradient Descent (SGDRegressor).
    """
    feature_cols = ["origin_congestion_index", "origin_precipitation_mm"]
    target_col = "effective_speed_kmh"

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

    equation_str = (
        f"{beta_0:+.2f} + {beta_coefs[0]:.4f} * origin_congestion_index "
        f"+ {beta_coefs[1]:.4f} * origin_precipitation_mm"
    )

    coefficients_dict = {
        "intercept": round(beta_0, 4),
        "origin_congestion_index": round(float(beta_coefs[0]), 4),
        "origin_precipitation_mm": round(float(beta_coefs[1]), 4),
    }

    return {
        "model_id": "speed_decay",
        "target_variable": target_col,
        "target_label": "Velocidad Media Efectiva",
        "target_unit": "km/h",
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": ci_dict,
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
        "gradient_descent_diagnostics": sgd_diagnostics,
        "_pipeline": pipeline,
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
    }


def fit_pricing_fare_model(
    train_df: pd.DataFrame,
    test_df: pd.DataFrame,
) -> dict[str, Any]:
    """
    Model 3: Economic Dynamic Pricing Fare Model
    ---------------------------------------------
    Formula: final_fare = beta0 + beta1*distance_km + beta2*duration_minutes + beta3*surge_multiplier
    Models the fare charged in Nicaraguan Cordobas (NIO) as a function of trip length, time, and surge
    via Stochastic Gradient Descent (SGDRegressor).
    """
    feature_cols = ["distance_km", "duration_minutes", "surge_multiplier"]
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

    equation_str = (
        f"{beta_0:+.2f} + {beta_coefs[0]:.4f} * distance_km "
        f"+ {beta_coefs[1]:.4f} * duration_minutes "
        f"+ {beta_coefs[2]:.4f} * surge_multiplier"
    )

    coefficients_dict = {
        "intercept": round(beta_0, 4),
        "distance_km": round(float(beta_coefs[0]), 4),
        "duration_minutes": round(float(beta_coefs[1]), 4),
        "surge_multiplier": round(float(beta_coefs[2]), 4),
    }

    return {
        "model_id": "pricing_fare",
        "target_variable": target_col,
        "target_label": "Tarifa Final del Servicio",
        "target_unit": "NIO (córdobas)",
        "predictor_variables": feature_cols,
        "equation": equation_str,
        "coefficients": coefficients_dict,
        "confidence_intervals_95_coefficients": ci_dict,
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
        "gradient_descent_diagnostics": sgd_diagnostics,
        "_pipeline": pipeline,
        "_test_actual": y_test,
        "_test_pred": y_test_pred,
    }


# =============================================================================
# VISUALIZATION PLOTS (High Resolution 300 DPI on Test Partition)
# =============================================================================

def plot_duration_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates actual vs. predicted plot for the ETA Duration model."""
    y_test: np.ndarray = model_results["_test_actual"]
    y_pred: np.ndarray = model_results["_test_pred"]
    r2 = model_results["metrics_test"]["r2"]
    mae = model_results["metrics_test"]["mae"]

    idx = np.random.choice(len(y_test), size=min(2500, len(y_test)), replace=False)
    y_sub = y_test[idx]
    p_sub = y_pred[idx]

    plt.figure(figsize=(8, 6), dpi=300)
    plt.scatter(y_sub, p_sub, alpha=0.35, color=COLOR_PRIMARY, edgecolors="none", s=22, label="Viajes Observados (Test)")

    lims = [0, max(np.max(y_sub), np.max(p_sub)) + 5]
    plt.plot(lims, lims, color=COLOR_ACCENT, linestyle="--", linewidth=2.0, label="Predicción Perfecta (y = x)")

    poly = np.poly1d(np.polyfit(y_sub, p_sub, deg=1))
    x_line = np.linspace(lims[0], lims[1], 100)
    plt.plot(x_line, poly(x_line), color=COLOR_DANGER, linestyle="-", linewidth=1.5, label="Ajuste Descenso de Gradiente (SGD)")

    plt.title(
        "Modelo 1: Estimación de Tiempo de Viaje (ETA)\nPredicción Multivariable vía Descenso de Gradiente (SGD)",
        fontsize=12,
        pad=12,
        fontweight="bold",
    )
    plt.xlabel("Duración Real del Viaje (minutos)", fontsize=11)
    plt.ylabel("Duración Predicha (minutos)", fontsize=11)
    plt.xlim(0, max(np.max(y_sub), np.max(p_sub)) + 2)
    plt.ylim(0, max(np.max(y_sub), np.max(p_sub)) + 2)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = f"$R^2 = {r2:.4f}$\n$MAE = {mae:.2f}$ min\n$N_{{test}} = {len(y_test):,}$"
    props = dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor=COLOR_MUTED, alpha=0.9)
    plt.gca().text(0.05, 0.92, textstr, transform=plt.gca().transAxes, fontsize=10, verticalalignment="top", bbox=props)

    plt.legend(loc="lower right", framealpha=0.9)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()


def plot_speed_decay_model(model_results: dict[str, Any], output_path: Path) -> None:
    """Generates speed degradation curves across congestion and rain levels."""
    pipeline: Pipeline = model_results["_pipeline"]
    r2 = model_results["metrics_test"]["r2"]
    coefs = model_results["coefficients"]

    c_vals = np.linspace(1.0, 2.0, 100)

    plt.figure(figsize=(8, 6), dpi=300)

    rain_scenarios = [
        (0.0, "Sin lluvia (0 mm)", COLOR_PRIMARY, "-"),
        (10.0, "Lluvia moderada (10 mm)", COLOR_ACCENT, "--"),
        (25.0, "Tormenta severa (25 mm)", COLOR_DANGER, "-."),
    ]

    for rain, label, color, style in rain_scenarios:
        eval_df = pd.DataFrame({
            "origin_congestion_index": c_vals,
            "origin_precipitation_mm": np.full_like(c_vals, rain),
        })
        speed_pred = pipeline.predict(eval_df)
        plt.plot(c_vals, speed_pred, label=label, color=color, linestyle=style, linewidth=2.2)

    plt.title(
        "Modelo 2: Decaimiento de Velocidad Vehicular Urbana\nImpacto de la Fricción Vial y Lluvia en Managua (SGD)",
        fontsize=12,
        pad=12,
        fontweight="bold",
    )
    plt.xlabel("Índice de Congestión en Cuadrante de Origen", fontsize=11)
    plt.ylabel("Velocidad Media Efectiva Estimada (km/h)", fontsize=11)
    plt.xlim(1.0, 2.0)
    plt.ylim(10, 32)
    plt.grid(True, linestyle=":", alpha=0.6)

    textstr = f"$R^2 = {r2:.4f}$\nPendiente Congestión: ${coefs['origin_congestion_index']:.2f}$ km/h"
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
    plt.plot(x_line, poly(x_line), color=COLOR_DANGER, linestyle="-", linewidth=1.5, label="Ajuste Descenso de Gradiente (SGD)")

    plt.title(
        "Modelo 3: Estimación de Tarifa Final del Servicio\nModelado vía Descenso de Gradiente (Distancia, Duración y Multiplicador)",
        fontsize=12,
        pad=12,
        fontweight="bold",
    )
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


# =============================================================================
# MAIN PIPELINE EXECUTION
# =============================================================================

def main() -> None:
    print("=" * 80)
    print("🔬 MoviGo: Regresión Multivariable vía Descenso de Gradiente (SGD)")
    print("   Métodos Numéricos (Optimización Iterativa) & Estadística II (Inferencia 95% CI)")
    print("=" * 80)

    OUTPUT_DATA_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_GRAPHS_DIR.mkdir(parents=True, exist_ok=True)

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

    print("▶ 3. Ajustando y evaluando cada modelo mediante Descenso de Gradiente (SGDRegressor)...")

    # Dedicated Function 1: ETA Duration Model
    res_eta = fit_eta_duration_model(train_df, test_df)
    print(f"   ✓ Modelo 1 [fit_eta_duration_model]:")
    print(f"       R²_test = {res_eta['metrics_test']['r2']:.4f} | RMSE = {res_eta['metrics_test']['rmse']:.2f} | MAE = {res_eta['metrics_test']['mae']:.2f} min")
    print(f"       Convergencia: {res_eta['gradient_descent_diagnostics']['iterations_to_convergence']} épocas | Regla: {res_eta['gradient_descent_diagnostics']['optimization_rule']}")
    print(f"       Ecuación: {res_eta['equation']}")

    # Dedicated Function 2: Speed Decay Model
    res_speed = fit_speed_decay_model(train_df, test_df)
    print(f"   ✓ Modelo 2 [fit_speed_decay_model]:")
    print(f"       R²_test = {res_speed['metrics_test']['r2']:.4f} | RMSE = {res_speed['metrics_test']['rmse']:.2f} | MAE = {res_speed['metrics_test']['mae']:.2f} km/h")
    print(f"       Convergencia: {res_speed['gradient_descent_diagnostics']['iterations_to_convergence']} épocas | Regla: {res_speed['gradient_descent_diagnostics']['optimization_rule']}")
    print(f"       Ecuación: {res_speed['equation']}")

    # Dedicated Function 3: Pricing Fare Model
    res_fare = fit_pricing_fare_model(train_df, test_df)
    print(f"   ✓ Modelo 3 [fit_pricing_fare_model]:")
    print(f"       R²_test = {res_fare['metrics_test']['r2']:.4f} | RMSE = {res_fare['metrics_test']['rmse']:.2f} | MAE = {res_fare['metrics_test']['mae']:.2f} NIO")
    print(f"       Convergencia: {res_fare['gradient_descent_diagnostics']['iterations_to_convergence']} épocas | Regla: {res_fare['gradient_descent_diagnostics']['optimization_rule']}")
    print(f"       Ecuación: {res_fare['equation']}")

    fitted_models = {
        "eta_duration": res_eta,
        "speed_decay": res_speed,
        "pricing_fare": res_fare,
    }

    print("▶ 4. Generando visualizaciones diagnósticas de alta resolución (300 DPI) sobre el conjunto Test...")
    plot_duration_model(res_eta, OUTPUT_GRAPHS_DIR / "numerical_duration.png")
    plot_speed_decay_model(res_speed, OUTPUT_GRAPHS_DIR / "numerical_speed.png")
    plot_fare_model(res_fare, OUTPUT_GRAPHS_DIR / "numerical_fare.png")
    print("   ✓ Gráficos guardados en typst/graphs/ (numerical_duration.png, numerical_speed.png, numerical_fare.png)")

    print("▶ 5. Exportando métricas, coeficientes e intervalos a typst/data/numerical_methods.json...")
    clean_models = {}
    for key, mod in fitted_models.items():
        copy_mod = {k: v for k, v in mod.items() if not k.startswith("_")}
        clean_models[key] = copy_mod

    export_payload = {
        "metadata": {
            "title": "MoviGo: Modelado de Regresión Multivariable mediante Métodos Numéricos y Estadística II",
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
    }

    json_path = OUTPUT_DATA_DIR / "numerical_methods.json"
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(export_payload, f, indent=2, ensure_ascii=False)

    print(f"   ✓ JSON exportado con éxito en: {json_path}")
    print("=" * 80)
    print("🎉 Suite de Regresión refactorizada con Descenso de Gradiente ejecutada exitosamente.")
    print("=" * 80)


if __name__ == "__main__":
    main()
