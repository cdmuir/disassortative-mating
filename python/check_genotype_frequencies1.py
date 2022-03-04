from sympy import simplify, symbols
A, P, H, Q = symbols('A P H Q')
P = 1 - H - Q
ret = simplify(P * A * 0 + P * A * (H / (H + Q)) + P * A * (Q / (H + Q)) + P * (1 - A) * P + P * (1 - A) * H + P * (1 - A) * Q + H * A * 1 + H * A * 0 + H * A * 0 + H * (1 - A) * P + H * (1 - A) * H + H * (1 - A) * Q + Q * A * 1 + Q * A * 0 + Q * A * 0 + Q * (1 - A) * P + Q * (1 - A) * H + Q * (1 - A) * Q)
