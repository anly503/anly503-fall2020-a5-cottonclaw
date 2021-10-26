# imports
import pandas as pd
import plotly.express as px

# reading in the data set
df = pd.read_csv('plotly-data.csv')

# splitting the text for the source info into variables
source1 = ' <br><sup>Source: Wilhelm Kleiminger, Christian Beckel, Silvia Santini. '
source2 = 'Household Occupancy Monitoring Using Electricity Meters. <br>'
source3 = 'Proceedings of the 2015 ACM International Joint Conference on Pervasive and Ubiquitous Computing'
source4 = ' (UbiComp 2015). Osaka, Japan, September 2015.</sup>'
source  = source1 + source2 + source3 + source4

# building the plot
plt = (
    px.bar(df, x='Plug', y='Power', animation_frame='Hour', animation_group='Plug', color='Plug', 
           color_discrete_sequence=['#007fff', '#309ccf', '#30cccf', '#28df8b', 
                                    '#21de49', '#cbe51a', '#ffb700', '#ff8000'], range_y=[0, 80],
           labels=dict(Hour='Time of Day (24-Hour)', Power='Average Power [Watts]', Plug='Appliance'),
           title='Hourly Electric Consumption for Various Household Appliances' + source)
    .update_traces(
        customdata=df, 
        hovertemplate='Appliance: %{x}<br>Time of Day (24-Hour): %{customdata[1]}<br>Average Power [Watts]: %{y}')
    .update_layout(font_family='Courier New', font_color='black', font=dict(size=10))
    .update_xaxes(tickangle=0.0)
)


# writing the plot as an html file
plt.write_html('plotly.html')

