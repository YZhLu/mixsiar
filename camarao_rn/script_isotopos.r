# Carregar o pacote "here"
library(here)

# Definir os caminhos relativos com base no diretório do script
mix.filename <- here("mix_data_id_30.csv")
source.filename <- here("source_data_30.csv")
discr.filename <- here("discrimination_geral_sem_bercario_30.csv")

# Carregar os dados da mistura
mix <- load_mix_data(filename=mix.filename, 
                     iso_names=c("d13C", "d15N"), 
                     factors="nome", 
                     fac_random=FALSE, 
                     fac_nested=FALSE, 
                     cont_effects=NULL)

# Carregar os dados da fonte
source <- load_source_data(filename=source.filename, 
                           source_factors=NULL, 
                           conc_dep=FALSE, 
                           data_type="raw", 
                           mix)

# Carregar os dados de discriminação
discr <- load_discr_data(filename=discr.filename, mix)

# Plotar os dados
plot_data(filename="isospace_plot", 
          plot_save_pdf=TRUE, 
          plot_save_png=FALSE, 
          mix, source, discr)

# Calcular a área do casco convexo padronizado (caso 2 isótopos)
if(mix$n.iso == 2) calc_area(source=source, mix=mix, discr=discr)

# Plotar o prior não informativo
plot_prior(alpha.prior=1, source, filename="prior_plot_uninf")

# Definir a estrutura do modelo e escrever o arquivo JAGS
model_filename <- "MixSIAR_model_uninf.txt"   # Nome do arquivo do modelo JAGS
resid_err <- FALSE
process_err <- TRUE
write_JAGS_model(model_filename, resid_err, process_err, mix, source)

# Rodar o modelo JAGS
jags.uninf <- run_model(run="short", mix, source, discr, model_filename)

# Processar diagnósticos, estatísticas resumidas e gráficos posteriores
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

