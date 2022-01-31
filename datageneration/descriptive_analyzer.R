#!/usr/bin/env Rscript

copilot.df <- read.csv("data.csv", stringsAsFactors = F)

plot_color<- "grey"

# Average times


task_0.copilot.avg_time <- mean(as.numeric(copilot.df$task_0_time[copilot.df$used_copilot == TRUE]), na.rm = T)
task_0.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_0_time)[copilot.df$used_copilot == FALSE], na.rm = T)

task_1.copilot.avg_time <- mean(as.numeric(copilot.df$task_1_time)[copilot.df$used_copilot == TRUE], na.rm = T)
task_1.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_1_time)[copilot.df$used_copilot == FALSE], na.rm = T)

task_2.copilot.avg_time <- mean(as.numeric(copilot.df$task_2_time)[copilot.df$used_copilot == TRUE], na.rm = T)
task_2.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_2_time)[copilot.df$used_copilot == FALSE], na.rm = T)

task_3.copilot.avg_time <- mean(as.numeric(copilot.df$task_3_time)[copilot.df$used_copilot == TRUE], na.rm = T)
task_3.no_copilot.avg_time <- mean(as.numeric(copilot.df$task_3_time)[copilot.df$used_copilot == FALSE], na.rm = T)


# Time difference


task_0_timegain <- task_0.copilot.avg_time / task_0.no_copilot.avg_time
task_1_timegain <- task_1.copilot.avg_time / task_1.no_copilot.avg_time
task_2_timegain <- task_2.copilot.avg_time / task_2.no_copilot.avg_time
task_3_timegain <- task_3.copilot.avg_time / task_3.no_copilot.avg_time


# Correctness


task_0_0.copilot.correctness <- length(copilot.df$task_0_sub_0_valid[copilot.df$used_copilot == TRUE & copilot.df$task_0_sub_0_valid == TRUE])
task_0_0.no_copilot.correctness <- length(copilot.df$task_0_sub_0_valid[copilot.df$used_copilot == FALSE & copilot.df$task_0_sub_0_valid == TRUE])

task_0_1.copilot.correctness <- length(copilot.df$task_0_sub_1_valid[copilot.df$used_copilot == TRUE & copilot.df$task_0_sub_1_valid == TRUE])
task_0_1.no_copilot.correctness <- length(copilot.df$task_0_sub_1_valid[copilot.df$used_copilot == FALSE & copilot.df$task_0_sub_1_valid == TRUE])

task_0_2.copilot.correctness <- length(copilot.df$task_0_sub_2_valid[copilot.df$used_copilot == TRUE & copilot.df$task_0_sub_2_valid == TRUE])
task_0_2.no_copilot.correctness <- length(copilot.df$task_0_sub_2_valid[copilot.df$used_copilot == FALSE & copilot.df$task_0_sub_2_valid == TRUE])

task_1.copilot.correctness <- length(copilot.df$task_1_valid[copilot.df$used_copilot == TRUE & copilot.df$task_1_valid == TRUE])
task_1.no_copilot.correctness <- length(copilot.df$task_1_valid[copilot.df$used_copilot == FALSE & copilot.df$task_1_valid == TRUE])

task_2.copilot.correctness <- length(copilot.df$task_2_valid[copilot.df$used_copilot == TRUE & copilot.df$task_2_valid == TRUE])
task_2.no_copilot.correctness <- length(copilot.df$task_2_valid[copilot.df$used_copilot == FALSE & copilot.df$task_2_valid == TRUE])

task_3.copilot.correctness <- length(copilot.df$task_3_valid[copilot.df$used_copilot == TRUE & copilot.df$task_3_valid == TRUE])
task_3.no_copilot.correctness <- length(copilot.df$task_3_valid[copilot.df$used_copilot == FALSE & copilot.df$task_3_valid == TRUE])


# Complexity


task_1.copilot.complexity <- mean(as.numeric(copilot.df$task_1_complexity)[copilot.df$used_copilot == TRUE], na.rm = T)
task_1.no_copilot.complexity <- mean(as.numeric(copilot.df$task_1_complexity)[copilot.df$used_copilot == FALSE], na.rm = T)


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

plot_width = 800
plot_height = 600
font_size = 2
margins = c(5, 5, 4, 1) + .1


# Create directories


dir.create("./plots/quantitative/general/", recursive = T)
dir.create("./plots/quantitative/task0/")
dir.create("./plots/quantitative/task1/")
dir.create("./plots/quantitative/task2/")
dir.create("./plots/quantitative/task3/")
dir.create("./plots/qualitative/")


# Plots (Task 0)

max_time <- max(copilot.df$task_0_time,na.rm = TRUE)*1.1

