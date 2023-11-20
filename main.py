import pandas as pd
from src import cleaning as cl

#improting datasets
taxi = pd.read_csv("starting data/taxi.csv")
weather = pd.read_csv("starting data/nyc_temperature.csv")

#cleaning and transforming datasets
taxi = cl.get_date_week_duration(taxi,'pickup', 'dropoff')
weather = cl.df_to_celsius_and_num_values (weather)

#exporting datasets to be used in MySQL and Tableu
taxi.to_csv('data/taxi.csv')
weather.to_csv('data/weather.csv')