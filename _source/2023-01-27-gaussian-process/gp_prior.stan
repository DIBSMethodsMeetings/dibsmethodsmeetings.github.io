data {
  int<lower=0> N;
  array[N] real x;
  real sigma;
  real rho;
}

transformed data {
  matrix[N, N] K = gp_exp_quad_cov(x, sigma, rho);

  for (n in 1:N)
    K[n, n] = K[n, n] + 1e-10;
  
  vector[N] mu = rep_vector(0, N);
}

parameters {
  
}

model {

}

generated quantities {
  vector[N] y_pred = multi_normal_rng(mu, K);
}
