#!/usr/bin/env python3
"""
MoviGo Numerical Methods: Tariff Equilibrium Root-Finding
---------------------------------------------------------
Solves the market balance equation between user demand and driver supply
during peak hours to determine the theoretical equilibrium multiplier (m*):

    f(m) = D(m) - S(m) = D0 * exp(-alpha * (m - 1)) - S0 * (1 + beta * ln(m)) = 0

Compares the iterative convergence behavior of:
  1. Bisection Method (Linear convergence, order 1)
  2. Newton-Raphson Method (Quadratic convergence, order 2)

Outputs:
  - JSON data: typst/data/numerical_methods.json
  - Image plot 1: typst/graphs/market_equilibrium_curves.png
  - Image plot 2: typst/graphs/numerical_convergence.png
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import overload

import matplotlib.pyplot as plt
import numpy as np

# -----------------------------------------------------------------------------
# Microeconomic Parameters & Functions
# -----------------------------------------------------------------------------
D0 = 220.0  # Baseline peak hourly demand (trip requests/hour at m=1.00)
ALPHA = 0.65  # Exponential price elasticity decay parameter
S0 = 140.0  # Baseline peak hourly supply (active drivers at m=1.00)
BETA = 0.85  # Logarithmic supply incentive attraction parameter
TOLERANCE = 1e-6  # Numerical convergence tolerance threshold
MAX_ITER = 100  # Maximum iteration guardrail


@overload
def demand_function(m: float) -> float: ...


@overload
def demand_function(m: np.ndarray) -> np.ndarray: ...


def demand_function(m: float | np.ndarray) -> float | np.ndarray:
    """Evaluates the customer trip demand curve: D(m) = D0 * exp(-alpha * (m - 1))."""
    return D0 * np.exp(-ALPHA * (m - 1.0))


@overload
def supply_function(m: float) -> float: ...


@overload
def supply_function(m: np.ndarray) -> np.ndarray: ...


def supply_function(m: float | np.ndarray) -> float | np.ndarray:
    """Evaluates the driver service supply curve: S(m) = S0 * (1 + beta * ln(m))."""
    return S0 * (1.0 + BETA * np.log(m))


def excess_demand_f(m: float) -> float:
    """
    Evaluates the excess demand market balance function:
    f(m) = D(m) - S(m)
    """
    return float(demand_function(m) - supply_function(m))


def excess_demand_f_prime(m: float) -> float:
    """
    Evaluates the exact analytical derivative of the excess demand function:
    f'(m) = -alpha * D0 * exp(-alpha * (m - 1)) - (beta * S0) / m
    Strictly negative for all m >= 1.0, guaranteeing monotonicity and a unique root.
    """
    return float(-ALPHA * D0 * np.exp(-ALPHA * (m - 1.0)) - (BETA * S0) / m)


# -----------------------------------------------------------------------------
# Numerical Root-Finding Algorithms
# -----------------------------------------------------------------------------
def solve_bisection(
    a: float,
    b: float,
    tol: float = TOLERANCE,
    max_iter: int = MAX_ITER,
) -> tuple[float, list[dict]]:
    """
    Finds the root of f(m) = 0 using the Bisection Method on bracket [a, b].
    Records the step-by-step iteration state: k, a, b, m, f(m), error.
    """
    fa = excess_demand_f(a)
    fb = excess_demand_f(b)

    if fa * fb > 0:
        raise ValueError(
            f"Bolzano condition not met: f({a})={fa:.2f} and f({b})={fb:.2f} have the same sign."
        )

    history = []
    step = 1
    current_a = a
    current_b = b

    while step <= max_iter:
        m = (current_a + current_b) / 2.0
        fm = excess_demand_f(m)
        error = (current_b - current_a) / 2.0

        history.append(
            {
                "step": step,
                "a": round(float(current_a), 6),
                "b": round(float(current_b), 6),
                "m": round(float(m), 6),
                "f_m": round(float(fm), 6),
                "error": round(float(error), 8),
            }
        )

        if error < tol or abs(fm) < tol:
            return m, history

        # Update bracket according to Bolzano's sign rule
        if fa * fm < 0:
            current_b = m
            fb = fm
        else:
            current_a = m
            fa = fm

        step += 1

    return (current_a + current_b) / 2.0, history


def solve_newton_raphson(
    m0: float,
    tol: float = TOLERANCE,
    max_iter: int = MAX_ITER,
) -> tuple[float, list[dict]]:
    """
    Finds the root of f(m) = 0 using the Newton-Raphson Method starting from m0.
    Records the step-by-step iteration state: k, m, f(m), f'(m), error.
    """
    history = []
    current_m = m0
    step = 0

    while step <= max_iter:
        fm = excess_demand_f(current_m)
        f_prime = excess_demand_f_prime(current_m)

        if abs(f_prime) < 1e-12:
            raise ZeroDivisionError(
                f"Derivative near zero at step {step}: f'({current_m})={f_prime}"
            )

        next_m = current_m - (fm / f_prime)
        error = abs(next_m - current_m)

        history.append(
            {
                "step": step,
                "m": round(float(current_m), 6),
                "f_m": round(float(fm), 6),
                "f_prime": round(float(f_prime), 4),
                "error": round(float(error), 8),
            }
        )

        if error < tol or abs(fm) < tol:
            # Append final converged point state
            history.append(
                {
                    "step": step + 1,
                    "m": round(float(next_m), 6),
                    "f_m": round(float(excess_demand_f(next_m)), 6),
                    "f_prime": round(float(excess_demand_f_prime(next_m)), 4),
                    "error": 0.0,
                }
            )
            return next_m, history

        current_m = next_m
        step += 1

    return current_m, history


# -----------------------------------------------------------------------------
# Visualization Functions (Standalone PNGs at 300 DPI)
# -----------------------------------------------------------------------------
def generate_market_curves_plot(m_star: float, output_path: Path):
    """
    Renders standalone PNG: Supply vs. Demand curves showing the equilibrium root m*.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)
    plt.style.use(
        "seaborn-v0_8-whitegrid"
        if "seaborn-v0_8-whitegrid" in plt.style.available
        else "default"
    )
    fig, ax = plt.subplots(figsize=(6.8, 4.4), dpi=300)

    m_vals = np.linspace(1.0, 2.5, 200)
    d_vals = demand_function(m_vals)
    s_vals = supply_function(m_vals)
    q_star = demand_function(m_star)

    # Plot curves
    ax.plot(
        m_vals,
        d_vals,
        color="#c62828",
        linewidth=2.2,
        label=r"Demanda $D(m) = D_0 e^{-\alpha(m-1)}$",
    )
    ax.plot(
        m_vals,
        s_vals,
        color="#1565c0",
        linewidth=2.2,
        label=r"Oferta $S(m) = S_0 (1 + \beta \ln m)$",
    )

    # Shaded excess regions
    mask_shortage = m_vals <= m_star
    mask_surplus = m_vals >= m_star
    ax.fill_between(
        m_vals[mask_shortage],
        s_vals[mask_shortage],
        d_vals[mask_shortage],
        color="#c62828",
        alpha=0.12,
        label="Exceso de Demanda (Déficit de Flota)",
    )
    ax.fill_between(
        m_vals[mask_surplus],
        d_vals[mask_surplus],
        s_vals[mask_surplus],
        color="#1565c0",
        alpha=0.12,
        label="Exceso de Oferta (Tarifa Disuasiva)",
    )

    # Equilibrium intersection point
    ax.scatter([m_star], [q_star], color="#111111", s=70, zorder=5)
    ax.axvline(m_star, color="#555555", linestyle=":", linewidth=1.4)
    ax.axhline(q_star, color="#555555", linestyle=":", linewidth=1.4)

    # Equilibrium callout box
    annotation_text = (
        f"Punto de Equilibrio:\n"
        f"$m^* = {m_star:.4f}\\times$\n"
        f"$Q^* = {q_star:.1f}$ viajes/h"
    )
    ax.text(
        m_star + 0.06,
        q_star + 14,
        annotation_text,
        fontsize=9,
        bbox=dict(
            boxstyle="round,pad=0.4",
            facecolor="#fff9c4",
            edgecolor="#fbc02d",
            alpha=0.95,
        ),
    )

    ax.set_title(
        "Equilibrio Microeconómico de Demanda y Oferta en Horas Pico",
        fontsize=11,
        fontweight="bold",
        pad=8,
    )
    ax.set_xlabel("Multiplicador Dinámico de Tarifa (m)", fontsize=10)
    ax.set_ylabel("Volumen Horario de Viajes (solicitudes/h)", fontsize=10)
    ax.set_xlim(1.0, 2.5)
    ax.set_ylim(80, 250)
    ax.legend(loc="upper right", frameon=True, fontsize=8)
    ax.grid(True, linestyle="--", alpha=0.5)

    plt.tight_layout()
    plt.savefig(output_path, format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)


