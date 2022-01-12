count_total_participants = 40
count_copilot_participants = count_total_participants / 2
count_copilot_advanced_participants = floor( count_copilot_participants / 2.5)
count_copilot_beginner_participants = count_copilot_participants - count_copilot_advanced_participants

count_normal_participants = count_total_participants - count_copilot_participants
count_normal_advanced_participants = floor(count_normal_participants / 1.6)
count_normal_beginner_participants = count_normal_participants - count_normal_advanced_participants


skill_level <- c()
used_copilot <- c()
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


for (i in 1:count_copilot_advanced_participants) {
  skill_level <- c(skill_level, "adv")
  used_copilot <- c(used_copilot, TRUE)
  task_0_sub_0_valid <- c(task_0_sub_0_valid, TRUE)
  task_0_sub_1_valid <- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1, prob=c(.95,.05)))
  task_0_sub_2_valid <- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.90,.10)))
  task_0_time <- c(task_0_time, rnorm(1, mean=71, sd=12))
  
  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.8, .2))
  task_1_valid <- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <- c(task_1_time, rnorm(1, mean=610, sd=90))
    task_1_complexity <- c(task_1_complexity, floor(rnorm(1, mean=71, sd=12))) #tbd
  } else {
    task_1_time <- c(task_1_time, NaN)
    task_1_complexity <- c(task_1_complexity, NaN)
  }
  
  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_2_valid <- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <- c(task_2_time, rnorm(1, mean=590, sd=50))
  } else {
    task_2_time <- c(task_2_time, NaN)
  }
  
  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.94, .06))
  task_3_valid <- c(task_3_valid, task_3_valid_)
  if (task_3_valid_) {
    task_3_time <- c(task_3_time, rnorm(1, mean=310, sd=40))
  } else {
    task_3_time <- c(task_3_time, NaN)
  }
}

for (i in 1:count_copilot_beginner_participants) {
  skill_level <- c(skill_level, "beg")
  used_copilot <- c(used_copilot, TRUE)
  task_0_sub_0_valid <- c(task_0_sub_0_valid, TRUE)
  task_0_sub_1_valid <- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1,prob=c(.93,.07)))
  task_0_sub_2_valid <- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.89,.11)))
  task_0_time <- c(task_0_time, rnorm(1, mean=82, sd=15))
  
  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.72, .28))
  task_1_valid <- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <- c(task_1_time, rnorm(1, mean=700, sd=80))
    task_1_complexity <- c(task_1_complexity, floor(rnorm(1, mean=71, sd=12))) #tbd
  } else {
    task_1_time <- c(task_1_time, NaN)
    task_1_complexity <- c(task_1_complexity, NaN)
  }
  
  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.91, .09))
  task_2_valid <- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <- c(task_2_time, rnorm(1, mean=620, sd=60))
  } else {
    task_2_time <- c(task_2_time, NaN)
  }
  
  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.93, .07))
  task_3_valid <- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <- c(task_3_time, rnorm(1, mean=320, sd=40))
  } else {
    task_3_time <- c(task_3_time, NaN)
  }
}


for (i in 1:count_normal_advanced_participants) {
  skill_level <- c(skill_level, "adv")
  used_copilot <- c(used_copilot, FALSE)
  task_0_sub_0_valid <- c(task_0_sub_0_valid, sample(c(TRUE,FALSE), 1, prob=c(.96,.04)))
  task_0_sub_1_valid <- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1, prob=c(.93,.07)))
  task_0_sub_2_valid <- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.93,.07)))
  task_0_time <- c(task_0_time, rnorm(1, mean=124, sd=20))
  
  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.7, .3))
  task_1_valid <- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <- c(task_1_time, rnorm(1, mean=790, sd=56))
    task_1_complexity <- c(task_1_complexity, floor(rnorm(1, mean=71, sd=12))) #tbd
  } else {
    task_1_time <- c(task_1_time, NaN)
    task_1_complexity <- c(task_1_complexity, NaN)
  }
  
  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.94, .06))
  task_2_valid <- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <- c(task_2_time, rnorm(1, mean=597, sd=40))
  } else {
    task_2_time <- c(task_2_time, NaN)
  }
  
  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_3_valid <- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <- c(task_3_time, rnorm(1, mean=420, sd=42))
  } else {
    task_3_time <- c(task_3_time, NaN)
  }
}

for (i in 1:count_normal_beginner_participants) {
  skill_level <- c(skill_level, "beg")
  used_copilot <- c(used_copilot, FALSE)
  task_0_sub_0_valid <- c(task_0_sub_0_valid, sample(c(TRUE,FALSE), 1, prob=c(.94,.06)))
  task_0_sub_1_valid <- c(task_0_sub_1_valid, sample(c(TRUE,FALSE), 1,prob=c(.92,.08)))
  task_0_sub_2_valid <- c(task_0_sub_2_valid, sample(c(TRUE,FALSE), 1, prob=c(.90,.10)))
  task_0_time <- c(task_0_time, rnorm(1, mean=133, sd=17))
  
  task_1_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.65, .35))
  task_1_valid <- c(task_1_valid, task_1_valid_)
  if (task_1_valid_) {
    task_1_time <- c(task_1_time, rnorm(1, mean=821, sd=95))
    task_1_complexity <- c(task_1_complexity, floor(rnorm(1, mean=71, sd=12))) #tbd
  } else {
    task_1_time <- c(task_1_time, NaN)
    task_1_complexity <- c(task_1_complexity, NaN)
  }
  
  task_2_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.91, .09))
  task_2_valid <- c(task_2_valid, task_2_valid_)
  if (task_2_valid_) {
    task_2_time <- c(task_2_time, rnorm(1, mean=510, sd=50))
  } else {
    task_2_time <- c(task_2_time, NaN)
  }
  
  task_3_valid_ <- sample(c(TRUE,FALSE), 1, prob=c(.95, .05))
  task_3_valid <- c(task_3_valid, task_3_valid_)
  if (task_2_valid_) {
    task_3_time <- c(task_3_time, rnorm(1, mean=444, sd=44))
  } else {
    task_3_time <- c(task_3_time, NaN)
  }
}

data_frame = data.frame(
  skill_level,
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

