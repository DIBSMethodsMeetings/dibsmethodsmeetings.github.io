data {
  int<lower=0> N;      // the number of data points
  int<lower=0> K;      // the number of regression coefficients
  matrix[N, K] X;      // the predictor variables
  vector[N] y;         // the outcome variable

  int<lower=0> N_pred;        // the number of prediction points
  matrix[N_pred, K] X_pred;   // the prediction points
}

parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = alpha + X*beta;
}

model {
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);

  y ~ normal(mu, sigma);
}

generated quantities {
  real y_hat[N] = normal_rng(mu, sigma);

  vector[N_pred] mu_pred = alpha + X_pred*beta;
  real y_pred_hat[N_pred] = normal_rng(mu_pred, sigma);
}