def generate_convergence_plot(
    bisection_history: list[dict],
    newton_history: list[dict],
    output_path: Path,
):
    """
    Renders standalone PNG: Semi-logarithmic error decay plot log10(|e_k|) vs. iteration k.
    Illustrates linear convergence of Bisection vs. quadratic convergence of Newton-Raphson.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)
    plt.style.use(
        "seaborn-v0_8-whitegrid"
        if "seaborn-v0_8-whitegrid" in plt.style.available
        else "default"
    )
    fig, ax = plt.subplots(figsize=(6.8, 4.4), dpi=300)

    # Bisection points
    b_steps = [item["step"] for item in bisection_history]
    b_errors = [max(item["error"], 1e-12) for item in bisection_history]

    # Newton points (exclude zero-error terminal dummy step for clean log plot)
    n_steps = [item["step"] for item in newton_history if item["error"] > 0]
    n_errors = [item["error"] for item in newton_history if item["error"] > 0]

    ax.plot(
        b_steps,
        b_errors,
        marker="o",
        markersize=5,
        color="#d84315",
        linewidth=1.8,
        label=f"Bisección (Orden 1, Lineal) — {len(b_steps)} iteraciones",
    )
    ax.plot(
        n_steps,
        n_errors,
        marker="s",
        markersize=6,
        color="#2e7d32",
        linewidth=2.0,
        label=f"Newton-Raphson (Orden 2, Cuadrático) — {len(n_steps)} iteraciones",
    )

    # Threshold horizontal line
    ax.axhline(
        TOLERANCE,
        color="#424242",
        linestyle="--",
        linewidth=1.2,
        label=r"Tolerancia $\epsilon = 10^{-6}$",
    )

    ax.set_yscale("log")
    ax.set_title(
        "Trayectoria de Convergencia Numérica del Error de Aproximación",
        fontsize=11,
        fontweight="bold",
        pad=8,
    )
    ax.set_xlabel("Número de Iteración (k)", fontsize=10)
    ax.set_ylabel(r"Error Absoluto Estimado $|e_k|$ (Escala Logarítmica)", fontsize=10)
    ax.set_xticks(range(0, max(b_steps) + 1, 2))
    ax.legend(loc="upper right", frameon=True, fontsize=8)
    ax.grid(True, which="both", linestyle="--", alpha=0.5)

    plt.tight_layout()
    plt.savefig(output_path, format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)


# -----------------------------------------------------------------------------
# Main Orchestrator
# -----------------------------------------------------------------------------
def main():
    root = Path(__file__).resolve().parent.parent.parent
    json_path = root / "typst" / "data" / "numerical_methods.json"
    curves_plot_path = root / "typst" / "graphs" / "market_equilibrium_curves.png"
    convergence_plot_path = root / "typst" / "graphs" / "numerical_convergence.png"

    print("=" * 60)
    print("MoviGo Numerical Methods: Tariff Equilibrium Root-Finding")
    print("=" * 60)
    print(
        f"Excess demand function: f(m) = {D0}*exp(-{ALPHA}*(m-1)) - {S0}*(1+{BETA}*ln(m))"
    )
    print(f"Tolerance target: epsilon = {TOLERANCE}")

    # 1. Run Bisection
    a_init, b_init = 1.00, 2.50
    root_bisect, hist_bisect = solve_bisection(a_init, b_init, tol=TOLERANCE)
    print(f"\n[Bisection] Interval [{a_init}, {b_init}]:")
    print(f"  Converged root: m* = {root_bisect:.6f} in {len(hist_bisect)} iterations.")
    print(f"  Final residual: f(m*) = {excess_demand_f(root_bisect):.2e}")

    # 2. Run Newton-Raphson
    m0_init = 1.20
    root_newton, hist_newton = solve_newton_raphson(m0_init, tol=TOLERANCE)
    num_newton_steps = len([h for h in hist_newton if h["error"] > 0])
    print(f"\n[Newton-Raphson] Initial guess m0 = {m0_init}:")
    print(f"  Converged root: m* = {root_newton:.6f} in {num_newton_steps} iterations.")
    print(f"  Final residual: f(m*) = {excess_demand_f(root_newton):.2e}")

    speedup = round(len(hist_bisect) / num_newton_steps, 2)
    print(
        f"\n⚡ Performance speedup: Newton-Raphson required {speedup}x fewer iterations."
    )

    # 3. Build JSON payload
    payload = {
        "description": "Calculo Numerico de Raiz de Equilibrio Tarifario - Biseccion vs Newton-Raphson",
        "parameters": {
            "demand_base_d0": D0,
            "demand_elasticity_alpha": ALPHA,
            "supply_base_s0": S0,
            "supply_incentive_beta": BETA,
            "tolerance_epsilon": TOLERANCE,
        },
        "root_equilibrium": {
            "m_star": round(float(root_newton), 4),
            "balanced_volume_trips_per_hour": round(
                float(demand_function(root_newton)), 2
            ),
        },
        "bisection": {
            "initial_interval": [a_init, b_init],
            "total_iterations": len(hist_bisect),
            "converged": True,
            "final_root": round(float(root_bisect), 6),
            "final_residual": float(
                np.format_float_scientific(excess_demand_f(root_bisect), precision=3)
            ),
            "convergence_order": 1,
            "history": hist_bisect,
        },
        "newton_raphson": {
            "initial_point": m0_init,
            "total_iterations": num_newton_steps,
            "converged": True,
            "final_root": round(float(root_newton), 6),
            "final_residual": float(
                np.format_float_scientific(excess_demand_f(root_newton), precision=3)
            ),
            "convergence_order": 2,
            "history": hist_newton,
        },
        "comparison": {
            "iteration_reduction_ratio": speedup,
            "recommended_algorithm": "Newton-Raphson (convergencia cuadratica con derivada analitica)",
        },
    }

    # 4. Write JSON
    json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2, ensure_ascii=False)
    print(f"\n✅ JSON metrics saved to: {json_path.relative_to(root)}")

    # 5. Render Standalone PNGs (300 DPI)
    generate_market_curves_plot(root_newton, curves_plot_path)
    print(
        f"✅ Market equilibrium curves saved to: {curves_plot_path.relative_to(root)}"
    )

    generate_convergence_plot(hist_bisect, hist_newton, convergence_plot_path)
    print(
        f"✅ Numerical convergence plot saved to: {convergence_plot_path.relative_to(root)}"
    )

    print("\n" + "=" * 60)
    print("Numerical methods analysis successfully completed!")
    print("=" * 60)


if __name__ == "__main__":
    main()
