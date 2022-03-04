from sympy import simplify, symbols
A, P, H, Q = symbols('A P H Q')
p1 = simplify(0 + P**2*(1 - A))
p2 = simplify(A*(1 - P) + P*(A - 1)*(P - 1) + A*P + P*(A - 1)*(P - 1))
p3 = simplify(0 + (1 - A)*(P - 1)**2)
