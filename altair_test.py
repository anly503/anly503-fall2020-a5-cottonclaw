# imports
import altair as alt
import seaborn as sns

# loading dataset
mpg = sns.load_dataset("mpg")

# altair example
plt = (
    alt.Chart(mpg)
    .mark_point()
    .encode(x = 'horsepower', 
            y = 'mpg', 
            color = 'origin',
            tooltip = ['name', 'origin', 'horsepower', 'mpg'])
    .interactive()
)

# saving plot as html
plt.save('altair.html')

