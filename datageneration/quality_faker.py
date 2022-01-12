import random
import statistics

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.stats as stats

plot_enabled = False

number_of_participants = 0
scale = range(1, 5)
seed = 42


random.seed(seed)
np.random.seed(seed)

# metrics:
#  - experience in year
#  - experience in python 3
#  - Do you have tried GitHub Copilot? y, n
#  - Have you used AI-driven coding aids? y, n, unknown

# Following can be responeded on a scale of 1 to 5  (fully agree - fully disagree)
# - The IDE suggestions were useful.
# - I fully understand my written code.
# - Repetitive tasks weren't tedious to solve.
# - I feel comfortable working with the library from task 3 on my own.
# - How did you like your time with Copilot?


def plot(func):
    def plot_wrapper(*args, **kwargs):

        global plot_enabled
        plot_enabled_old = plot_enabled
        plot_enabled = False

        data = func(*args, **kwargs)

        plot_enabled = plot_enabled_old

        if(plot_enabled):
            plt.hist(data, bins=np.arange(min(data), max(data) + 0.1, 0.1))
            plt.show()
        return data
    return plot_wrapper


def shuffle(func):
    def shuffle_wrapper(*args, **kwargs):
        results = func(*args, **kwargs)
        random.shuffle(results)
        return results
    return shuffle_wrapper


def half_participants(func):
    def half_participants_wrapper(*args, **kwargs):
        global number_of_participants
        number_of_participants_old = number_of_participants
        number_of_participants = int(number_of_participants_old/2)
        results = func(*args, **kwargs)
        number_of_participants = number_of_participants_old
        return results
    return half_participants_wrapper


# ------------------------------------generator functions----------------------------------------------------------------------------------
@shuffle
def createNormalDistributionValues(mean, std, min_value, max_value):
    createSkwedNormalDistributionValues(mean, 0, std, min_value, max_value)


@shuffle
def createSkwedNormalDistributionValues(mean, skew, std, min_value, max_value):
    dist = stats.skewnorm(a=skew, loc=mean, scale=std)
    weights = dist.pdf(range(min_value, max_value+1))
    results = random.choices(
        range(min_value, max_value+1), k=number_of_participants, weights=weights)
    return results


@shuffle
def createBinaryDistributionValues(mean):
    '''
    :param mean: precentage of ones in the result
    '''
    results = []
    for k in range(number_of_participants):
        if random.random() <= mean:
            results.append(1)
        else:
            results.append(0)
    return results


@half_participants
def statistics_for_split_group(mean_nopilot, std_nopilot, mean_pilot, std_pilot, min_value=1, max_value=5):
    pilot = createSkwedNormalDistributionValues(
        mean_pilot, skew=0, std=std_pilot, min_value=min_value, max_value=max_value)
    no_pilot = createSkwedNormalDistributionValues(
        mean_nopilot, skew=0, std=std_nopilot, min_value=min_value, max_value=max_value)
    return no_pilot + pilot

# -------------------------------------collector functions---------------------------------------------------------------------------------


@plot
def experience_in_years():
    return createSkwedNormalDistributionValues(mean=20, skew=0, std=3, min_value=18, max_value=80)


@plot
def experience_in_python_3():
    return createSkwedNormalDistributionValues(mean=2, skew=0, std=2, min_value=0, max_value=10)


@plot
def tried_github_copilot():
    return createBinaryDistributionValues(mean=.15)


@plot
def used_ai_coding_aids():
    results = createBinaryDistributionValues(mean=.20)
    # select option 3 "unknown" for at least a tenth and up to half of the participants
    for i in range(0, random.randint(int(number_of_participants/10), int(number_of_participants/2))):
        results[i] = 2
    return results


@plot
def suggestions_were_useful():
    return statistics_for_split_group(mean_nopilot=3.5, std_nopilot=2.0, mean_pilot=4.5, std_pilot=1.2)


@plot
def understand_written_code():
    return statistics_for_split_group(mean_nopilot=4.5, std_nopilot=1.5, mean_pilot=3.8, std_pilot=1.8, min_value=2)


@plot
def repetitive_tasks_were_not_tedious():
    return statistics_for_split_group(mean_nopilot=2.9, std_nopilot=1.9, mean_pilot=3.8, std_pilot=1.2)


@plot
def feel_comfortable_working_with_library():
    return statistics_for_split_group(mean_nopilot=3.1, std_nopilot=2.4, mean_pilot=2.9, std_pilot=1.8)


def main():
    global plot_enabled
    plot_enabled = False
    
    global number_of_participants
    

    basedata = pd.read_csv('quant_data.csv', index_col=0, header=0, sep=',')  
    basedata.index.name="participant"

    basedata.sort_values(by=["skill_level"], inplace=True)
    skill_counts = basedata["skill_level"].value_counts()
    number_of_participants = skill_counts.adv
    exp_in_years_adv = createSkwedNormalDistributionValues(7,0, 3, 3, 15)
    exp_in_python_adv = createSkwedNormalDistributionValues(5,0, 2, 3, 15)
    
    for i in range(len(exp_in_years_adv)): # remove anomalies
        if(exp_in_years_adv[i] < exp_in_python_adv[i]):
            exp_in_years_adv[i] = exp_in_python_adv[i]

    number_of_participants = skill_counts.beg
    exp_in_years_beg = createSkwedNormalDistributionValues(3,0, 2, 1, 4)
    exp_in_python_beg = createSkwedNormalDistributionValues(1,0, 2, 0, 3)
    
    for i in range(len(exp_in_years_beg)): # remove anomalies
        if(exp_in_years_beg[i] < exp_in_python_beg[i]):
            exp_in_years_beg[i] = exp_in_python_beg[i]
    
    exp_in_years = exp_in_years_adv + exp_in_years_beg
    exp_in_python = exp_in_python_adv + exp_in_python_beg
    
    basedata["experience_in_years"] = exp_in_years
    basedata["experience_in_python"] = exp_in_python
    
    
    number_of_participants = len(basedata)
    data3 = tried_github_copilot()
    data4 = used_ai_coding_aids()
    basedata["tried_github_copilot"] = data3
    basedata["used_ai_coding_aids"] = data4

    basedata.sort_values(by=["used_copilot"], inplace=True)
    data5 = suggestions_were_useful()
    data6 = understand_written_code()
    data7 = repetitive_tasks_were_not_tedious()
    data8 = feel_comfortable_working_with_library()    
    basedata["suggestions_were_useful"] = data5
    basedata["understand_written_code"] = data6
    basedata["repetitive_tasks_were_not_tedious"] = data7
    basedata["feel_comfortable_working_with_library"] = data8
    
    basedata.sort_values(by=["participant"], inplace=True)
    basedata.to_csv('output_data.csv', sep=',',na_rep="N/A")


def output(**data):
    # combine all data object to a pandas dataframe
    df = pd.DataFrame.from_dict(data)
    df.index += 1
    df.index.name="participant"
    # generate a csv file with the data
    df.to_csv('quality_data.csv')
    # generate a txt file with the data
    with open('quality_data.txt', 'w') as f:
        for line in df.to_string(index=False, header=False):
            f.write(line)


# create main
if __name__ == "__main__":
    main()
