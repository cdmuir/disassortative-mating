from sympy import simplify, solve, symbols
A, P, H, Q = symbols('A P H Q')
P = 1 - H - Q
p_kk = simplify( P**2*(1 - A) + (H*(A*P + (A - 2*P*(A - 1))*(H + Q))/(H + Q)) / 2 + (H**2*(1 - A)) / 4 )
p_Kk = simplify( (H*(A*P + (A - 2*P*(A - 1))*(H + Q))/(H + Q)) / 2 + Q*(A*P + (A - 2*P*(A - 1))*(H + Q))/(H + Q) + (H**2*(1 - A)) / 2 + (2*H*Q*(1 - A)) / 2 )
p_KK = simplify( (H**2*(1 - A)) / 4 + (2*H*Q*(1 - A)) / 2 + Q**2*(1 - A) )
ret = simplify(p_kk + p_Kk + p_KK)
delta_P = simplify(p_kk - P)
delta_H = simplify(p_Kk - H)
delta_Q = simplify(p_KK - Q)
delta_p = simplify(p_kk + p_Kk / 2 - P - H / 2)
soln_Q = solve(delta_Q)
soln_p = solve(delta_p)
