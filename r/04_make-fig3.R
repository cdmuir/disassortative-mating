source("r/header.R")

# How fast does K reach equilibrium? This is for discussion in text
sim_new(25, 0.01, 0.430) |>
  print(n = 25)

df_sim = bind_rows(
  bind_rows(
    sim_hedrick(100, 0.01, 0.1),
    sim_hedrick(100, 0.01, 0.2),
    sim_hedrick(100, 0.01, 0.4)
  ) |>
    mutate(Model = "paste('Hedrick ', italic(et~al.))"),
  bind_rows(
    sim_new(100, 0.01, 0.1),
    sim_new(100, 0.01, 0.2),
    sim_new(100, 0.01, 0.4)
  )  |>
    mutate(Model = "paste('This study')")
)

ggplot(df_sim, aes(t, q, linetype = as.factor(A))) +
  facet_grid(. ~ Model, labeller = labeller(Model = label_parsed)) +
  geom_line(size = 1.1, lineend = "round") +
  scale_linetype_manual(
    values = c("dashed", "solid", "longdash"),
    name = expression(italic(A))
  ) +
  xlab("Generation") +
  ylab(expression(paste("Frequency of ", italic(K)))) +
  ylim(0, 0.3) +
  theme(
    legend.key.width = unit(2, "cm"),
    legend.position = "bottom"
  )

ggsave("figures/fig3.pdf", width = 6.5, height = 4)
