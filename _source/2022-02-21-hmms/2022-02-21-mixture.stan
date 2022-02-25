data {
  int<lower=0> N;             // number of data points
  vector<lower=0>[N] y;       // data points
}

transformed data {
  real<lower=0> y_max = max(y);
}

parameters {
  real<lower=0, upper=1> theta;    // mixing proportion
  real mu;                         // lognormal location
  real<lower=0> sigma;             // lognormal scale
}

model {
  theta ~ uniform(0, 1);
  mu ~ std_normal();
  sigma ~ std_normal();

  for (n in 1:N) {
    target += log_mix(theta,
		      lognormal_lpdf(y[n] | mu, sigma),
		      uniform_lpdf(y[n] | 0, y_max)); 
  }
}

generated quantities {
  vector<lower=0, upper=1>[N] z_rep;   // simulated latent variables
  vector<lower=0>[N] y_rep;            // simulated data points

  for (n in 1:N) {
    z_rep[n] = bernoulli_rng(theta);

    if (z_rep[n] == 1)
      y_rep[n] = lognormal_rng(mu, sigma);
    else
      y_rep[n] = uniform_rng(0, y_max);    
  }
}
