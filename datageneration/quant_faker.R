#!/usr/bin/env Rscript

library("optparse")
library("sn")
library("distr")
library("plyr")

option_list = list(
  make_option(c("-s", "--seed"), type="integer", default=42,
              help="seed of the generator", metavar="character"),
  make_option(c("-n", "--n_samples"), type="integer", default=40,
              help="number of samples", metavar="character")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);
set.seed(opt$seed)

count_total_participants = opt$n_samples


is_experienced <- function(programming_skill_individual,python_skill_individual) {
  return(programming_skill_individual > 4 ||  python_skill_individual >2)
}

max_years = 10

#scale => larger = flatter, shape => moves peak
programming_skill_generator<-Truncate(Weibull(scale=4,shape=2),lower=0,upper=max_years)
programing_skills <- ceiling(programming_skill_generator@r(count_total_participants))


generators <- c()
for (i in 1:max_years){
  gen <- Truncate(Exp(rate=0.25),lower=0, i)
  generators <<- c(generators, gen )
}

get_python_exp <- function(programming_year){

  python_skill <- 0
  if (programming_year > 0) {
    python_skill_generator <- generators[[programming_year]]
    python_skill <- ceiling(python_skill_generator@r(1))
  }
  return(python_skill)
}


python_skills <- c()
counts_as_experienced<- c()
for (years in programing_skills) {
  python_year<- get_python_exp(years)
  python_skills <-c(python_skills,python_year)
  counts_as_experienced <- c(counts_as_experienced, is_experienced(years,python_year))
}

used_copilot <- logical(count_total_participants)#pre-allocate for performance
for (i in 1:count_total_participants){
  used_copilot[i-1] <- (i >count_total_participants/2)
}

setClass("Participant",slots=list(skill="numeric",python_skill="numeric",counts_as_experienced="logical",used_copilot="logical"))



participants <- c()
task_0_sub_0_valid <- c()
task_0_sub_1_valid <- c()
task_0_sub_2_valid <- c()
task_0_time <- c()

task_1_time <- c()
task_1_complexity <- c()
task_1_valid <- c()

task_2_time <- c()
task_2_valid <- c()

task_3_time <- c()
task_3_valid <- c()

lower_bound_task_0_time <- 71
lower_bound_task_1_time <- 610
lower_bound_task_2_time <- 590
lower_bound_task_3_time <- 310

lower_bound_task_1_complexity <-5

data_point_copilot_experienced <- function(){
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, TRUE)#always valid
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1, prob=c(.95,.05)))#95% valid, 5% invalid
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.90,.10)))#90% valid, 10% invalid
  task_0_time <<- c(task_0_time, rnorm(1, mean=lower_bound_task_0_time, sd=5))# 

  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.8, .2))# task 1 80% valid, 20% invalid
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean=lower_bound_task_1_time, sd=90))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean=lower_bound_task_1_complexity, sd=2))) #tbd
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean=lower_bound_task_2_time, sd=50))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.94, .06))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_3_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean=lower_bound_task_3_time, sd=40))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }
}

data_point_copilot_beginner <- function(){
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, TRUE)
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1,prob=c(.93,.07)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.89,.11)))
  task_0_time <<- c(task_0_time, rnorm(1, mean=lower_bound_task_0_time+5, sd=10))

  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.72, .28))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean=lower_bound_task_1_time*1.15, sd=80))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean=lower_bound_task_1_complexity+1, sd=5))) #tbd
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.91, .09))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean=lower_bound_task_2_time+100, sd=60))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.93, .07))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean=lower_bound_task_3_time+50, sd=40))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }

}

data_point_no_copilot_experienced <- function(){
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, sample(c(TRUE,FALSE), 1, prob=c(.96,.04)))
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1, prob=c(.93,.07)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.93,.07)))
  task_0_time <<- c(task_0_time, rnorm(1, mean=lower_bound_task_0_time*1.1, sd=20))

  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.7, .3))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean=lower_bound_task_1_time*1.4, sd=56))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean=lower_bound_task_1_complexity, sd=5))) #tbd
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.94, .06))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean=lower_bound_task_2_time, sd=40))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean=lower_bound_task_3_time*1.4, sd=42))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }
}

data_point_no_copilot_beginner <- function(){
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, sample(c(TRUE,FALSE), 1, prob=c(.94,.06)))
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1,prob=c(.92,.08)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.90,.10)))
  task_0_time <<- c(task_0_time, rnorm(1, mean=lower_bound_task_0_time*1.6, sd=17))

  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.65, .35))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean=lower_bound_task_1_time*1.2, sd=95))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean=lower_bound_task_1_complexity, sd=5))) #tbd
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.91, .09))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean=lower_bound_task_2_time, sd=50))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean=lower_bound_task_3_time*1.5, sd=44))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }
}



#structuring for easier debugging
for(i in 1:count_total_participants){
  participants <- c(participants,new("Participant",
                                     skill=programing_skills[i],
                                     python_skill=python_skills[i],
                                     counts_as_experienced=counts_as_experienced[i],
                                     used_copilot=used_copilot[i]))
}


for (participant in participants) {
  if (participant@used_copilot) {
    if (participant@counts_as_experienced) {
      data_point_copilot_experienced()
    }
    else{
      data_point_copilot_beginner()
    }
  }
  else{
    if (participant@counts_as_experienced) {
      data_point_no_copilot_experienced()
    }
    else{
      data_point_no_copilot_beginner()
    }
  }
}

data_frame = data.frame(
  programing_skills,
  python_skills,
  counts_as_experienced,
  used_copilot,


  task_0_sub_0_valid,
  task_0_sub_1_valid,
  task_0_sub_2_valid,
  task_0_time,

  task_1_valid,
  task_1_time,
  task_1_complexity,

  task_2_valid,
  task_2_time,

  task_3_valid,
  task_3_time
)
write.csv(data_frame, "quant_data.csv")

