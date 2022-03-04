# check Hedrick et al (2016) equilibrium (move this elsewhere)
eqn1 = function(P, H, Q, A, t_max) {
  t = delta_p = 1
  p = P + H / 2
  q = 1 - p
  ret = tibble(
    t = 0:t_max, 
    P = c(P, numeric(t_max)),
    H = c(H, numeric(t_max)),
    Q = c(Q, numeric(t_max)),
    p = c(p, numeric(t_max))
  )
  
  while(delta_p > 1e-6 | t <= t_max) {
    t = t + 1
    w = 1 - A * (P ^ 2 + 1/4 * H ^ 2 + q * H + q ^ 2)
    ret[t, "P"] = (p ^ 2 - A * (P ^ 2 + H ^ 2 / 4)) / w
    ret[t, "H"] = (2 * p * q - A * q * H) / w
    ret[t, "Q"] = (q ^ 2 * (1 - A)) / w
    ret[t, "p"] = ret[t, "P"] + ret[t, "H"] / 2
    delta_p = ret[t, "p"] - p
    P = ret[t, "P"]
    H = ret[t, "H"]
    Q = ret[t, "Q"]
    p = P + H / 2
    q = 1 - p
    
  }
  
  ret
  
}
