#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from email.iterators import body_line_iterator
from tkinter import END
import pandas as pd
import numpy as np

# Extract the data

country_list = ["Bolivia", "Burundi", "Canada", "Chad", "Indonesia", "Mexico", "Niger", "Philippines", "United States"]
begin_date = 2005
end_date = 2020
nb_dates = end_date - begin_date + 1

attribute_names = ["Adults_And_Children_Living_With_HIV",
                    "Adults_Newly_Infected_With_HIV",
                    "%Births_By_Skilled_Health_Staff",
                    "Capital_Health_Expenditure_%GDP",
                    "DeathByNonCommunicableDiseasePercent",
                    "Domestic_General_Health_Expenditure_%GDP",
                    "Hospital_Beds_Per_1000ppl",
                    "Immunization_HepB3_%OneYearOld",
                    "ImmunizationMeasles%Children12To23Months",
                    "Number_Under-five_Deaths",
                    "Nurses_And_Midwives_Per_1000ppl",
                    "Physicians_Per_1000ppl",
                    "Prevalence_of_Anemia_%Non-pregnant",
                    "Prevalence_of_Anemia_%Pregnant",
                    "Prevalence_of_Overweight_%Adult",
                    "Suicide_Mortality_Rate_per_100000ppl",
                    "Survival_To_Age_65_Female",
                    "Survival_To_Age_65_Male",
                    "Total_Alcohol_Consumption_Per_Capita",
                    "Tuberculosis_Death_Rate_per_100000ppl"
                    ]

nb_attributes = len(attribute_names)

health_data_raw = pd.read_csv("Health_Data_Raw.csv")

health_transposed = health_data_raw.transpose()#flip dataframe

health_dimension = health_transposed.iloc[2,0:nb_attributes].transpose()#create data frame header columns
health_dimension = pd.DataFrame(health_dimension.values.reshape(1,-1))

count = 0
for k in range(len(country_list)):
    transposed_country = health_transposed.iloc[4+begin_date-1960:4+end_date-1960+1, count: count+nb_attributes]
    transposed_country.columns = range(transposed_country.columns.size)
    health_dimension = pd.concat([health_dimension, transposed_country], axis=0, ignore_index=True)
    count += nb_attributes


# add dates
date_table = pd.DataFrame(['Date'])
count = 0
for k in range(len(country_list)):
    date_table = pd.concat([date_table, pd.DataFrame([np.arange(begin_date, end_date+1)]).transpose()], axis=0)
date_table = date_table.reset_index().iloc[: , 1:]

health_dimension = pd.concat([date_table, health_dimension], axis=1, ignore_index=True)

health_dimension = health_dimension.drop(0)


country_table = pd.DataFrame(['Country'])
count = 0
for k in range(len(country_list)):
    country_table = pd.concat([country_table, pd.DataFrame([country_list[k]]*nb_dates)])
country_table = country_table.reset_index().iloc[: , 1:]

health_dimension = pd.concat([country_table, health_dimension], axis=1, ignore_index=True)

health_dimension = health_dimension.drop(0)


health_dimension.columns = ['Country', 'Date'] + attribute_names

health_dimension.insert(0, "Health_Key",  np.arange(len(health_dimension)))


# fill in the missing data
health_dimension.fillna(method="ffill", inplace=True)
health_dimension.fillna(method="bfill", inplace=True)


# Save it into a new csv file
health_dimension.to_csv('Health_dimension.csv', index = False, header=True)
