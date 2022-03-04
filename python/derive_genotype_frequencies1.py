from sympy import simplify, symbols
A, P, H, Q = symbols('A P H Q')
p1 = simplify(P * A * 0 + P * (1 - A) * P)
p2 = simplify(P * A * (H / (H + Q)) + P * (1 - A) * H + H * A * 1 + H * (1 - A) * P)
p3 = simplify(P * A * (Q / (H + Q)) + P * (1 - A) * Q + Q * A * 1 + Q * (1 - A) * P)
p4 = simplify(H * A * 0 + H * (1 - A) * H)
p5 = simplify(H * A * 0 + H * (1 - A) * Q + Q * A * 0 + Q * (1 - A) * H)
p6 = simplify(Q * A * 0 + Q * (1 - A) * Q)
