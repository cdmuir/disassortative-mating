from sympy import simplify, solve, symbols
A, P = symbols('A P')
# P < 0.5
max_A1 = 2 * P * (1 - P) * (1 - A) + A - 2 * P
# P > 0.5
max_A2 = 2 * P * (1 - P) * (1 - A) + A - 2 * (1 - P)
soln_max_A1 = solve(max_A1, A)[0].simplify()
soln_max_A2 = solve(max_A2, A)[0].simplify()
