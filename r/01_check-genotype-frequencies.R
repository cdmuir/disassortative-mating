# Derive mating genotype frequencies reported in Table 1 of Hedrick et al. (2016) 
source("r/header.R")

# Initial genotype frequencies
# Values are for illustration
P = 0.25 # Frequency of kk
H = 0.50 # Frequency of Kk
Q = 0.25 # Frequency of KK
A = 0.50 # Proportion mating assortatively

# Check derivation in Table 1 ----
table1_genotypes = crossing(
  nesting(
    parent1 = c("kk", "K-"),
    prob1 = c(P, 1 - P),
    prob1_symbol = c("P", "(1 - P)")
  ),
  nesting(
    mating = c("assortative", "random"),
    prob_mating = c(A, 1 - A),
    prob_mating_symbol = c("A", "(1 - A)")
  ),
  nesting(
    parent2 = c("kk", "K-")
  )
) |>
  mutate(
    prob2 = case_when(
      parent1 == "kk" & mating == "assortative" & parent2 == "kk" ~ 0,
      parent1 == "kk" & mating == "random" & parent2 == "kk" ~ P,
      parent1 == "kk" & mating == "assortative" & parent2 == "K-" ~ 1,
      parent1 == "kk" & mating == "random" & parent2 == "K-" ~ 1 - P,
      parent1 == "K-" & mating == "assortative" & parent2 == "kk" ~ 1,
      parent1 == "K-" & mating == "random" & parent2 == "kk" ~ P,
      parent1 == "K-" & mating == "assortative" & parent2 == "K-" ~ 0,
      parent1 == "K-" & mating == "random" & parent2 == "K-" ~ 1 - P,
    ),
    prob2_symbol = case_when(
      parent1 == "kk" & mating == "assortative" & parent2 == "kk" ~ "0",
      parent1 == "kk" & mating == "random" & parent2 == "kk" ~ "P",
      parent1 == "kk" & mating == "assortative" & parent2 == "K-" ~ "1",
      parent1 == "kk" & mating == "random" & parent2 == "K-" ~ "(1 - P)",
      parent1 == "K-" & mating == "assortative" & parent2 == "kk" ~ "1",
      parent1 == "K-" & mating == "random" & parent2 == "kk" ~ "P",
      parent1 == "K-" & mating == "assortative" & parent2 == "K-" ~ "0",
      parent1 == "K-" & mating == "random" & parent2 == "K-" ~ "(1 - P)",
    ),
    mating_genotypes = str_c(parent1, " x ", parent2) |>
      str_replace("K- x kk", "kk x K-"),
    genotype_frequency = prob1 * prob_mating * prob2,
    genotype_frequency_symbol = paste(prob1_symbol, prob_mating_symbol,
                                      prob2_symbol, sep = " * ")
  )

# Simplify genotype_frequency_symbol
write_lines(c(
  "from sympy import simplify, symbols",
  "A, P = symbols('A P')",
  glue("p{n} = simplify({x})", n = seq_len(nrow(table1_genotypes)),
       x = table1_genotypes$genotype_frequency_symbol)
), file = "python/simplify_genotype_frequencies.py")

source_python("python/simplify_genotype_frequencies.py")

table1_genotypes$genotype_frequency_symbol = sapply(c(p1, p2, p3, p4, p5, p6, p7, p8), as.character)

# Check that sum of genotype frequencies is 1
sum(table1_genotypes$genotype_frequency) == 1 # Should be TRUE

# Prove symbolically that mating genotype frequencies sum to 1
write_lines(c(
  "from sympy import simplify, symbols",
  "A, P = symbols('A P')",
  paste0("ret = simplify(", table1_genotypes$genotype_frequency_symbol |>
           str_c(collapse = " + "), ")")
), file = "python/check_genotype_frequencies.py")

source_python("python/check_genotype_frequencies.py")
ret == 1 # should be TRUE

# Derive expressions for mating genotype frequencies
table1_frequencies = table1_genotypes |>
  group_by(mating_genotypes) |>
  summarize(genotype_frequency_symbol = str_c(genotype_frequency_symbol,
                                              collapse = " + ")) |>
  arrange(desc(mating_genotypes)) |>
  mutate(
    i = case_when(
      mating_genotypes == "kk x kk" ~ "1",
      mating_genotypes == "kk x K-" ~ "2",
      mating_genotypes == "K- x K-" ~ "3",
    ),
    genotype_frequency_symbol = str_c("p", i, " = simplify(", 
                                      genotype_frequency_symbol, ")"))

write_lines(c(
  "from sympy import simplify, symbols",
  "A, P, H, Q = symbols('A P H Q')",
  table1_frequencies$genotype_frequency_symbol
), file = "python/derive_genotype_frequencies.py")

source_python("python/derive_genotype_frequencies.py")
p1 # Same as Hedrick et al. (2016)
p2 # Different. In paper, I replace P - 1 = H + Q and A + 1 = - (1 - A)
p3 # Same as Hedrick et al. (2016)

write_rds(table1_genotypes, "objects/table1_genotypes.rds")

# Numerical example showing solutions are different
P = 0.25 # Frequency of kk
H = 0.50 # Frequency of Kk
Q = 0.25 # Frequency of KK
A = 0.50 # Proportion mating assortatively
A*P - A*(P - 1) + 2*P*(A - 1)*(P - 1) # This study
2 * P * (H + Q) # Hedrick et al. (2016)