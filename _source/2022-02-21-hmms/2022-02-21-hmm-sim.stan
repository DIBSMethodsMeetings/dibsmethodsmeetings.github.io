data {
  int<lower=0> N;             // number of data points
  vector<lower=0>[N] y;       // data points
}

transformed data {
  int K = 2;                  // number of latent states (1=attentive, 2=guess)
  real y_max = max(y);        // maximum y value
}

parameters {
  array[K] simplex[K] theta;  // transition matrix
    
  real mu;                    // lognormal location
  real<lower=0> sigma;        // lognormal scale
}

transformed parameters {
  simplex[K] pi;              // starting probabilities

  {
    // copy theta to a matrix
    matrix[K, K] t;
    for(j in 1:K){
      for(i in 1:K){
	t[i,j] = theta[i,j];
      }
    }

    // solve for pi (assuming pi = pi * theta)
    pi = to_vector((to_row_vector(rep_vector(1.0, K))/
		    (diag_matrix(rep_vector(1.0, K)) - t + rep_matrix(1, K, K))));
  }  
}

model {
  for (k in 1:K)
    theta[k] ~ dirichlet([1, 1]');
  
  mu ~ std_normal();
  sigma ~ std_normal();
}

generated quantities {
  array[N] int<lower=1, upper=K> z_rep;   // simulated latent variables
  vector<lower=0>[N] y_rep;               // simulated data points

  // simulate starting state
  z_rep[1] = categorical_rng(pi);
  if (z_rep[1] == 1)
      y_rep[1] = lognormal_rng(mu, sigma);
    else
      y_rep[1] = uniform_rng(0, y_max);

  // simulate forward
  for (n in 2:N) {
    z_rep[n] = categorical_rng(theta[z_rep[n-1]]);
    
    if (z_rep[n] == 1)
      y_rep[n] = lognormal_rng(mu, sigma);
    else
      y_rep[n] = uniform_rng(0, y_max);    
  }
}
