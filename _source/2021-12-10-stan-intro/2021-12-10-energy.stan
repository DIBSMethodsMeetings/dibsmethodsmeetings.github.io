data {
  int<lower=0> N;                 // the number of data points
  vector[N] x;                    // the loudness of each song
  vector<lower=0, upper=1>[N] y;  // the energy level of each song
}

parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = alpha + beta*x;
}

model {
  alpha ~ normal(.5, .5);
  beta ~ normal(0, .1);
  sigma ~ normal(0, 1);

  y ~ normal(mu, sigma);
}

generated quantities {
  real y_hat[N] = normal_rng(mu, sigma);
}
