// Main model

data {
  int<lower=0> N_obs;            // number of observations
  int<lower=0> N_cf_cns_pos;         // number of pos constrained coefficients
  int<lower=0> N_cf_cns_neg;    // number of neg constrained coefficients
  int<lower=0> N_cf_oth;         // number of other coefficients    
  int<lower=0> N_cf_u;           // number of coefs due to unmod. subj-level var
  int<lower=0> N_cf_w;           // number of coefs due to unmod. item-level var 
  
  // subjects
  int<lower=1> subj[N_obs];      // subject id  
  int<lower=1> N_subj;           // number of subjects

  //items
  int<lower=1> item[N_obs];      // item id
  int<lower=1> N_item;           // number of items
  
  matrix[N_obs, N_cf_cns_pos] x_cns_pos;// predictors: constrained  pos
  matrix[N_obs, N_cf_cns_neg] x_cns_neg;// predictors: constrained  neg
  matrix[N_obs, N_cf_oth] x_oth; // predictors: unconstrained
  matrix[N_obs, N_cf_u] x_u;     // predictors ass. with unmod. subj-level var
  matrix[N_obs, N_cf_w] x_w;     // predictors ass. with unmod. item-level var
  
  int accuracy[N_obs];           // DEPENDENT VARIABLE: accuracy

/////NEW
  real<lower=0> scale_global;   // scale for the half-t prior for tau
  real<lower=1> nu_global;      // degrees of freedom for the half-t prior for tau
  real<lower=0> nu_local;        // degrees of freedom for the half-t prior for lambdas
  real<lower=0> slab_scale;      // slab scale for the regularized horseshoe
  real<lower=0> slab_df;        // slab degrees of freedom for the regularized horseshoe

}

parameters {
  vector<lower=0>[N_cf_cns_pos] beta_cns_pos; // constrained pos betas
  vector[N_cf_oth] beta_oth; // unconstrained betas
  vector<lower=0>[N_cf_cns_neg] z; //
    
  vector<lower=0> [N_cf_u] sigma_u;   // subject-level sd
  cholesky_factor_corr[N_cf_u] L_u;   // subject-level correlation (decomposed)
  matrix[N_cf_u,N_subj] z_u;          // subject-level correlation (decomposed)

  vector<lower=0> [N_cf_w] sigma_w; // item-level sd
  cholesky_factor_corr[N_cf_w] L_w; // item-level correlation (decomposed)
  matrix[N_cf_w,N_item] z_w;          // item-level correlation (decomposed)

  real sigma_e;                       // residual sd


  real<lower=0> aux1_global;
  real<lower=0> aux2_global;
  vector<lower=0>[N_cf_cns_neg] aux1_local;  //
  vector<lower=0>[N_cf_cns_neg] aux2_local;  //
  real<lower=0> caux;
  

}


transformed parameters {
  
  real<lower=0> c;                      // slab  scale
  vector<lower=0>[N_cf_cns_neg] lambda_tilde;   // ’truncated ’ local  shrinkage  parameter
  real<lower=0> tau;                       // global  shrinkage  parameter
  vector<lower=0>[N_cf_cns_neg] lambda;          // local  shrinkage  parameter
  
  vector[N_cf_cns_neg] beta_cns_neg;
  vector[N_obs] mu;
  
  
  matrix[N_cf_u,N_subj] u;
  matrix[N_cf_w,N_item] w;
  

  {matrix[N_cf_u,N_cf_u] Lambda_u;
   Lambda_u = diag_pre_multiply(sigma_u,L_u);
   u = Lambda_u * z_u;}

  {matrix[N_cf_w,N_cf_w] Lambda_w;
   Lambda_w =  diag_pre_multiply(sigma_w,L_w);  
   w = Lambda_w * z_w;}

  c = slab_scale * sqrt(caux);
  lambda = aux1_local .* sqrt(aux2_local );  
  tau = aux1_global * sqrt(aux2_global) * scale_global;
  lambda_tilde = sqrt( c^2 * square(lambda) ./ (c^2 + tau^2* square(lambda )) );
  
  
  beta_cns_neg = z .*  lambda_tilde*tau;


  mu = sigma_e + x_cns_pos*beta_cns_pos - x_cns_neg*beta_cns_neg + x_oth*beta_oth;
  
  for (i in 1:N_obs) {
    for (uu in 1:N_cf_u)
      mu[i] = mu[i] + x_u[i,uu]*u[uu, subj[i]];
    for (ww in 1:N_cf_w)
      mu[i] = mu[i] + x_w[i,ww]*w[ww, item[i]];
  }
}



model {

  sigma_u ~ normal(0,1);
  sigma_w ~ normal(0,1);

  sigma_e ~ normal(0,10); // between -10 and 10 on log odds scale

  beta_cns_pos ~ normal(0,10); 
  beta_oth ~ normal(0,10); 

  L_u ~ lkj_corr_cholesky(2.0); // uninformative: see ???
  L_w ~ lkj_corr_cholesky(2.0);

  to_vector(z_u) ~ normal(0,1); // idea: ???
  to_vector(z_w) ~ normal(0,1);

///////////

  // half -t priors  for  lambdas  and tau , and  inverse -gamma  for c^2

  z ~ normal(0, 1);
  aux1_local ~ normal(0, 1);
  aux2_local ~ inv_gamma (0.5* nu_local , 0.5* nu_local );

  aux1_global ~ normal(0, 1);
  aux2_global ~ inv_gamma (0.5* nu_global , 0.5* nu_global );

  caux ~ inv_gamma (0.5* slab_df , 0.5* slab_df );

  accuracy ~ bernoulli_logit(mu);
}




generated quantities{


 real log_lik[N_obs];

  for (i in 1:N_obs){
  log_lik[i] = bernoulli_logit_lpmf(accuracy[i]|mu[i]);
 }

}
