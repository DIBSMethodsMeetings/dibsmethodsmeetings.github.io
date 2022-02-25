data {
  int<lower=0> N;      // the number of data points
  int<lower=0> K;      // the number of regression coefficients
  matrix[N, K] X;      // the predictor variables
  vector[N] y;         // the outcome variable
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
}
