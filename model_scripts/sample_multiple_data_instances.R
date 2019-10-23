sample_binary_four<-"fn_sample_binary_four_function.R"
source(sample_binary_four)


coef_dist <- -.1784  #effect of acoustic distance. taken from pilot data 


for (i in 1:100){
  
  data_i <- sample_binary_four(d = full_design,
                               response_var = "response_var",
                               predictor_vars = c("Econ",
                                                  "Glob",
                                                  "Loc",
                                                  "acoustic_distance"),
                               
                               coef_values = c(
                                 10, #econ
                                 10,  #loc
                                 10,   #glob
                                 coef_dist),
                               
                               intercept = 1.3592
  )
  
  readr::write_csv(data_i,path = paste0("sampled_data/hindi/reps/econ_10_loc_10_glob_10_rep",i, ".csv"))
}