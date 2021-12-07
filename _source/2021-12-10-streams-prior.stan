data {

}

parameters {
  real<lower=0> mu;     // the mean
  real<lower=0> sigma;  // the standard deviation
}

model {
  // define priors for mu and sigma
  mu ~ normal(1, .1);
  sigma ~ normal(0, .1);
}

generated quantities {
  // simulate data using a normal distribution
  real y_hat = normal_rng(mu, sigma);
}
