copilot.df <- read.csv("output_data.csv", stringsAsFactors = F)


# Average times


task_0.copilot.avg_time <- mean(as.numeric(copilot.df$task_0_time)[copilot.df$used_copilot == "True"], na.rm = T)
task_0.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_0_time)[copilot.df$used_copilot == "False"], na.rm = T)

task_1.copilot.avg_time <- mean(as.numeric(copilot.df$task_1_time)[copilot.df$used_copilot == "True"], na.rm = T)
task_1.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_1_time)[copilot.df$used_copilot == "False"], na.rm = T)

task_2.copilot.avg_time <- mean(as.numeric(copilot.df$task_2_time)[copilot.df$used_copilot == "True"], na.rm = T)
task_2.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_2_time)[copilot.df$used_copilot == "False"], na.rm = T)

task_3.copilot.avg_time <- mean(as.numeric(copilot.df$task_3_time)[copilot.df$used_copilot == "True"], na.rm = T)
task_3.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_3_time)[copilot.df$used_copilot == "False"], na.rm = T)


# Time difference


task_0_timegain <- task_0.copilot.avg_time / task_0.no_copilot.avg_time
task_1_timegain <- task_1.copilot.avg_time / task_1.no_copilot.avg_time
task_2_timegain <- task_2.copilot.avg_time / task_2.no_copilot.avg_time
task_3_timegain <- task_3.copilot.avg_time / task_3.no_copilot.avg_time


# Correctness


task_0_0.copilot.correctness <- length(copilot.df$task_0_sub_0_valid[copilot.df$used_copilot == "True" & copilot.df$task_0_sub_0_valid == "True"])
task_0_0.no_copilot.correctness <- length(copilot.df$task_0_sub_0_valid[copilot.df$used_copilot == "False" & copilot.df$task_0_sub_0_valid == "True"])

task_0_1.copilot.correctness <- length(copilot.df$task_0_sub_1_valid[copilot.df$used_copilot == "True" & copilot.df$task_0_sub_1_valid == "True"])
task_0_1.no_copilot.correctness <- length(copilot.df$task_0_sub_1_valid[copilot.df$used_copilot == "False" & copilot.df$task_0_sub_1_valid == "True"])

task_0_2.copilot.correctness <- length(copilot.df$task_0_sub_2_valid[copilot.df$used_copilot == "True" & copilot.df$task_0_sub_2_valid == "True"])
task_0_2.no_copilot.correctness <- length(copilot.df$task_0_sub_2_valid[copilot.df$used_copilot == "False" & copilot.df$task_0_sub_2_valid == "True"])

task_1.copilot.correctness <- length(copilot.df$task_1_valid[copilot.df$used_copilot == "True" & copilot.df$task_1_valid == "True"])
task_1.no_copilot.correctness <- length(copilot.df$task_1_valid[copilot.df$used_copilot == "False" & copilot.df$task_1_valid == "True"])

task_2.copilot.correctness <- length(copilot.df$task_2_valid[copilot.df$used_copilot == "True" & copilot.df$task_2_valid == "True"])
task_2.no_copilot.correctness <- length(copilot.df$task_2_valid[copilot.df$used_copilot == "False" & copilot.df$task_2_valid == "True"])

task_3.copilot.correctness <- length(copilot.df$task_3_valid[copilot.df$used_copilot == "True" & copilot.df$task_3_valid == "True"])
task_3.no_copilot.correctness <- length(copilot.df$task_3_valid[copilot.df$used_copilot == "False" & copilot.df$task_3_valid == "True"])


# Complexity


task_1.copilot.complexity <- mean(as.numeric(copilot.df$task_1_complexity)[copilot.df$used_copilot == "True"], na.rm = T)
task_1.no_copilot.complexity <- mean(as.numeric(copilot.df$task_1_complexity)[copilot.df$used_copilot == "False"], na.rm = T)


# General

experience.general.avg <- mean(copilot.df$experience_in_years)
experience.python.avg <- mean(copilot.df$experience_in_python)


# Output data


descriptive_output = data.frame(
  task_0.copilot.avg_time,
  task_0.no_copilot.avg_time,

  task_1.copilot.avg_time,
  task_1.no_copilot.avg_time,

  task_2.copilot.avg_time,
  task_2.no_copilot.avg_time,

  task_3.copilot.avg_time,
  task_3.no_copilot.avg_time,

  task_0_timegain,
  task_1_timegain,
  task_2_timegain,
  task_3_timegain,

  task_0_0.copilot.correctness,
  task_0_0.no_copilot.correctness,
  task_0_1.copilot.correctness,
  task_0_1.no_copilot.correctness,
  task_0_2.copilot.correctness,
  task_0_2.no_copilot.correctness,

  task_1.copilot.correctness,
  task_1.no_copilot.correctness,

  task_2.copilot.correctness,
  task_2.no_copilot.correctness,

  task_3.copilot.correctness,
  task_3.no_copilot.correctness,

  task_1.copilot.complexity,
  task_1.no_copilot.complexity,

  experience.general.avg,
  experience.python.avg
)
write.csv(t(descriptive_output), "descriptive_output.csv")


