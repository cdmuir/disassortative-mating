# Derive progeny frequencies reported in Table 1 of Hedrick et al. (2016) 
source("r/header.R")

# Initial genotype frequencies
# Values are for illustration
P = 0.5 # Frequency of kk
H = 0.49 # Frequency of Kk
Q = 0.01 # Frequency of KK
A = 0.50 # Proportion mating assortatively

# Check derivation in Table 1 ----
table1_genotypes = crossing(
  nesting(
    parent1 = c("kk", "Kk", "KK"),
    prob1 = c(P, H, Q),
    prob1_symbol = c("P", "H", "Q")
  ),
  nesting(
    mating = c("assortative", "random"),
    prob_mating = c(A, 1 - A),
    prob_mating_symbol = c("A", "(1 - A)")
  ),
  nesting(
    parent2 = c("kk", "Kk", "KK")
  )
) |>
  mutate(
    prob2 = case_when(
      
      parent1 == "kk" & mating == "assortative" & parent2 == "kk" ~ 0,
      parent1 == "kk" & mating == "random" & parent2 == "kk" ~ P,
      parent1 == "kk" & mating == "assortative" & parent2 == "Kk" ~ H / (H + Q),
      parent1 == "kk" & mating == "random" & parent2 == "Kk" ~ H,
      parent1 == "kk" & mating == "assortative" & parent2 == "KK" ~ Q / (H + Q),
      parent1 == "kk" & mating == "random" & parent2 == "KK" ~ Q,
      
      parent1 == "Kk" & mating == "assortative" & parent2 == "kk" ~ 1,
      parent1 == "Kk" & mating == "random" & parent2 == "kk" ~ P,
      parent1 == "Kk" & mating == "assortative" & parent2 == "Kk" ~ 0,
      parent1 == "Kk" & mating == "random" & parent2 == "Kk" ~ H,
      parent1 == "Kk" & mating == "assortative" & parent2 == "KK" ~ 0,
      parent1 == "Kk" & mating == "random" & parent2 == "KK" ~ Q,
      
      parent1 == "KK" & mating == "assortative" & parent2 == "kk" ~ 1,
      parent1 == "KK" & mating == "random" & parent2 == "kk" ~ P,
      parent1 == "KK" & mating == "assortative" & parent2 == "Kk" ~ 0,
      parent1 == "KK" & mating == "random" & parent2 == "Kk" ~ H,
      parent1 == "KK" & mating == "assortative" & parent2 == "KK" ~ 0,
      parent1 == "KK" & mating == "random" & parent2 == "KK" ~ Q
      
    ),
    prob2_symbol = case_when(

      parent1 == "kk" & mating == "assortative" & parent2 == "kk" ~ "0",
      parent1 == "kk" & mating == "random" & parent2 == "kk" ~ "P",
      parent1 == "kk" & mating == "assortative" & parent2 == "Kk" ~ "(H / (H + Q))",
      parent1 == "kk" & mating == "random" & parent2 == "Kk" ~ "H",
      parent1 == "kk" & mating == "assortative" & parent2 == "KK" ~ "(Q / (H + Q))",
      parent1 == "kk" & mating == "random" & parent2 == "KK" ~ "Q",
      
      parent1 == "Kk" & mating == "assortative" & parent2 == "kk" ~ "1",
      parent1 == "Kk" & mating == "random" & parent2 == "kk" ~ "P",
      parent1 == "Kk" & mating == "assortative" & parent2 == "Kk" ~ "0",
      parent1 == "Kk" & mating == "random" & parent2 == "Kk" ~ "H",
      parent1 == "Kk" & mating == "assortative" & parent2 == "KK" ~ "0",
      parent1 == "Kk" & mating == "random" & parent2 == "KK" ~ "Q",
      
      parent1 == "KK" & mating == "assortative" & parent2 == "kk" ~ "1",
      parent1 == "KK" & mating == "random" & parent2 == "kk" ~ "P",
      parent1 == "KK" & mating == "assortative" & parent2 == "Kk" ~ "0",
      parent1 == "KK" & mating == "random" & parent2 == "Kk" ~ "H",
      parent1 == "KK" & mating == "assortative" & parent2 == "KK" ~ "0",
      parent1 == "KK" & mating == "random" & parent2 == "KK" ~ "Q"
      
    ),
    mating_genotypes = str_c(parent1, " x ", parent2) |>
      str_replace("Kk x kk", "kk x Kk") |>
      str_replace("KK x kk", "kk x KK") |>
      str_replace("KK x Kk", "Kk x KK"),
    genotype_frequency = prob1 * prob_mating * prob2,
    genotype_frequency_symbol = paste(prob1_symbol, prob_mating_symbol,
                                      prob2_symbol, sep = " * ")
  )

