//
// This stan file defines a two learning rate reinforcement learning model for a two-armed bandit task.
//


data {
  int<lower = 0> nArms; //number of bandit arms
  int<lower = 0> nTrials; //number of trials
  int<lower = 1> armChoice[nTrials]; //index of which arm was pulled
  int<lower = 0> result[nTrials]; //outcome of bandit arm pull
}

parameters {
  real<lower = 0, upper = 1> alpha_r; //learning rate for rewarded trials
  real<lower = 0, upper = 1> alpha_n; //learning rate for no reward trials
  real beta; //softmax parameter - inverse temperature
}

transformed parameters {
  vector<lower=0, upper=1>[nArms] Q[nTrials];  // value function for each arm
  real delta[nTrials];  // prediction error

  for (trial in 1:nTrials) {

    //set initial Q and delta for each trial
    if (trial == 1) {

      //if first trial, initialize Q values as specified
      for (a in 1:nArms) {
        Q[1, a] = 0;
      }

    } else {

      //otherwise, carry forward Q from last trial to serve as initial value
      for (a in 1:nArms) {
        Q[trial, a] = Q[trial - 1, a];
      }

    }

    //calculate prediction error and update Q (based on specified beta)
    delta[trial] = result[trial] - Q[trial, armChoice[trial]];

    //update Q value based on prediction error (delta) and learning rate (alpha)
    if (result[trial] == 0){ // no reward trial
      Q[trial, armChoice[trial]] = Q[trial, armChoice[trial]] + alpha_n * delta[trial];
    }else{ // rewarded trial
      Q[trial, armChoice[trial]] = Q[trial, armChoice[trial]] + alpha_r * delta[trial];
    }
    
  }
}

model {
  // priors
  beta ~ normal(0, 5);
  alpha_r ~ beta(1, 1);
  alpha_n ~ beta(1, 1);

  for (trial in 1:nTrials) {
    //returns the probability of having made the choice you made, given your beta and your Q's
    target += log_softmax(Q[trial] * beta)[armChoice[trial]];
  }
}

generated quantities{
  vector[nTrials] log_lik; // log likelihood for model comparison later
  
  for (trial in 1:nTrials){
    log_lik[trial] = bernoulli_logit_lpmf(armChoice[trial] - 1 | beta * (Q[trial,2]-Q[trial,1])); 
  }
  
}

