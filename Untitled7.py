#!/usr/bin/env python
# coding: utf-8

# In[3]:


import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_excel('/Users/kazinafis/Downloads/pr24008a.xlsx')

df['date'] = pd.to_datetime(df['year'].astype(str) + '-' + ((df['quarter'] - 1) * 3 + 1).astype(str) + '-01')

# Plotting unemployment rate over time
plt.figure(figsize=(10, 6))
plt.plot(df['date'], df['us_ur'], label='Unemployment Rate')
plt.title('Unemployment Rate Over Time')
plt.xlabel('Year')
plt.ylabel('Unemployment Rate (%)')
plt.legend()
plt.grid(True)
plt.show()


# In[4]:


from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

X = df[['us_gdp', 'us_inflation']]
y = df['us_ur']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Training the model 
model = LinearRegression()
model.fit(X_train, y_train)

# Predicting and evaluating the model
y_pred = model.predict(X_test)
print(f'Mean Squared Error: {mean_squared_error(y_test, y_pred)}')


# In[5]:


# Filtering data for a specific indicator and scenario for comparison
scenarios = df['scenario'].unique()

plt.figure(figsize=(10, 6))
for scenario in scenarios:
    scenario_data = df[df['scenario'] == scenario]
    plt.plot(scenario_data['date'], scenario_data['us_gdp'], label=f'Scenario {scenario}')

plt.title('GDP Growth by Scenario')
plt.xlabel('Year')
plt.ylabel('GDP Growth (%)')
plt.legend()
plt.show()


# In[6]:


correlations = df[['us_gdp', 'us_inflation', 'us_ur', 'us_hpi', 'us_cre']].corr()
print(correlations['us_cre'])


# In[9]:


x_range = np.linspace(X_train['us_gdp'].min(), X_train['us_gdp'].max(), 100)
us_inflation_mean = X_train['us_inflation'].mean()

x_range_1d = x_range.flatten()

us_inflation_array = np.full(shape=x_range_1d.shape, fill_value=us_inflation_mean)


X_pred = pd.DataFrame({
    'us_gdp': x_range_1d,
    'us_inflation': us_inflation_array
})


y_pred = model.predict(X_pred)

plt.figure(figsize=(10, 6))
plt.scatter(X_train['us_gdp'], y_train, color='blue', label='Training data')
plt.plot(x_range_1d, y_pred, color='red', label='Regression Line')
plt.xlabel('US GDP Growth Rate (%)')
plt.ylabel('Predicted Unemployment Rate (%)')
plt.title('Linear Regression Model Visualization')
plt.legend()
plt.show()


# In[10]:


import matplotlib.pyplot as plt

# Correlation values
correlation_values = {
    'us_gdp': -0.182362,
    'us_inflation': -0.306545,
    'us_ur': -0.376096,
    'us_hpi': 0.977619,
    'us_cre': 1.000000,
}

del correlation_values['us_cre']

variables = list(correlation_values.keys())
correlations = list(correlation_values.values())


plt.figure(figsize=(10, 6))
bars = plt.bar(variables, correlations, color=['blue' if x < 0 else 'green' for x in correlations])
plt.title('Correlation with US Commercial Real Estate Index (us_cre)')
plt.xlabel('Economic Indicator')
plt.ylabel('Correlation Coefficient')
plt.axhline(0, color='black', linewidth=0.8)  # Adds a horizontal line at zero

for bar in bars:
    yval = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2, yval, round(yval,2), ha='center', va='bottom')

plt.show()


# In[ ]:




