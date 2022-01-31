#!/usr/bin/env Rscript

library("optparse")
library("distr")
library("plyr")

option_list = list(
  make_option(c("-s", "--seed"), type = "integer", default = 42,
              help = "seed of the generator", metavar = "character"),
  make_option(c("-n", "--n_samples"), type = "integer", default = 40,
              help = "number of samples", metavar = "character")
);

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);
set.seed(opt$seed)

count_total_participants = opt$n_samples


is_experienced <- function(programming_skill_individual, python_skill_individual) {
  return(programming_skill_individual > 4 || python_skill_individual > 2)
}

max_years = 10


experienced_tried_copilot_generator <- function() { return(sample(c(TRUE, FALSE), 1, prob = c(.10, .90))) }
beginner_tried_copilot_generator <- function() { return(sample(c(TRUE, FALSE), 1, prob = c(.5, .95))) }

experienced_used_ai_coding_aids_generator <- function() { return(sample(c(TRUE, FALSE, NA), 1, prob = c(.30, .50, .20))) }
beginner_used_ai_coding_aids_generator <- function() { return(sample(c(TRUE, FALSE, NA), 1, prob = c(.05, .15, .80))) }


tried_github_copilot <- c()
used_ai_coding_aids <- c()

#scale => larger = flatter, shape => moves peak
programming_skill_generator <- Truncate(Weibull(scale = 4, shape = 2), lower = 0, upper = max_years)
experience_in_years <- ceiling(programming_skill_generator@r(count_total_participants))
experience_in_python <- c()


generators <- c()
for (i in 1:max_years) {
  gen <- Truncate(Norm(mean = i*.9,sd=(i-.5)/3), lower = 0, i)
  generators <<- c(generators, gen)
}


get_python_exp <- function(programming_year) {
  python_skill <- 0
  if (programming_year > 0) {
    python_skill_generator <- generators[[programming_year]]
    python_skill <- ceiling(python_skill_generator@r(1))
  }
  return(python_skill)
}


counts_as_experienced <- c()
for (years in experience_in_years) {
  python_year <- get_python_exp(years)
  experience_in_python <- c(experience_in_python, python_year)
  is_experienced_individual <- is_experienced(years, python_year)
  counts_as_experienced <- c(counts_as_experienced, is_experienced_individual)
  if (is_experienced_individual) {
    tried_github_copilot <- c(tried_github_copilot, experienced_tried_copilot_generator())
    used_ai_coding_aids <- c(used_ai_coding_aids, experienced_used_ai_coding_aids_generator())
  }
  else {
    tried_github_copilot <- c(tried_github_copilot, beginner_tried_copilot_generator())
    used_ai_coding_aids <- c(used_ai_coding_aids, beginner_used_ai_coding_aids_generator())
  }
}

used_copilot <- logical(count_total_participants) #pre-allocate for performance
for (i in 1:count_total_participants) {
  used_copilot[i - 1] <- (i > count_total_participants / 2)
}

setClass("Participant", slots = list(skill = "numeric", python_skill = "numeric", counts_as_experienced = "logical", used_copilot = "logical"))



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

lower_bound_task_1_complexity <- 10

create_generator <- function(scale, shape) {
  return(Truncate(Weibull(scale = scale, shape = shape), lower = 1, upper = 5))
}


suggestions_were_useful <- c()
understand_written_code <- c()
repetitive_tasks_were_tedious <- c()
feel_comfortable_working_with_library <- c()

suggestions_were_useful_c_e_generator <- create_generator(scale = 8, shape = 3)
suggestions_were_useful_c_b_generator <- create_generator(scale = 8, shape = 3)
suggestions_were_useful_nc_e_generator <- create_generator(scale = 3.0, shape = 5)
suggestions_were_useful_nc_b_generator <- create_generator(scale = 3.5, shape = 5)

understand_written_code_c_e_generator <- create_generator(scale = 4.5, shape = 8)
understand_written_code_c_b_generator <- create_generator(scale = 3, shape = 6)
understand_written_code_nc_e_generator <- create_generator(scale = 4.2, shape = 7)
understand_written_code_nc_b_generator <- create_generator(scale = 3.5, shape = 6)

repetitive_tasks_were_tedious_c_e_generator <- create_generator(scale = 4.5, shape = 5)
repetitive_tasks_were_tedious_c_b_generator <- create_generator(scale = 4.2, shape = 5)
repetitive_tasks_were_tedious_nc_e_generator <- create_generator(scale = 3.8, shape = 5)
repetitive_tasks_were_tedious_nc_b_generator <- create_generator(scale = 4.0, shape = 5)

feel_comfortable_working_with_library_c_e_generator <- create_generator(scale = 4.5, shape = 7)
feel_comfortable_working_with_library_c_b_generator <- create_generator(scale = 4.2, shape = 7)
feel_comfortable_working_with_library_nc_e_generator <- create_generator(scale = 3.8, shape = 7)
feel_comfortable_working_with_library_nc_b_generator <- create_generator(scale = 4.0, shape = 7)


get_skill_bonus_factor <- function(participant){
  return(1.05 + (-0.05* min(participant@python_skill, 1) +  (-0.02* min(participant@skill, 1))))
}


data_point_copilot_experienced <- function(participant) {
  python_time_factor = get_skill_bonus_factor(participant)

  task_0_sub_0_valid <<- c(task_0_sub_0_valid, TRUE) #always valid
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE, FALSE), 1, prob = c(.95, .05))) #95% valid, 5% invalid
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE, FALSE), 1, prob = c(.90, .10))) #90% valid, 10% invalid
  task_0_time <<- c(task_0_time, rnorm(1, mean = lower_bound_task_0_time*python_time_factor, sd = 10)) #

  task_1_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.8, .2)) # task 1 80% valid, 20% invalid
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean = lower_bound_task_1_time, sd = 90))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean = lower_bound_task_1_complexity*python_time_factor, sd = 2))) #tbd
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.95, .05))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean = lower_bound_task_2_time*python_time_factor, sd = 50))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.94, .06))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_3_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean = lower_bound_task_3_time*python_time_factor, sd = 40))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }

  suggestions_were_useful <<- c(suggestions_were_useful, suggestions_were_useful_c_e_generator@r(1))
  understand_written_code <<- c(understand_written_code, understand_written_code_c_e_generator@r(1))
  repetitive_tasks_were_tedious <<- c(repetitive_tasks_were_tedious, repetitive_tasks_were_tedious_c_e_generator@r(1))
  feel_comfortable_working_with_library <<- c(feel_comfortable_working_with_library, feel_comfortable_working_with_library_c_e_generator@r(1))
}

data_point_copilot_beginner <- function(participant) {
  python_time_factor =  get_skill_bonus_factor(participant)
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, TRUE)
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE, FALSE), 1, prob = c(.93, .07)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE, FALSE), 1, prob = c(.89, .11)))
  task_0_time <<- c(task_0_time, rnorm(1, mean = (lower_bound_task_0_time + 5)*python_time_factor, sd = 12))

  task_1_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.72, .28))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean = (lower_bound_task_1_time * 1.15)*python_time_factor, sd = 80))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean = (lower_bound_task_1_complexity + 1)*python_time_factor, sd = 5)))
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.91, .09))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean = (lower_bound_task_2_time + 100)*python_time_factor, sd = 60))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.93, .07))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean = lower_bound_task_3_time + 50, sd = 40))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }

  suggestions_were_useful <<- c(suggestions_were_useful, suggestions_were_useful_c_b_generator@r(1))
  understand_written_code <<- c(understand_written_code, understand_written_code_c_b_generator@r(1))
  repetitive_tasks_were_tedious <<- c(repetitive_tasks_were_tedious, repetitive_tasks_were_tedious_c_b_generator@r(1))
  feel_comfortable_working_with_library <<- c(feel_comfortable_working_with_library, feel_comfortable_working_with_library_c_b_generator@r(1))
}

