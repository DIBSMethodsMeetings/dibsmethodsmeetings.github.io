data {
  real<lower=0> mu;       // the mean
  real<lower=0> sigma;    // the standard deviation
}

parameters {
}

model {
}

generated quantities {
  // simulate data using a normal distribution
  real y_hat = normal_rng(mu, sigma);
}
