data {
  int<lower=0> N;         // the number of data points
  vector<lower=0>[N] y;   // the data to model
}

parameters {
  real<lower=0> mu;       // the mean
  real<lower=0> sigma;    // the standard deviation
}

model {
  // define priors for mu and sigma
  mu ~ normal(0, .1);
  sigma ~ normal(0, .1);

  // define the likelihood of y
  y ~ lognormal(mu, sigma);
}

generated quantities {
  // simulate data using a normal distribution
  real y_hat = lognormal_rng(mu, sigma);
}