data_point_no_copilot_experienced <- function(participant) {
  python_time_factor =  get_skill_bonus_factor(participant)
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, sample(c(TRUE, FALSE), 1, prob = c(.96, .04)))
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE, FALSE), 1, prob = c(.93, .07)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE, FALSE), 1, prob = c(.93, .07)))
  task_0_time <<- c(task_0_time, rnorm(1, mean = (lower_bound_task_0_time * 1.1)*python_time_factor, sd = 20))

  task_1_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.7, .3))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean = lower_bound_task_1_time * 1.4, sd = 56))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean = lower_bound_task_1_complexity, sd = 3)))
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.94, .06))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean = lower_bound_task_2_time, sd = 40))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.95, .05))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean = lower_bound_task_3_time * 1.4, sd = 42))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }

  suggestions_were_useful <<- c(suggestions_were_useful, suggestions_were_useful_nc_e_generator@r(1))
  understand_written_code <<- c(understand_written_code, understand_written_code_nc_e_generator@r(1))
  repetitive_tasks_were_tedious <<- c(repetitive_tasks_were_tedious, repetitive_tasks_were_tedious_nc_e_generator@r(1))
  feel_comfortable_working_with_library <<- c(feel_comfortable_working_with_library, feel_comfortable_working_with_library_nc_e_generator@r(1))
}

data_point_no_copilot_beginner <- function(participant) {
  python_time_factor =  get_skill_bonus_factor(participant)
  task_0_sub_0_valid <<- c(task_0_sub_0_valid, sample(c(TRUE, FALSE), 1, prob = c(.94, .06)))
  task_0_sub_1_valid <<- c(task_0_sub_1_valid, sample(c(TRUE, FALSE), 1, prob = c(.92, .08)))
  task_0_sub_2_valid <<- c(task_0_sub_2_valid, sample(c(TRUE, FALSE), 1, prob = c(.90, .10)))
  task_0_time <<- c(task_0_time, rnorm(1, mean = (lower_bound_task_0_time * 1.6)*python_time_factor, sd = 17))

  task_1_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.65, .35))
  task_1_valid <<- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <<- c(task_1_time, rnorm(1, mean = lower_bound_task_1_time * 1.2, sd = 95))
    task_1_complexity <<- c(task_1_complexity, floor(rnorm(1, mean = lower_bound_task_1_complexity+5, sd = 4)))
  } else {
    task_1_time <<- c(task_1_time, NaN)
    task_1_complexity <<- c(task_1_complexity, NaN)
  }

  task_2_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.91, .09))
  task_2_valid <<- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <<- c(task_2_time, rnorm(1, mean = lower_bound_task_2_time, sd = 50))
  } else {
    task_2_time <<- c(task_2_time, NaN)
  }

  task_3_valid_ <- sample(c(TRUE, FALSE), 1, prob = c(.95, .05))
  task_3_valid <<- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <<- c(task_3_time, rnorm(1, mean = lower_bound_task_3_time * 1.5, sd = 44))
  } else {
    task_3_time <<- c(task_3_time, NaN)
  }

  suggestions_were_useful <<- c(suggestions_were_useful, suggestions_were_useful_nc_b_generator@r(1))
  understand_written_code <<- c(understand_written_code, understand_written_code_nc_b_generator@r(1))
  repetitive_tasks_were_tedious <<- c(repetitive_tasks_were_tedious, repetitive_tasks_were_tedious_nc_b_generator@r(1))
  feel_comfortable_working_with_library <<- c(feel_comfortable_working_with_library, feel_comfortable_working_with_library_nc_b_generator@r(1))
}



#structuring for easier debugging
for (i in 1:count_total_participants) {
  participants <- c(participants, new("Participant",
                                     skill = experience_in_years[i],
                                     python_skill = experience_in_python[i],
                                     counts_as_experienced = counts_as_experienced[i],
                                     used_copilot = used_copilot[i]))
}


for (participant in participants) {
  if (participant@used_copilot) {
    if (participant@counts_as_experienced) {
      data_point_copilot_experienced(participant)
    }
    else {
      data_point_copilot_beginner(participant)
    }
  }
  else {
    if (participant@counts_as_experienced) {
      data_point_no_copilot_experienced(participant)
    }
    else {
      data_point_no_copilot_beginner(participant)
    }
  }
}

suggestions_were_useful <- round(suggestions_were_useful)
understand_written_code <- round(understand_written_code)
repetitive_tasks_were_tedious <- round(repetitive_tasks_were_tedious)
feel_comfortable_working_with_library <- round(feel_comfortable_working_with_library)


data_frame = data.frame(
  experience_in_years,
  experience_in_python,
  counts_as_experienced,
  used_copilot,

  suggestions_were_useful,
  understand_written_code,
  repetitive_tasks_were_tedious,
  feel_comfortable_working_with_library,

  used_ai_coding_aids,
  tried_github_copilot,

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
write.csv(data_frame, "data.csv")

