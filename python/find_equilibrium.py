from sympy import simplify, solve, symbols
A, P, H, Q = symbols('A P H Q')
P = 1 - H - Q
H = 1/2 - Q
delta_Q = H**2*(1 - A)/4 - H*Q*(A - 1) + Q**2*(1 - A) - Q
soln_Q = solve(delta_Q, Q)
