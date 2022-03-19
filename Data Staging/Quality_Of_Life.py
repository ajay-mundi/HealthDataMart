#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np

# Extract the data

country_list = ["Bolivia", "Burundi", "Canada", "Chad", "Indonesia", "Mexico", "Niger", "Philippines", "United States"]
begin_date = 2005
end_date = 2020
nb_dates = end_date - begin_date + 1

attribute_names = ["Maternal_Leave_Benefits",
                    "Access_To_Basic_Drinking_Water_Total",
                    "Access_To_Basic_Drinking_Water_Urban",
                    "Access_To_Basic_Sanitation_Total",
                    "Access_To_Basic_Sanitation_Urban",
                    "Access_To_Managed_Drinking_Water_Total",
                    "Access_To_Managed_Sanitation_Total",
                    "Access_To_Basic_Handwashing_Facilities_Total",
                    "Access_To_Basic_Handwashing_Facilities_Urban",
                    "Unemployment_Female",
                    "Unemployment_Male",
                    "Unemployment_Total"
                    ]

nb_attributes = len(attribute_names)

QOL_data_raw = pd.read_csv("QOL_data_raw.csv")

QOL_transposed = QOL_data_raw.transpose()#flip dataframe

QOL_dimension = QOL_transposed.iloc[2,0:nb_attributes].transpose()#create data frame header columns
QOL_dimension = pd.DataFrame(QOL_dimension.values.reshape(1,-1))

count = 0
for k in range(len(country_list)):
    transposed_country = QOL_transposed.iloc[4+begin_date-1960:4+end_date-1960+1, count: count+nb_attributes]
    transposed_country.columns = range(transposed_country.columns.size)
    QOL_dimension = pd.concat([QOL_dimension, transposed_country], axis=0, ignore_index=True)
    count += nb_attributes


# add dates
date_table = pd.DataFrame(['Date'])
count = 0
for k in range(len(country_list)):
    date_table = pd.concat([date_table, pd.DataFrame([np.arange(begin_date, end_date+1)]).transpose()], axis=0)
date_table = date_table.reset_index().iloc[: , 1:]

QOL_dimension = pd.concat([date_table, QOL_dimension], axis=1, ignore_index=True)

QOL_dimension = QOL_dimension.drop(0)


country_table = pd.DataFrame(['Country'])
count = 0
for k in range(len(country_list)):
    country_table = pd.concat([country_table, pd.DataFrame([country_list[k]]*nb_dates)])
country_table = country_table.reset_index().iloc[: , 1:]

QOL_dimension = pd.concat([country_table, QOL_dimension], axis=1, ignore_index=True)

QOL_dimension = QOL_dimension.drop(0)


QOL_dimension.columns = ['Country', 'Date'] + attribute_names

QOL_dimension.insert(0, "QOL_Key",  np.arange(len(QOL_dimension)))


# Save it into a new csv file
QOL_dimension.to_csv('QOL_dimension.csv', index = False, header=True)
