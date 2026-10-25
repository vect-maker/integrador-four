#!/usr/bin/env python3
"""
MoviGo Empirical Econometrics Analysis (Multiple Linear Regression & ANOVA)
--------------------------------------------------------------------------
Estimates the impact of surge pricing (multiplier) and rainfall precipitation
on daily trip cancellation rates in Managua during the year 2024.

Outputs:
  - JSON data: typst/data/econometric_regression.json
  - Vector SVG plot: typst/graphs/regression_fit.svg
"""

from __future__ import annotations

import json
from pathlib import Path
import sys

import duckdb
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.stattools import durbin_watson, jarque_bera


def get_project_root() -> Path:
    """Returns the absolute root directory of the repository."""
    return Path(__file__).resolve().parent.parent.parent


def extract_daily_dataset(db_path: Path) -> pd.DataFrame:
    """
    Connects to the local DuckDB analytical snapshot and extracts daily
    aggregated operational metrics joined with weather variables.
    """
    if not db_path.exists():
        raise FileNotFoundError(
            f"DuckDB database not found at '{db_path}'. "
            "Please run 'just duckdb-snapshot' first."
        )

    query = """
    SELECT 
        v.fecha_solicitud AS fecha,
        count(*) AS total_viajes,
        sum(CASE WHEN v.es_cancelado THEN 1 ELSE 0 END) AS total_cancelados,
        round(100.0 * sum(CASE WHEN v.es_cancelado THEN 1 ELSE 0 END) / count(*), 4) AS tasa_cancelacion_pct,
        round(avg(v.multiplicador_dinamico), 4) AS multiplicador_promedio,
        cast(c.precipitacion_mm as double) AS precipitacion_mm,
        cast(c.temperatura_c as double) AS temperatura_c,
        cast(c.indice_congestion as double) AS indice_congestion,
        c.categoria_precipitacion
    FROM fct_viajes v
    JOIN dim_clima c ON v.fecha_solicitud = c.fecha
    GROUP BY v.fecha_solicitud, c.precipitacion_mm, c.temperatura_c, c.indice_congestion, c.categoria_precipitacion
    ORDER BY v.fecha_solicitud;
    """

    con = duckdb.connect(str(db_path), read_only=True)
    try:
        df = con.execute(query).df()
    finally:
        con.close()

    return df


def estimate_ols_model(df: pd.DataFrame):
    """
    Estimates the Multiple Linear Regression (OLS) and computes ANOVA decomposition.
    Model: tasa_cancelacion_pct = beta_0 + beta_1 * multiplicador_promedio + beta_2 * precipitacion_mm + epsilon
    """
    formula = "tasa_cancelacion_pct ~ multiplicador_promedio + precipitacion_mm"
    model = ols(formula, data=df).fit()

    # ANOVA Type II decomposition
    anova_table = sm.stats.anova_lm(model, typ=2)

    return model, anova_table


