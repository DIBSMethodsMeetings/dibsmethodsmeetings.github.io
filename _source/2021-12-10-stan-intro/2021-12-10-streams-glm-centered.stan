data {
  int<lower=0> N;      // the number of data points
  int<lower=0> K;      // the number of regression coefficients
  matrix[N, K] X;      // the predictor variables
  vector[N] y;         // the outcome variable
}

transformed data {
  vector[K] X_means;
  matrix[N, K] X_centered;
  
  for (k in 1:K) {
    X_means[k] = mean(X[, k]);
    X_centered[, k] = X[, k] - X_means[k];
  }
}

parameters {
  real alpha_centered;
  vector[K] beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = alpha_centered + X_centered*beta;
}

model {
  alpha_centered ~ normal(0, 1);
  beta ~ normal(0, .01);
  sigma ~ normal(0, 1);

  y ~ normal(mu, sigma);
}

generated quantities {
  real alpha = alpha_centered - dot_product(X_means, beta);
  real y_hat[N] = normal_rng(mu, sigma);
}
