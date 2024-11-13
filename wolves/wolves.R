{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf600
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 library(MixSIAR)\
mixsiar.dir <- find.package("MixSIAR")\
paste0(mixsiar.dir,"/example_scripts")\
library(MixSIAR)\
# Replace the system.file call with the path to your file\
mix.filename <- system.file("extdata", "wolves_consumer.csv", package = "MixSIAR")\
\
# Load the mixture/consumer data\
mix <- load_mix_data(filename=mix.filename, \
                     iso_names=c("d13C","d15N"), \
                     factors=c("Region","Pack"), \
                     fac_random=c(TRUE,TRUE), \
                     fac_nested=c(FALSE,TRUE), \
                     cont_effects=NULL)\
\
# Replace the system.file call with the path to your file\
source.filename <- system.file("extdata", "wolves_sources.csv", package = "MixSIAR")\
\
# Load the source data\
source <- load_source_data(filename=source.filename,\
                           source_factors="Region", \
                           conc_dep=FALSE, \
                           data_type="means", \
                           mix)\
\
# Replace the system.file call with the path to your file\
discr.filename <- system.file("extdata", "wolves_discrimination.csv", package = "MixSIAR")\
\
# Load the discrimination/TDF data\
discr <- load_discr_data(filename=discr.filename, mix)\
\
# Make an isospace plot\
plot_data(filename="isospace_plot", plot_save_pdf=TRUE, plot_save_png=FALSE, mix,source,discr)\
\
# Calculate the convex hull area, standardized by source variance\
##Note 1: discrimination SD is added to the source SD (see ?calc_area for details)\
##Note 2: If source data are by factor (as in wolf ex), computes area for each polygon (one for each of 3 regions in wolf ex)\
calc_area(source=source,mix=mix,discr=discr)\
\
# default "UNINFORMATIVE" / GENERALIST prior (alpha = 1)\
plot_prior(alpha.prior=1,source)\
\
# Write the JAGS model file\
model_filename <- "MixSIAR_model.txt"   # Name of the JAGS model file\
resid_err <- TRUE\
process_err <- TRUE\
write_JAGS_model(model_filename, resid_err, process_err, mix, source)\
\
#run model\
jags.1 <- run_model(run="normal", mix, source, discr, model_filename)\
\
#output\
output_options <- list(summary_save = TRUE,\
                       summary_name = "summary_statistics",\
                       sup_post = FALSE,\
                       plot_post_save_pdf = TRUE,\
                       plot_post_name = "posterior_density",\
                       sup_pairs = FALSE,\
                       plot_pairs_save_pdf = TRUE,\
                       plot_pairs_name = "pairs_plot",\
                       sup_xy = TRUE,\
                       plot_xy_save_pdf = TRUE,\
                       plot_xy_name = "xy_plot",\
                       gelman = TRUE,\
                       heidel = FALSE,\
                       geweke = TRUE,\
                       diag_save = TRUE,\
                       diag_name = "diagnostics",\
                       indiv_effect = FALSE,\
                       plot_post_save_png = FALSE,\
                       plot_pairs_save_png = FALSE,\
                       plot_xy_save_png = FALSE,\
                       diag_save_ggmcmc = FALSE)\
\
output_JAGS(jags.1, mix, source, output_options)\
\
}