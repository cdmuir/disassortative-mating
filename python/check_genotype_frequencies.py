from sympy import simplify, symbols
A, P = symbols('A P')
ret = simplify(0 + A*(1 - P) + (1 - A)*(P - 1)**2 + P*(A - 1)*(P - 1) + A*P + 0 + P*(A - 1)*(P - 1) + P**2*(1 - A))
