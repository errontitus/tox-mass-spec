
Yikes. Getting the dependencies for this to work in R is a nightmare...
Revisit and clean up.


pacman::p_load(zoo, sandwich, TH.data, multcomp, plotrix, mvtnorm, RcppArmadillo, conquer, MatrixModels, SparseM, quantreg, numDeriv, sn, gbRd, bibtex, gtools, SQUAREM, lava, cpp11, prodlim, timeDate, tidyselect, tidyr, lubridate, ipred, gower, generics, dplyr, checkmate, jpeg, png, caTools, gdata, estimability, hms, mathjaxr, mutoss, TFisher, Rdpack, pls, pROC, recipes, ModelMetrics, htmlTable, latticeExtra, Formula, gplots, rsm, entropy, progress, metap, spls, reshape, igraph, caret, Hmisc, lars, fitdistrplus, pheatmap, ROCR, RJSONIO, som, e1071, randomForest)


metanr_packages <- function(){
metr_pkgs <- c("impute", "pcaMethods", "globaltest", "GlobalAncova", "Rgraphviz", "preprocessCore", "genefilter", "SSPA", "sva", "limma", "KEGGgraph", "siggenes","BiocParallel", "MSnbase", "multtest","RBGL","edgeR","fgsea","devtools","crmn")
list_installed <- installed.packages()
new_pkgs <- subset(metr_pkgs, !(metr_pkgs %in% list_installed[, "Package"]))
if(length(new_pkgs)!=0){if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
        BiocManager::install(new_pkgs)
        print(c(new_pkgs, " packages added..."))
    }

if((length(new_pkgs)<1)){
        print("No new packages added...")
    }
}

metanr_packages()

# Choose respositories 1-4
setRepositories()

# Even after respositories selected, still can't find a compatible mnormt. Choose an older one.
install_version("mnormt", version = "1.5-5", repos = "http://cran.us.r-project.org")

# Similar with XML
install_version("XML", version = "3.99-0.3", repos = "http://cran.us.r-project.org")
