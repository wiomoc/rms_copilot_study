import pandas
import os
import matplotlib.pyplot as plt
import numpy as np


def bins_labels(bins, **kwargs):
    bin_w = (max(bins) - min(bins)) / (len(bins) - 1)
    plt.xticks(np.arange(min(bins)+bin_w/2, max(bins), bin_w), bins, **kwargs)
    plt.xlim(bins[0], bins[-1])


def plot_overview():
    # read output_data.csv and plot distribution of all columns
    # columns: participant,skill_level,used_copilot,task_0_sub_0_valid,task_0_sub_1_valid,task_0_sub_2_valid,task_0_time,task_1_valid,task_1_time,task_1_complexity,task_2_valid,task_2_time,task_3_valid,task_3_time,experience_in_years,experience_in_python,tried_github_copilot,used_ai_coding_aids,suggestions_were_useful,understand_written_code,repetitive_tasks_were_not_tedious,feel_comfortable_working_with_library

    df = pandas.read_csv("output_data.csv")
    df.plot(kind='box', subplots=True, layout=(4, 4),
            sharex=False, sharey=False, ylim=(0))
    pandas.set_option('display.max_columns', None)
    pandas.set_option('display.max_rows', None)
    pandas.set_option('display.width', None)
    pandas.set_option('display.max_colwidth', -1)

    plt.show()


def plot_graphs():

    df = pandas.read_csv("output_data.csv")
    grouped = df.groupby('used_copilot')
    used_copilot_df = grouped.get_group(True)
    not_used_copilot_df = grouped.get_group(False)

    plot_dataframe(used_copilot_df, 'copilot')
    plot_dataframe(not_used_copilot_df, 'no_copilot')

    grouped = df.groupby('skill_level')
    experienced = grouped.get_group('adv')
    beginner = grouped.get_group('beg')

    plot_dataframe(experienced, 'experienced')
    plot_dataframe(beginner, 'beginner')


def plot_dataframe(df: pandas.DataFrame, header: str):
    plt.clf()
    os.makedirs('plots', exist_ok=True)
    # save an image of a distribution plot of columns: experience_in_years,experience_in_python,tried_github_copilot,used_ai_coding_aids,suggestions_were_useful,understand_written_code,repetitive_tasks_were_not_tedious,feel_comfortable_working_with_library

    columns = ['experience_in_years', 'experience_in_python']

    for col in columns:
        df[col].plot(kind='box', title=header + '_' + col, ylim=(0, 15))
        plt.savefig(os.path.join(".", "plots", header + '_' + col + '.png'))
        plt.clf()

    columns = ['suggestions_were_useful', 'understand_written_code',
               'repetitive_tasks_were_not_tedious', 'feel_comfortable_working_with_library']

    for col in columns:
        df[col].plot(kind='box', title=header + '_' + col, ylim=(0, 5))
        plt.savefig(os.path.join(".", "plots", header + '_' + col + '.png'))
        plt.clf()

    columns = ['tried_github_copilot', 'used_ai_coding_aids']
    for col in columns:
        column = df[col]
        axes = column.plot(kind='hist', title=header + "_" +
                           col, bins=max(column)+1, rwidth=0.7)
        ticks = [(patch._x0 + patch._x1)/2 for patch in axes.patches]
        labels = ['No', 'Yes'] if max(column) == 1 else [
            'No', 'Yes', 'Unknown']
        plt.xticks(ticks=ticks, labels=labels)
        plt.savefig(os.path.join(".", "plots", header + '_'+col + '.png'))
        plt.clf()
    pass

    # task_0_sub_0_valid,task_0_sub_1_valid,task_0_sub_2_valid,task_0_time,task_1_valid,task_1_time,task_1_complexity,task_2_valid,task_2_time,task_3_valid,task_3_time

    columns = ['task_0_time', 'task_1_time', 'task_1_complexity',
               'task_2_valid', 'task_2_time', 'task_3_valid', 'task_3_time']

    task_0_valid = df.query(
        'task_0_sub_0_valid==True and task_0_sub_1_valid==True and task_0_sub_2_valid==True')
    task_1_valid = df.query('task_1_valid==True')
    task_2_valid = df.query('task_2_valid==True')
    task_3_valid = df.query('task_3_valid==True')

    names = ['Total', 'Task 0 valid', 'Task 1 valid',
             'Task 2 valid', 'Task 3 valid']
    values = [len(df), len(task_0_valid), len(task_1_valid),
              len(task_2_valid), len(task_3_valid)]
    plt.bar(names, values)
    plt.savefig(os.path.join(".", "plots", header +
                '_' + 'valid_tasks' + '.png'))
    plt.clf()

    df[[x for x in columns if x.endswith("_time")]].plot(kind='box', ylim=(0,1100))
    plt.savefig(os.path.join(
        ".", "plots", header + '_' + 'time_took' + '.png'))
    plt.clf()

    df[['task_1_complexity']].plot(kind='box', ylim=(0))
    plt.savefig(os.path.join(".", "plots", header +
                '_' + 'complexity' + '.png'))
    plt.clf()


if __name__ == '__main__':
    plot_graphs()
