import pandas as pd
import numpy as np

def get_date_week_duration(df,pickup, dropoff) : 
    df['pickup'] = pd.to_datetime(df['pickup'])
    df['dropoff'] = pd.to_datetime(df['dropoff'])
    df['date'] = pd.to_datetime(df[pickup])
    df['year'] = df['date'].dt.year
    df['month'] = df['date'].dt.month
    df['day'] = df['date'].dt.day
    df['hour'] = df['date'].dt.hour
    df['week_day'] = df['date'].apply(lambda x: x.strftime('%A'))
    df['duration'] = ((df['dropoff'] - df['pickup']).dt.total_seconds() / 60).round(2)
    df = df[df['total'] > 0]
    df = df[df['distance'] > 0]
    df['date']= df['date'].dt.date
    return df


def df_to_celsius_and_num_values (df):
    def fahrenheit_to_celsius(x):
        x = (x-32)*(5/9)
        return x
    df["date"] =  pd.to_datetime(df["date"], format='%d/%m/%y')
    df["tmax_c"] = df["tmax"].apply(lambda x: fahrenheit_to_celsius(x)).round(2)
    df["tmin_c"] = df["tmin"].apply(lambda x: fahrenheit_to_celsius(x)).round(2)
    df["tavg_c"] = df["tavg"].apply(lambda x: fahrenheit_to_celsius(x)).round(2)
    df["departure_c"] = df["departure"].apply(lambda x: fahrenheit_to_celsius(x)).round(2)
    df["precipitation"].replace(to_replace="T", value=0.01, inplace = True)
    df["new_snow"].replace(to_replace="T", value=0.01, inplace = True)
    df["snow_depth"].replace(to_replace="T", value=0.01, inplace = True)
    return df