# Prove symbolically that mating genotype frequencies sum to 1
write_lines(c(
  "from sympy import simplify, symbols",
  "A, P, H, Q = symbols('A P H Q')",
  "P = 1 - H - Q", 
  paste0("ret = simplify(", table1_genotypes$genotype_frequency_symbol |>
           str_c(collapse = " + "), ")")
), file = "python/check_genotype_frequencies1.py")

source_python("python/check_genotype_frequencies1.py")
ret == 1 # should be TRUE

table1_genotypes |>
  group_by(mating_genotypes) |>
  summarize(genotype_frequency = sum(genotype_frequency)) |>
  mutate(n_k = c(4, 3, 2, 2, 1, 0), n_K = c(0, 1, 2, 2, 3, 4)) |>
  summarize(
    p = sum(n_k * genotype_frequency) / 4,
    q = sum(n_K * genotype_frequency) / 4
  )

# Derive expressions for mating genotype frequencies
table1_frequencies = table1_genotypes |>
  group_by(mating_genotypes) |>
  summarize(genotype_frequency_symbol = str_c(genotype_frequency_symbol,
                                              collapse = " + ")) |>
  arrange(mating_genotypes) |>
  mutate(
    i = row_number(),
    genotype_frequency_symbol = str_c("p", i, " = simplify(", 
                                      genotype_frequency_symbol, ")")
  )

write_lines(c(
  "from sympy import simplify, symbols",
  "A, P, H, Q = symbols('A P H Q')",
  table1_frequencies$genotype_frequency_symbol
), file = "python/derive_genotype_frequencies1.py")

source_python("python/derive_genotype_frequencies1.py")

table1_frequencies = table1_frequencies |>
  mutate(genotype_frequency_symbol1 = list(p1, p2, p3, p4, p5, p6) |>
  sapply(as.character)) |>
  arrange(i)

write_lines(c(
  "from sympy import simplify, solve, symbols",
  "A, P, H, Q = symbols('A P H Q')",
  "P = 1 - H - Q", 
  glue("p_kk = simplify( {p_kk_kk} + ({p_kk_Kk}) / 2 + ({p_Kk_Kk}) / 4 )",
      p_kk_kk = table1_frequencies$genotype_frequency_symbol1[1],
      p_kk_Kk = table1_frequencies$genotype_frequency_symbol1[2],
      p_Kk_Kk = table1_frequencies$genotype_frequency_symbol1[4]),
  
  glue("p_Kk = simplify( ({p_kk_Kk}) / 2 + {p_kk_KK} + ({p_Kk_Kk}) / 2 + ({p_Kk_KK}) / 2 )",
       p_kk_Kk = table1_frequencies$genotype_frequency_symbol1[2],
       p_kk_KK = table1_frequencies$genotype_frequency_symbol1[3],
       p_Kk_Kk = table1_frequencies$genotype_frequency_symbol1[4],
       p_Kk_KK = table1_frequencies$genotype_frequency_symbol1[5]),
  
  glue("p_KK = simplify( ({p_Kk_Kk}) / 4 + ({p_Kk_KK}) / 2 + {p_KK_KK} )",
        p_Kk_Kk = table1_frequencies$genotype_frequency_symbol1[4],
        p_Kk_KK = table1_frequencies$genotype_frequency_symbol1[5],
        p_KK_KK = table1_frequencies$genotype_frequency_symbol1[6]),
  "ret = simplify(p_kk + p_Kk + p_KK)",
  "delta_P = simplify(p_kk - P)",
  "delta_H = simplify(p_Kk - H)",
  "delta_Q = simplify(p_KK - Q)",
  "delta_p = simplify(p_kk + p_Kk / 2 - P - H / 2)",
  "soln_Q = solve(delta_Q)",
  "soln_p = solve(delta_p)"
), file = "python/derive_progeny_frequencies.py")

source_python("python/derive_progeny_frequencies.py")
ret
p_kk
p_Kk
p_KK
delta_P
delta_H
delta_Q

soln_Q
soln_p # only internal solution is where H + Q = 0.5

write_lines(c(
  "from sympy import simplify, solve, symbols",
  "A, P, H, Q = symbols('A P H Q')",
  "P = 1 - H - Q", 
  "H = 1/2 - Q",
  "delta_Q = H**2*(1 - A)/4 - H*Q*(A - 1) + Q**2*(1 - A) - Q",
  "soln_Q = solve(delta_Q, Q)"
), file = "python/find_equilibrium.py")

source_python("python/find_equilibrium.py")
soln_Q # only one root has a positive value