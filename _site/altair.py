# imports
import pandas as pd
import altair as alt

# reading in the data set
df = pd.read_csv('altair-data.csv')

# building the plot
plt = (
    alt.Chart(df)
    .mark_area()
    .encode(x=alt.X('Day', sort=['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                    axis={'labelAngle': 0.0, 'labelFont': 'Courier New', 'titleFont': 'Courier New'}, 
                    title='Day of Week'),
            y=alt.Y('Power(watts):Q', axis={'labelFont': 'Courier New', 'titleFont': 'Courier New'}, 
                    title='Average Power [Watts]'), 
            color=alt.Color('Appliance:N', scale=alt.Scale(scheme='tableau20')),
            tooltip=['Day', 'Power(watts)', 'Appliance'])
    .properties(width=500, title={'text': ['Daily Electric Consumption for Various Household Appliances'],
                                  'subtitle': ['Source: ECO Dataset (Retrieved from: http://www.vs.inf.ethz.ch/)']})
    .configure_title(font='Courier New')
    .configure_legend(labelFont='Courier New', titleFont='Courier New')
    .interactive()
)

# saving the plot
plt.save('altair.html')

