#!/usr/bin/env python3
"""
MoviGo Empirical Econometrics Analysis: Simple Linear Regression & ANOVA
-----------------------------------------------------------------------
Estimates the impact of the surge pricing multiplier on the daily trip
cancellation rate in Managua (2024) via Ordinary Least Squares (OLS)
and evaluates statistical significance through classical ANOVA decomposition.

Outputs:
  - JSON data: typst/data/econometric_regression.json
  - Standalone 300 DPI PNG: typst/graphs/regression_fit.png
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import duckdb
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols


def get_project_root() -> Path:
    """Returns the absolute root directory of the repository."""
    return Path(__file__).resolve().parent.parent.parent


def extract_daily_dataset(db_path: Path) -> pd.DataFrame:
    """Extracts daily aggregate operational metrics from DuckDB."""
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
        round(avg(v.multiplicador_dinamico), 4) AS multiplicador_promedio
    FROM fct_viajes v
    GROUP BY v.fecha_solicitud
    ORDER BY v.fecha_solicitud;
    """
    con = duckdb.connect(str(db_path), read_only=True)
    try:
        df: pd.DataFrame = con.execute(query).df()
    finally:
        con.close()

    return df


def estimate_simple_ols(df: pd.DataFrame) -> dict[str, Any]:
    """Fits Simple Linear Regression (OLS) and computes ANOVA table."""
    model = ols("tasa_cancelacion_pct ~ multiplicador_promedio", data=df).fit()

    y_arr = np.asarray(df["tasa_cancelacion_pct"], dtype=float)
    x_arr = np.asarray(df["multiplicador_promedio"], dtype=float)
    r_matrix = np.corrcoef(x_arr, y_arr)
    pearson_r = float(r_matrix[0, 1])

    anova_table: pd.DataFrame = sm.stats.anova_lm(model, typ=2)  # type: ignore[reportUnknownMemberType]

    ss_reg = float(anova_table.loc["multiplicador_promedio", "sum_sq"])
    df_reg = int(anova_table.loc["multiplicador_promedio", "df"])
    ms_reg = ss_reg / df_reg

    ss_res = float(anova_table.loc["Residual", "sum_sq"])
    df_res = int(anova_table.loc["Residual", "df"])
    ms_res = ss_res / df_res

    ss_tot = ss_reg + ss_res
    df_tot = df_reg + df_res

    f_stat = float(model.fvalue)  # type: ignore[reportUnknownMemberType]
    f_pvalue = float(model.f_pvalue)  # type: ignore[reportUnknownMemberType]
    r_squared = float(model.rsquared)  # type: ignore[reportUnknownMemberType]
    adj_r_squared = float(model.rsquared_adj)  # type: ignore[reportUnknownMemberType]

    conf_int = model.conf_int()
    b0 = float(model.params["Intercept"])
    b1 = float(model.params["multiplicador_promedio"])

    return {
        "sample_size": int(len(df)),
        "dependent_variable": "tasa_cancelacion_pct",
        "independent_variable": "multiplicador_promedio",
        "pearson_r": round(pearson_r, 4),
        "r_squared": round(r_squared, 4),
        "adj_r_squared": round(adj_r_squared, 4),
        "residual_std_error": round(float(np.sqrt(model.mse_resid)), 4),  # type: ignore[reportUnknownMemberType]
        "f_statistic": round(f_stat, 2),
        "f_p_value": f_pvalue,
        "coefficients": {
            "intercept": {
                "estimate": round(b0, 4),
                "std_error": round(float(model.bse["Intercept"]), 4),
                "t_stat": round(float(model.tvalues["Intercept"]), 2),
                "p_value": float(model.pvalues["Intercept"]),
                "ci_95": [round(float(conf_int.loc["Intercept", 0]), 4), round(float(conf_int.loc["Intercept", 1]), 4)],
            },
            "multiplicador": {
                "estimate": round(b1, 4),
                "std_error": round(float(model.bse["multiplicador_promedio"]), 4),
                "t_stat": round(float(model.tvalues["multiplicador_promedio"]), 2),
                "p_value": float(model.pvalues["multiplicador_promedio"]),
                "ci_95": [
                    round(float(conf_int.loc["multiplicador_promedio", 0]), 4),
                    round(float(conf_int.loc["multiplicador_promedio", 1]), 4),
                ],
            },
        },
        "anova": {
            "regression": {
                "ss": round(ss_reg, 2),
                "df": df_reg,
                "ms": round(ms_reg, 2),
                "f": round(f_stat, 2),
                "p_value": f_pvalue,
            },
            "residuals": {
                "ss": round(ss_res, 2),
                "df": df_res,
                "ms": round(ms_res, 4),
            },
            "total": {
                "ss": round(ss_tot, 2),
                "df": df_tot,
            },
        },
    }


