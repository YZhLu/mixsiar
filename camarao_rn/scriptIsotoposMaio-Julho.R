#Maio/2021
# Usando RStudio version 1.2.1335, R version 3.6.3 
# JAGS 4.3.0, e os pacotes rjags version 4-10 e runjags version 2.2.0-2
# MixSIAR version 3.1.12

#check which version of R (and any packages) you are running using the command
sessionInfo()

#Install GTK+ dependent packages.O gWidgets e gWidgetsRGtk2 nao estao disponiveis, usei gWidgets2
#install.packages(c("gWidgets2", "RGtk2", "gWidgetsRGtk2", "devtools"))

#Instalei XQuartz version 2.8.1
#Instalei MixSIAR
#library(devtools)
#devtools::install_github("brianstock/MixSIAR",
#                         dependencies = TRUE,
#                         build_vignettes = TRUE) 

#Vamos começar!!!
library(MixSIAR)




### Load mixture data
mix.filename <- "mix_data_id_30.csv"

mix <- load_mix_data(filename=mix.filename, 
                     iso_names=c("d13C","d15N"), 
                     factors= "nome", 
                     fac_random= FALSE, 
                     fac_nested= FALSE, 
                     cont_effects= NULL)


### Load source data
source.filename <- "source_data_30.csv"

source <- load_source_data(filename=source.filename,
                           source_factors=NULL, 
                           conc_dep=FALSE, 
                           data_type="raw", 
                           mix)

### Load discrimination data
discr.filename <- "discrimination_geral_sem_bercario_30.csv"

discr <- load_discr_data(filename=discr.filename, mix)


### Plot data
# Make isospace plot
plot_data(filename="isospace_plot",
          plot_save_pdf=TRUE,
          plot_save_png=FALSE,
          mix,source,discr)


# Calculate standardized convex hull area
if(mix$n.iso==2) calc_area(source=source,mix=mix,discr=discr)


# Plot uninformative prior
plot_prior(alpha.prior=1, source, filename = "prior_plot_uninf")


# Define model structure and write JAGS model file
model_filename <- "MixSIAR_model_uninf.txt"   # Name of the JAGS model file
resid_err <- FALSE
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)


# Run the JAGS model (por "phase" "short" took ~30 min, "long" took 3h20min, "short" took 1h20min, "normal" took 1h50min ///// por "id" "long" took 1h, "very long" 3h )
jags.uninf <- run_model(run="short",mix,source,discr,model_filename)

# Process diagnostics, summary stats, and posterior plots
output_JAGS(jags.uninf, mix, source,  
            output_options = list(summary_save = TRUE, 
                                  summary_name = "summary_statistics_30",
                                  sup_post = FALSE, 
                                  plot_post_save_pdf = TRUE, 
                                  plot_post_name = "posterior_density_30",
                                  sup_pairs = FALSE, 
                                  plot_pairs_save_pdf = TRUE, 
                                  plot_pairs_name = "pairs_plot_30", 
                                  sup_xy = FALSE, 
                                  plot_xy_save_pdf = TRUE, 
                                  plot_xy_name = "xy_plot_30", 
                                  gelman = TRUE, 
                                  heidel = FALSE, 
                                  geweke = TRUE, 
                                  diag_save = TRUE, 
                                  diag_name = "diagnostics_30", 
                                  indiv_effect = FALSE, 
                                  plot_post_save_png = FALSE, 
                                  plot_pairs_save_png = FALSE, 
                                  plot_xy_save_png = FALSE, 
                                  diag_save_ggmcmc = TRUE)
)