# Plot settings

plot_width=800
plot_height=600
font_size=2
margins=c(5,5,4,1)+.1


# Create directories


dir.create("./plots/quantitative/general/", recursive=T)
dir.create("./plots/quantitative/task0/")
dir.create("./plots/quantitative/task1/")
dir.create("./plots/quantitative/task2/")
dir.create("./plots/quantitative/task3/")
dir.create("./plots/qualitative/")


# Plots (Task 0)


png(file="./plots/quantitative/task0/Task0_Time.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_0_time)~copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task0/Task0_Time_Beginners.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$skill_level == "beg"])~copilot.df$used_copilot[copilot.df$skill_level == "beg"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task0/Task0_Time_Advanced.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$skill_level == "adv"])~copilot.df$used_copilot[copilot.df$skill_level == "adv"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task0/Task0_Time_ByPythonExperience.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$used_copilot == "False"])~copilot.df$experience_in_python[copilot.df$used_copilot == "False"], xlab = "Python experience (years)", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()


# Plots (Task 1)


png(file="./plots/quantitative/task1/Task1_Time.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_1_time)~copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task1/Task1_Time_Beginners.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_1_time[copilot.df$skill_level == "beg"])~copilot.df$used_copilot[copilot.df$skill_level == "beg"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task1/Task1_Time_Advanced.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_1_time[copilot.df$skill_level == "adv"])~copilot.df$used_copilot[copilot.df$skill_level == "adv"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task1/Task1_Complexity.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_1_complexity)~copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Cognitive complexity", cex.axis=font_size, cex.lab=font_size)
dev.off()


# Plots (Task 2)


png(file="./plots/quantitative/task2/Task2_Time.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_2_time)~copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task2/Task2_Time_Beginners.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_2_time[copilot.df$skill_level == "beg"])~copilot.df$used_copilot[copilot.df$skill_level == "beg"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task2/Task2_Time_Advanced.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_2_time[copilot.df$skill_level == "adv"])~copilot.df$used_copilot[copilot.df$skill_level == "adv"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()


# Plots (Task 3)


png(file="./plots/quantitative/task3/Task3_Time.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_3_time)~copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task3/Task3_Time_Beginners.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_3_time[copilot.df$skill_level == "beg"])~copilot.df$used_copilot[copilot.df$skill_level == "beg"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/task3/Task3_Time_Advanced.png", width=plot_width, height=plot_height)
par(mar=margins)
boxplot(as.numeric(copilot.df$task_3_time[copilot.df$skill_level == "adv"])~copilot.df$used_copilot[copilot.df$skill_level == "adv"], xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis=font_size, cex.lab=font_size)
dev.off()


# Plots (Task General)


png(file="./plots/quantitative/general/Experience_General.png", width=plot_width, height=plot_height)
par(mar=margins)
hist(copilot.df$experience_in_years, main=NULL, xlab = "Experience (years)", cex.axis=font_size, cex.lab=font_size)
dev.off()

png(file="./plots/quantitative/general/Experience_Python.png", width=plot_width, height=plot_height)
par(mar=margins)
hist(copilot.df$experience_in_python, main=NULL, xlab = "Experience (years)", cex.axis=font_size, cex.lab=font_size)
dev.off()


# Qualitative results

png(file="./plots/qualitative/Qualitative_UsefulSuggestions.png", width=plot_width, height=plot_height)
counts <- table(copilot.df$used_copilot, copilot.df$suggestions_were_useful)
par(mar=margins)
barplot(counts, names.arg = levels(counts), xlab = "Rating", ylab = "Number of ratings", legend = rownames(counts), beside=TRUE, cex.axis=font_size, cex.lab=font_size, cex.names=font_size)
dev.off()

png(file="./plots/qualitative/Qualitative_UnderstandCode.png", width=plot_width, height=plot_height)
counts <- table(copilot.df$used_copilot, copilot.df$understand_written_code)
par(mar=margins)
barplot(counts, names.arg = levels(counts), xlab = "Rating", ylab = "Number of ratings", legend = rownames(counts), beside=TRUE, cex.axis=font_size, cex.lab=font_size, cex.names=font_size)
dev.off()

png(file="./plots/qualitative/Qualitative_RepetitiveTasks.png", width=plot_width, height=plot_height)
counts <- table(copilot.df$used_copilot, copilot.df$repetitive_tasks_were_not_tedious)
par(mar=margins)
barplot(counts, names.arg = levels(counts), xlab = "Rating", ylab = "Number of ratings", legend = rownames(counts), beside=TRUE, cex.axis=font_size, cex.lab=font_size, cex.names=font_size)
dev.off()

png(file="./plots/qualitative/Qualitative_ComfortableLibrary.png", width=plot_width, height=plot_height)
counts <- table(copilot.df$used_copilot, copilot.df$feel_comfortable_working_with_library)
par(mar=margins)
barplot(counts, names.arg = levels(counts), xlab = "Rating", ylab = "Number of ratings", legend = rownames(counts), beside=TRUE, cex.axis=font_size, cex.lab=font_size, cex.names=font_size)
dev.off()