def build_json_payload(model, anova_table, df: pd.DataFrame) -> dict:
    """Constructs a structured dictionary payload matching the paper data contract."""
    n = int(model.nobs)
    k = int(model.df_model)  # number of regressors excluding constant
    df_resid = int(model.df_resid)

    # Confidence intervals (95%)
    conf_int = model.conf_int()

    coefficients = {
        "intercept": {
            "estimate": round(float(model.params["Intercept"]), 4),
            "std_error": round(float(model.bse["Intercept"]), 4),
            "t_stat": round(float(model.tvalues["Intercept"]), 3),
            "p_value": float(np.format_float_scientific(model.pvalues["Intercept"], precision=4)),
            "ci_95": [
                round(float(conf_int.loc["Intercept", 0]), 4),
                round(float(conf_int.loc["Intercept", 1]), 4),
            ],
        },
        "multiplicador": {
            "estimate": round(float(model.params["multiplicador_promedio"]), 4),
            "std_error": round(float(model.bse["multiplicador_promedio"]), 4),
            "t_stat": round(float(model.tvalues["multiplicador_promedio"]), 3),
            "p_value": float(np.format_float_scientific(model.pvalues["multiplicador_promedio"], precision=4)),
            "ci_95": [
                round(float(conf_int.loc["multiplicador_promedio", 0]), 4),
                round(float(conf_int.loc["multiplicador_promedio", 1]), 4),
            ],
        },
        "precipitacion_mm": {
            "estimate": round(float(model.params["precipitacion_mm"]), 4),
            "std_error": round(float(model.bse["precipitacion_mm"]), 4),
            "t_stat": round(float(model.tvalues["precipitacion_mm"]), 3),
            "p_value": float(np.format_float_scientific(model.pvalues["precipitacion_mm"], precision=4)),
            "ci_95": [
                round(float(conf_int.loc["precipitacion_mm", 0]), 4),
                round(float(conf_int.loc["precipitacion_mm", 1]), 4),
            ],
        },
    }

    # Sum of Squares
    ssr = float(model.ess)       # Explained Sum of Squares
    sse = float(model.ssr)       # Residual Sum of Squares
    sst = ssr + sse              # Total Sum of Squares

    msr = ssr / k
    mse = sse / df_resid

    anova = {
        "regression": {
            "ss": round(ssr, 4),
            "df": k,
            "ms": round(msr, 4),
            "f": round(float(model.fvalue), 3),
            "p_value": float(np.format_float_scientific(model.f_pvalue, precision=4)),
        },
        "residuals": {
            "ss": round(sse, 4),
            "df": df_resid,
            "ms": round(mse, 4),
        },
        "total": {
            "ss": round(sst, 4),
            "df": n - 1,
        },
    }

    metrics = {
        "r_squared": round(float(model.rsquared), 4),
        "adj_r_squared": round(float(model.rsquared_adj), 4),
        "residual_std_error": round(float(np.sqrt(mse)), 4),
        "f_statistic": round(float(model.fvalue), 3),
        "f_p_value": float(np.format_float_scientific(model.f_pvalue, precision=4)),
        "aic": round(float(model.aic), 2),
        "bic": round(float(model.bic), 2),
    }

    # Gauss-Markov diagnostics
    residuals = model.resid
    dw = float(durbin_watson(residuals))
    jb_stat, jb_p, skew, kurt = jarque_bera(residuals)

    diagnostics = {
        "durbin_watson": round(dw, 3),
        "jarque_bera": {
            "statistic": round(float(jb_stat), 3),
            "p_value": round(float(jb_p), 4),
            "skewness": round(float(skew), 3),
            "kurtosis": round(float(kurt), 3),
        },
    }

    return {
        "description": "Regresion Lineal Multiple (MCO) - Tasa de Cancelacion vs Multiplicador Tarifario y Precipitacion",
        "sample_size": n,
        "dependent_variable": "tasa_cancelacion_pct",
        "independent_variables": ["multiplicador_promedio", "precipitacion_mm"],
        "coefficients": coefficients,
        "metrics": metrics,
        "anova": anova,
        "diagnostics": diagnostics,
    }


