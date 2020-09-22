# Based on https://bioconductor.org/packages/release/bioc/vignettes/xcms/inst/doc/xcms.html

library(xcms)
library(RColorBrewer)
library(pander)
library(magrittr)
library(pheatmap)
library(SummarizedExperiment)

data_folder = "/Users/errontitus/lab-private/tox-mass-spec/data/2020-08-20-export-proteowizard"

## Get the full path to the mzXML files
mzXML_urine <- dir(data_folder, pattern = "URINE", full.names = TRUE, recursive = FALSE)
mzXML_blood <- dir(data_folder, pattern = "BLOOD", full.names = TRUE, recursive = FALSE)
mzXML = rbind(mzXML_urine,mzXML_blood)

## Create a phenodata data.frame
# pd <- data.frame(sample_name = sub(basename(mzXML), pattern = ".mzXML",replacement = "", fixed = TRUE),sample_group = "blood",stringsAsFactors = FALSE)
pd_urine <- data.frame(sample_name = sub(basename(mzXML_urine), pattern = ".mzXML", replacement = "", fixed = TRUE),sample_group = "urine",stringsAsFactors = FALSE)
pd_urine <- transform(pd_urine, sample_name_short = paste("U", as.numeric(interaction(sample_name, drop=TRUE)),sep = ""))

pd_blood <- data.frame(sample_name = sub(basename(mzXML_blood), pattern = ".mzXML", replacement = "", fixed = TRUE),sample_group = "blood",stringsAsFactors = FALSE)
pd_blood <- transform(pd_blood, sample_name_short = paste("B", as.numeric(interaction(sample_name, drop=TRUE)),sep = ""))

pd = rbind(pd_urine,pd_blood)

## Not needed. Sample group assignment handled by loading urine and blood files separately.
# pd$sample_group[grepl("URINE", pd$sample_name, fixed = TRUE)] <- "urine" 

raw_data <- readMSData(files = mzXML, pdata = new("NAnnotatedDataFrame", pd), mode = "onDisk")

head(rtime(raw_data))

mzs <- mz(raw_data)

## Split the list by file
mzs_by_file <- split(mzs, f = fromFile(raw_data))

length(mzs_by_file)


## Get the base peak chromatograms. This reads data from the files.
bpis <- chromatogram(raw_data, aggregationFun = "max")
## Define colors for the two groups
group_colors <- paste0(brewer.pal(3, "Set1")[1:2], "60")
names(group_colors) <- c("blood", "urine")

## Plot all chromatograms.
plot(bpis, col = group_colors[raw_data$sample_group])


## Get the total ion current by file
tc <- split(tic(raw_data), f = fromFile(raw_data))
boxplot(tc, col = group_colors[raw_data$sample_group],
        ylab = "intensity", main = "Total ion current")



## Bin the BPC
bpis_bin <- bin(bpis, binSize = 2)

## Calculate correlation on the log2 transformed base peak intensities
## Adding 1 to every intensity value because some values are 0.
cormat <- cor(log2(1 + do.call(cbind, lapply(bpis_bin, intensity))))
colnames(cormat) <- rownames(cormat) <- raw_data$sample_name_short

## Define which phenodata columns should be highlighted in the plot
ann <- data.frame(group = raw_data$sample_group)
rownames(ann) <- raw_data$sample_name_short

## Perform the cluster analysis
pheatmap(cormat, annotation = ann,
         annotation_color = list(group = group_colors))

## Define the rt and m/z range of the peak area
rtr <- c(600, 800)
mzr <- c(330, 340)
## extract the chromatogram
chr_raw <- chromatogram(raw_data, mz = mzr, rt = rtr)
plot(chr_raw, col = group_colors[chr_raw$sample_group])


raw_data %>%
    filterRt(rt = rtr) %>%
    filterMz(mz = mzr) %>%
    plot(type = "XIC")