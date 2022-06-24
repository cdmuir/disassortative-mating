source("r/header.R")

plan("multisession")

# Equilibria for Hedrick et al. (2016)
df1 = seq(0.02, 0.98, 0.01) |>
  future_map_dfr(function(.x) {
    # Starting q = 0.01
    df = eqn1(P = 0.99 ^ 2, H = 2 * 0.99 * (1 - 0.99), 0.01, .x, 1000)
    df |>
      filter(t == 1000) |>
      mutate(A = .x)
  }) |>
  mutate(Source = "Hedrick et al. (2016)")

df2 = tibble(
  A = df1$A,
  Source = "this study",
  P = 0.5,
  t = NA
) |>
mutate(
  Q = (-A / 2 + sqrt(2 * (A + 1)) - 1.5)/(A - 1),
  H = 0.5 - Q,
  p = P + H / 2
)

write_rds(bind_rows(df1, df2), "objects/fig2.rds")