def generate_vector_svg(df: pd.DataFrame, model, output_path: Path):
    """
    Renders a high-resolution, academic-styled dual-panel vector SVG graphic.
    Panel 1: Scatter plot of Multiplier vs Cancellation Rate with fitted line & 95% CI.
    Panel 2: Residuals vs Fitted values for homoscedasticity evaluation.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Use clean academic style
    plt.style.use("seaborn-v0_8-whitegrid" if "seaborn-v0_8-whitegrid" in plt.style.available else "default")
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11.5, 4.6), dpi=300)

    # -------------------------------------------------------------
    # Panel 1: Scatter & Regression Line
    # -------------------------------------------------------------
    # Classify weather condition for color mapping
    rain_palette = {
        "sin_lluvia": "#2b5c8f",      # Classic Navy
        "lluvia_ligera": "#388e3c",   # Emerald Green
        "tormenta": "#d32f2f",        # Vibrant Red
    }

    for cat, color in rain_palette.items():
        subset = df[df["categoria_precipitacion"] == cat]
        if not subset.empty:
            label = cat.replace("_", " ").capitalize()
            ax1.scatter(
                subset["multiplicador_promedio"],
                subset["tasa_cancelacion_pct"],
                color=color,
                alpha=0.65,
                s=30,
                edgecolors="none",
                label=f"{label} (n={len(subset)})",
            )

    # Regression line at mean precipitation
    m_grid = np.linspace(df["multiplicador_promedio"].min(), df["multiplicador_promedio"].max(), 100)
    mean_rain = df["precipitacion_mm"].mean()
    pred_data = pd.DataFrame({
        "multiplicador_promedio": m_grid,
        "precipitacion_mm": mean_rain,
    })
    preds = model.get_prediction(pred_data).summary_frame(alpha=0.05)

    ax1.plot(m_grid, preds["mean"], color="#111111", linewidth=2.0, label="Ajuste MCO (Lluvia media)")
    ax1.fill_between(
        m_grid,
        preds["mean_ci_lower"],
        preds["mean_ci_upper"],
        color="#111111",
        alpha=0.15,
        label="Intervalo de Confianza 95%",
    )

    beta_0 = model.params["Intercept"]
    beta_1 = model.params["multiplicador_promedio"]
    beta_2 = model.params["precipitacion_mm"]
    r2 = model.rsquared

    equation_text = (
        f"$\\hat{{Y}} = {beta_0:.2f} + {beta_1:.2f} m + {beta_2:.3f} P$\n"
        f"$R^2 = {r2:.3f}$ | $F = {model.fvalue:.1f}$ ($p < 0.001$)"
    )
    ax1.text(
        0.05,
        0.95,
        equation_text,
        transform=ax1.transAxes,
        fontsize=9,
        verticalalignment="top",
        bbox=dict(boxstyle="round,pad=0.5", facecolor="white", edgecolor="#cccccc", alpha=0.9),
    )

    ax1.set_title("(a) Sensibilidad de Cancelaciones vs. Multiplicador", fontsize=11, fontweight="bold", pad=8)
    ax1.set_xlabel("Multiplicador Dinámico Promedio Diario (m)", fontsize=10)
    ax1.set_ylabel("Tasa de Cancelación Diaria (%)", fontsize=10)
    ax1.legend(loc="lower right", frameon=True, fontsize=8)
    ax1.grid(True, linestyle="--", alpha=0.5)

    # -------------------------------------------------------------
    # Panel 2: Residuals vs Fitted
    # -------------------------------------------------------------
    fitted = model.fittedvalues
    resid = model.resid

    ax2.scatter(fitted, resid, color="#455a64", alpha=0.6, s=26, edgecolors="none")
    ax2.axhline(0, color="#d32f2f", linestyle="--", linewidth=1.5, label="Residuo cero")

    # Fit a smooth lowess line for visual homoscedasticity evaluation
    from statsmodels.nonparametric.smoothers_lowess import lowess
    smooth = lowess(resid, fitted, frac=0.6)
    ax2.plot(smooth[:, 0], smooth[:, 1], color="#0288d1", linewidth=1.8, label="Tendencia residual (LOWESS)")

    ax2.set_title("(b) Diagnóstico de Residuos vs. Valores Ajustados", fontsize=11, fontweight="bold", pad=8)
    ax2.set_xlabel("Valores Ajustados $\\hat{Y}$ (%)", fontsize=10)
    ax2.set_ylabel("Residuos MCO ($e_t$)", fontsize=10)
    ax2.legend(loc="upper right", frameon=True, fontsize=8)
    ax2.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    plt.savefig(output_path, format="svg", bbox_inches="tight")
    plt.close(fig)


def main():
    root = get_project_root()
    db_path = root / "pipeline" / "data" / "analytics.duckdb"
    json_path = root / "typst" / "data" / "econometric_regression.json"
    svg_path = root / "typst" / "graphs" / "regression_fit.svg"

    print("=" * 60)
    print("MoviGo Econometrics Analysis: Multiple Linear Regression (OLS)")
    print("=" * 60)
    print(f"Loading data from DuckDB: {db_path.relative_to(root)}")

    df = extract_daily_dataset(db_path)
    print(f"Extracted {len(df)} daily observations (Range: {df['fecha'].min()} to {df['fecha'].max()}).")

    model, anova_table = estimate_ols_model(df)
    print("\n--- OLS Model Summary ---")
    print(model.summary().tables[1])
    print(f"\nModel Fit: R² = {model.rsquared:.4f}, Adj R² = {model.rsquared_adj:.4f}")
    print(f"F-statistic: {model.fvalue:.2f} (p-value = {model.f_pvalue:.4e})")

    # Build and write JSON
    payload = build_json_payload(model, anova_table, df)
    json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2, ensure_ascii=False)
    print(f"\n✅ JSON metrics saved to: {json_path.relative_to(root)}")

    # Generate Vector SVG plot
    generate_vector_svg(df, model, svg_path)
    print(f"✅ Vector SVG plot saved to: {svg_path.relative_to(root)}")

    print("\n" + "=" * 60)
    print("Econometrics analysis successfully executed!")
    print("=" * 60)


if __name__ == "__main__":
    main()