png(file = "./plots/quantitative/task0/Task0_Time.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_0_time) ~ copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, col=plot_color, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task0/Task0_Time_Beginners.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$counts_as_experienced == FALSE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == FALSE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task0/Task0_Time_Advanced.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$counts_as_experienced == TRUE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == TRUE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task0/Task0_Time_ByPythonExperience.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_0_time[copilot.df$used_copilot == FALSE]) ~ copilot.df$experience_in_python[copilot.df$used_copilot == FALSE], col=plot_color, xlab = "Python experience (years)", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()


# Plots (Task 1)

max_time <- max(copilot.df$task_1_time,na.rm = TRUE)*1.1


png(file = "./plots/quantitative/task1/Task1_Time.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_1_time) ~ copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, col=plot_color, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task1/Task1_Time_Beginners.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_1_time[copilot.df$counts_as_experienced == FALSE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == FALSE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task1/Task1_Time_Advanced.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_1_time[copilot.df$counts_as_experienced == TRUE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == TRUE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task1/Task1_Complexity.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_1_complexity) ~ copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Cognitive complexity", cex.axis = font_size, col=plot_color, cex.lab = font_size, ylim=c(0,max(copilot.df$task_1_complexity,na.rm = TRUE)))
dev.off()


# Plots (Task 2)

max_time <- max(copilot.df$task_2_time,na.rm = TRUE)*1.1

png(file = "./plots/quantitative/task2/Task2_Time.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_2_time) ~ copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, col=plot_color, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task2/Task2_Time_Beginners.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_2_time[copilot.df$counts_as_experienced == FALSE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == FALSE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task2/Task2_Time_Advanced.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_2_time[copilot.df$counts_as_experienced == TRUE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == TRUE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()


# Plots (Task 3)

max_time <- max(copilot.df$task_3_time,na.rm = TRUE)*1.1

png(file = "./plots/quantitative/task3/Task3_Time.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_3_time) ~ copilot.df$used_copilot, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, col=plot_color, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task3/Task3_Time_Beginners.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_3_time[copilot.df$counts_as_experienced == FALSE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == FALSE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()

png(file = "./plots/quantitative/task3/Task3_Time_Advanced.png", width = plot_width, height = plot_height)
par(mar = margins)
boxplot(as.numeric(copilot.df$task_3_time[copilot.df$counts_as_experienced == TRUE]) ~ copilot.df$used_copilot[copilot.df$counts_as_experienced == TRUE], col=plot_color, xlab = "Used Copilot", ylab = "Completion time (s)", cex.axis = font_size, cex.lab = font_size, ylim=c(0,max_time), yaxs="i")
dev.off()



# Plots (Task General)

png(file = "./plots/quantitative/general/Experience_General.png", width = plot_width, height = plot_height)
par(mar = margins)
foo <- hist(copilot.df$experience_in_years, main = NULL, xlab = "Experience (years)", col=plot_color, xaxt='n', breaks= max(copilot.df$experience_in_years), yaxs="i")
axis(side=1, at=foo$mids, labels=1:length(foo$mids), cex.axis = font_size, cex.lab = font_size)
dev.off()

png(file = "./plots/quantitative/general/Experience_Python.png", width = plot_width, height = plot_height)
par(mar = margins)
foo2 <- hist(copilot.df$experience_in_python, main = NULL, xlab = "Experience (years)", col=plot_color, xaxt='n', breaks= max(copilot.df$experience_in_python), yaxs="i")
axis(side=1, at=foo2$mids, labels=1:length(foo2$mids), cex.axis = font_size, cex.lab = font_size)
dev.off()


get_counts <- function(df) {
  count1 <- tabulate(df[copilot.df$used_copilot == TRUE], nbins = 5)
  count2 <- tabulate(df[copilot.df$used_copilot == FALSE], nbins = 5)
  mat <- rbind(count1, count2)
  colnames(mat) <- c(1:5)
  rownames(mat) <- c("TRUE", "FALSE")
  return(mat)
}

# Qualitative results

max_answer_count= max(get_counts(copilot.df$suggestions_were_useful),
                      get_counts(copilot.df$understand_written_code),
                      get_counts(copilot.df$repetitive_tasks_were_tedious),
                      get_counts(copilot.df$feel_comfortable_working_with_library),
                      na.rm = TRUE)

png(file = "./plots/qualitative/Qualitative_UsefulSuggestions.png", width = plot_width, height = plot_height)
par(mar = margins)
barplot(get_counts(copilot.df$suggestions_were_useful),
        xlab = "Rating", ylab = "Number of ratings", legend = c("Without Copilot", "With Copilot"), beside = TRUE, cex.axis = font_size, cex.lab = font_size, cex.names = font_size,ylim=c(0,max_answer_count))
dev.off()

png(file = "./plots/qualitative/Qualitative_UnderstandCode.png", width = plot_width, height = plot_height)
par(mar = margins)
barplot(get_counts(copilot.df$understand_written_code),
        xlab = "Rating", ylab = "Number of ratings", legend = c("Without Copilot", "With Copilot"), beside = TRUE, cex.axis = font_size, cex.lab = font_size, cex.names = font_size,ylim=c(0,max_answer_count))
dev.off()

png(file = "./plots/qualitative/Qualitative_RepetitiveTasks.png", width = plot_width, height = plot_height)
par(mar = margins)
barplot(get_counts(copilot.df$repetitive_tasks_were_tedious),
        xlab = "Rating", ylab = "Number of ratings", legend = c("Without Copilot", "With Copilot"), beside = TRUE, cex.axis = font_size, cex.lab = font_size, cex.names = font_size,ylim=c(0,max_answer_count))
dev.off()

png(file = "./plots/qualitative/Qualitative_ComfortableLibrary.png", width = plot_width, height = plot_height)
par(mar = margins)
barplot(get_counts(copilot.df$feel_comfortable_working_with_library),
        xlab = "Rating", ylab = "Number of ratings", legend = c("Without Copilot", "With Copilot"), beside = TRUE, cex.axis = font_size, cex.lab = font_size, cex.names = font_size,ylim=c(0,max_answer_count))
dev.off()