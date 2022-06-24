source("r/header.R")

K0 = 0.01
A = 0.430

df_sim = bind_rows(
  map_dfr(seq(0.001, 0.999, 0.01), function(K0, A) {
    p0 = 1 - K0 # frequency of k allele
    q0 = K0 # frequency of K allele
    P0 = p0 ^ 2
    H0 = 2 * p0 * q0
    Q0 = q0 ^ 2
    w = 1 - A * (P0 ^ 2 + 1/4 * H0 ^ 2 + q0 * H0 + q0 ^ 2)
    P1 = (p0 ^ 2 - A * (P0 ^ 2 + H0 ^ 2 / 4)) / w
    H1 = (2 * p0 * q0 - A * q0 * H0) / w
    Q1 = (q0 ^ 2 * (1 - A)) / w
    p1 = P1 + H1 / 2
    q1 = 1- p1
    delta_q = q1 - q0
    tibble(K = K0, delta_q = delta_q)
  }, A = 0.430) |>
    mutate(Model = "hedrick"),
  map_dfr(seq(0.01, 0.99, 0.01), function(K0, A) {
    p0 = 1 - K0 # frequency of k allele
    q0 = K0 # frequency of K allele
    P0 = p0 ^ 2
    H0 = 2 * p0 * q0
    Q0 = q0 ^ 2
    P1 = P0 + delta_P(A, P0, H0, Q0)
    H1 = H0 + delta_H(A, P0, H0, Q0)
    Q1 = Q0 + delta_Q(A, P0, H0, Q0)
    p1 = P1 + H1 / 2
    q1 = 1 - p1
    delta_q = q1 - q0
    tibble(K = K0, delta_q = delta_q)
  }, A = 0.430) |>
    mutate(Model = "this_study")
  
)

ggplot(df_sim, aes(K, delta_q, linetype = Model)) +
  geom_hline(yintercept = 0, size = 1.1, linetype = "dotted", color = "grey") +
  geom_line(size = 1.1, lineend = "round", lineend = "round") +
  xlab(expression(paste("Frequency of ", italic(K)))) +
  ylab(expression(paste("Change in ", italic(K), " frequency"))) +
  scale_y_continuous(breaks = seq(-0.05, 0.04, 0.01), limits = c(-0.05, 0.04)) +
  scale_linetype_manual(
    values = c("solid", "dashed"), 
    labels = parse(text = c(
      "paste('Hedrick ', italic(et~al.))", 
      "paste('This study')"
    ))) +
  theme(
    legend.key.width = unit(2, "cm")
  )

ggsave("figures/fig4.pdf", width = 6, height = 4)
