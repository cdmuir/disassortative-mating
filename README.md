# dissasortative-mating

This repository contains source code associated with the manuscript:

Technical comment on ['Negative-assortative mating for color in wolves']( https://doi.org/10.1111/evo.12906).

## Contents

This repository has the following file folders:

- `objects`: saved objects generated from *R* code
- `ms`: manuscript input (e.g. `ms.Rmd` and `dissasortative-mating.bib`) and output (e.g. `ms.pdf`) files
- `python`: Python scripts for all data processing and analysis
  + `check_genotype_frequencies.py` checks that genotype frequencies sum to 1 when only *kk* and *K-* genotypes are considered
  + `check_genotype_frequencies1.py` checks that genotype frequencies sum to 1 when *kk*, *Kk*, and *KK* genotypes are considered
  + `derive_genotype_frequencies.py` derives genotype frequencies for *kk* and *K-*
  + `derive_genotype_frequencies1.py` derives genotype frequencies for *kk*, *Kk*, and *KK* 
  + `derive_progency_frequencies.py` derives progeny frequencies
  + `find_equilibrium.py` solves for *Q* at equilibrium
  + `get-sympy-version.pr` gets SymPy version
  + `simplify_genotype_frequencies.py` simplifies genotype frequencies for Table 2
- `r`: *R* scripts for all data processing and analysis
  + `01_check-genotype-frequencies.R` derives genotype frequencies as in Table 1 of Hedrick *et al.* (2016)
  + `02_check-progeny-frequencies.R` derives progeny frequencies as in Table 1 of Hedrick *et al.* (2016) and finds equilibrium
  + `03_make-fig.R` compares equilibrium for *Q* in Hedrick *et al.* (2016) and this study
  + `04_write-bib.R` writes the bib file
  + `function.R` contains custom functions
  + `header.R` is a header file for *R* scripts
  + `install-packages.R` is a script to install required packages

## Prerequisites:

To run code and render manuscript:

- [*R*](https://cran.r-project.org/) version >4.1.0 and [*RStudio*](https://www.rstudio.com/)
- [LaTeX](https://www.latex-project.org/): you can install the full version or try [**tinytex**](https://yihui.org/tinytex/)

Before running scripts, you'll need to install the following *R* packages and SymPy:

```
source("r/install-packages.R")
```

## Rendering manuscript

### Software requirements

At minimum, you will need [R](https://cran.r-project.org/) installed on your machine. Install additional packages by running `r/install-packages.R`.

### Rendering manuscript with pre-saved outout

Open `ms/ms.Rmd` and knit using [RStudio](https://www.rstudio.com/).

You can also run the following code from the R console:

```{r}
rmarkdown::render(
  input = "ms/ms.Rmd",
  output_dir = "ms"
)
```
