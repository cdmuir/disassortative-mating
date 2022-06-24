# Check Hedrick et al. (2016) equilibrium
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

# Simulate change in allele frequency (cf. Fig 3 of Hedrick et al. 2016)
# Hedrick et al. 2016 model
sim_hedrick = function(t_max, K0, A) {
  
  assert_int(t_max, lower = 1L)
  assert_number(K0, lower = 0, upper = 1)
  assert_number(A, lower = 0, upper = 1)
  
  p = 1 - K0 # frequency of k allele
  q = K0 # frequency of K allele
  P = p ^ 2
  H = 2 * p * q
  Q = q ^ 2
  ret = tibble(
    t = 0:t_max, 
    P = c(P, numeric(t_max)),
    H = c(H, numeric(t_max)),
    Q = c(Q, numeric(t_max)),
    p = c(p, numeric(t_max)),
    q = c(q, numeric(t_max)),
    A = A
  )
  
  for (t in seq_len(t_max)) {
    w = 1 - A * (P ^ 2 + 1/4 * H ^ 2 + q * H + q ^ 2)
    ret[t + 1, "P"] = (p ^ 2 - A * (P ^ 2 + H ^ 2 / 4)) / w
    ret[t + 1, "H"] = (2 * p * q - A * q * H) / w
    ret[t + 1, "Q"] = (q ^ 2 * (1 - A)) / w
    ret[t + 1, "p"] = ret[t + 1, "P"] + ret[t + 1, "H"] / 2
    ret[t + 1, "q"] = 1 - ret[t + 1, "p"]
    delta_p = ret[t + 1, "p"] - p
    P = ret[t + 1, "P"]
    H = ret[t + 1, "H"]
    Q = ret[t + 1, "Q"]
    p = P + H / 2
    q = 1 - p
    
  }
  
  return(ret)
  
}

# Simulate change in allele frequency (cf. Fig 3 of Hedrick et al. 2016)
# New model

# Equations derived using sympy:
# source_python("python/derive_progeny_frequencies.py")
delta_P = function(A, P, H, Q) {
  assert_number(A, lower = 0, upper = 1)
  assert_number(P, lower = 0, upper = 1)
  assert_number(H, lower = 0, upper = 1)
  assert_number(Q, lower = 0, upper = 1)
  assert_true(abs(P + H + Q - 1) < 1e-6)
  (-H*(A*(H + Q - 1) - (A + 2*(A - 1)*(H + Q - 1))*(H + Q))/2 - (A - 1)*(H + Q)*(H**2 + 4*(H + Q - 1)**2)/4 + (H + Q)*(H + Q - 1))/(H + Q)
}

delta_H = function(A, P, H, Q) {
  assert_number(A, lower = 0, upper = 1)
  assert_number(P, lower = 0, upper = 1)
  assert_number(H, lower = 0, upper = 1)
  assert_number(Q, lower = 0, upper = 1)
  assert_true(abs(P + H + Q - 1) < 1e-6)
  -(H*(A - 1)*(H + Q)*(H + 2*Q)/2 + H*(H + Q) + H*(A*(H + Q - 1) - (A + 2*(A - 1)*(H + Q - 1))*(H + Q))/2 + Q*(A*(H + Q - 1) - (A + 2*(A - 1)*(H + Q - 1))*(H + Q)))/(H + Q)
}

delta_Q = function(A, P, H, Q) {
  assert_number(A, lower = 0, upper = 1)
  assert_number(P, lower = 0, upper = 1)
  assert_number(H, lower = 0, upper = 1)
  assert_number(Q, lower = 0, upper = 1)
  assert_true(abs(P + H + Q - 1) < 1e-6)
  H**2*(1 - A)/4 - H*Q*(A - 1) + Q**2*(1 - A) - Q
}

sim_new = function(t_max, K0, A) {
  
  assert_int(t_max, lower = 1L)
  assert_number(K0, lower = 0, upper = 1)
  assert_number(A, lower = 0, upper = 1)
  
  p = 1 - K0 # frequency of k allele
  q = K0 # frequency of K allele
  P = p ^ 2
  H = 2 * p * q
  Q = q ^ 2
  ret = tibble(
    t = 0:t_max, 
    P = c(P, numeric(t_max)),
    H = c(H, numeric(t_max)),
    Q = c(Q, numeric(t_max)),
    p = c(p, numeric(t_max)),
    q = c(q, numeric(t_max))
  )
  
  for (t in seq_len(t_max)) {

    ret[t + 1, "P"] = P + delta_P(A, P, H, Q)
    ret[t + 1, "H"] = H + delta_H(A, P, H, Q)
    ret[t + 1, "Q"] = Q + delta_Q(A, P, H, Q)
    ret[t + 1, "p"] = ret[t + 1, "P"] + ret[t + 1, "H"] / 2
    ret[t + 1, "q"] = 1 - ret[t + 1, "p"]
    delta_p = ret[t + 1, "p"] - p
    P = as.numeric(ret[t + 1, "P"])
    H = as.numeric(ret[t + 1, "H"])
    Q = as.numeric(ret[t + 1, "Q"])
    p = P + H / 2
    q = 1 - p
    
  }
  
  mutate(ret, A = A)
  
}