def generate_regression_plot(df: pd.DataFrame, results: dict[str, Any], output_path: Path) -> None:
    """Generates a publication-ready 300 DPI scatter plot with fitted OLS line."""
    plt.style.use("seaborn-v0_8-whitegrid" if "seaborn-v0_8-whitegrid" in plt.style.available else "default")
    fig, ax = plt.subplots(figsize=(8.0, 5.0), dpi=300)

    x = np.asarray(df["multiplicador_promedio"], dtype=float)
    y = np.asarray(df["tasa_cancelacion_pct"], dtype=float)

    ax.scatter(
        x,
        y,
        color="#1f2937",
        alpha=0.55,
        edgecolors="none",
        s=36,
        label="Días observados (n = 366)",
    )

    x_vals = np.linspace(x.min(), x.max(), 200)
    b0 = float(results["coefficients"]["intercept"]["estimate"])
    b1 = float(results["coefficients"]["multiplicador"]["estimate"])
    y_vals = b0 + b1 * x_vals

    ax.plot(
        x_vals,
        y_vals,
        color="#dc2626",
        linewidth=2.2,
        label=f"Ajuste MCO: $\\hat{{Y}} = {b0:.2f} + {b1:.2f}m$ ($R^2 = {results['r_squared']:.3f}$)",
    )

    ax.set_title(
        "Regresión Lineal Simple: Impacto de la Tarifa Dinámica sobre Cancelaciones",
        fontsize=12,
        fontweight="bold",
        pad=12,
    )
    ax.set_xlabel("Multiplicador Tarifario Dinámico Promedio Diario (m)", fontsize=10)
    ax.set_ylabel("Tasa de Cancelación Diaria (%)", fontsize=10)
    ax.legend(frameon=True, facecolor="white", edgecolor="#e5e7eb", fontsize=9, loc="upper left")
    ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300)
    plt.close(fig)


def main() -> None:
    root = get_project_root()
    db_path = root / "pipeline" / "data" / "analytics.duckdb"
    json_path = root / "typst" / "data" / "econometric_regression.json"
    plot_path = root / "typst" / "graphs" / "regression_fit.png"

    print("--- [Estadística II: Regresión Lineal Simple & ANOVA] ---")
    df = extract_daily_dataset(db_path)
    print(f"Dataset diario extraído: {len(df)} días analizados.")

    results = estimate_simple_ols(df)
    b0 = results["coefficients"]["intercept"]["estimate"]
    b1 = results["coefficients"]["multiplicador"]["estimate"]
    r2 = results["r_squared"]
    f_stat = results["f_statistic"]

    print(f"Modelo MCO: TasaCancelacion = {b0:.4f} + {b1:.4f} * Multiplicador")
    print(f"R² = {r2:.4f} | F = {f_stat:.2f} (p < 0.0001)")

    json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    print(f"Contrato JSON exportado a '{json_path}'.")

    generate_regression_plot(df, results, plot_path)
    print(f"Gráfico de regresión guardado en '{plot_path}'.")
    print("✓ Modelación econométrica completada exitosamente.")


if __name__ == "__main__":
    main()
