data {
  int<lower=0> N;             // number of data points
  vector<lower=0>[N] y;       // data points
}

parameters {
  real mu;                    // lognormal location
  real<lower=0> sigma;        // lognormal scale
}

model {
  mu ~ std_normal();
  sigma ~ std_normal();
  y ~ lognormal(mu, sigma);
}

generated quantities {
  // simulated data points
  vector<lower=0>[N] y_rep;

  for (n in 1:N)
    y_rep[n] = lognormal_rng(mu, sigma);
}
