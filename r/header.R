rm(list = ls())

source("r/functions.R")

library(checkmate)
library(cowplot)
library(dplyr)
library(furrr)
library(ggplot2)
library(glue)
library(purrr)
library(readr)
library(reticulate)
library(stringr)
library(tibble)
library(tidyr)

theme_set(theme_cowplot())
