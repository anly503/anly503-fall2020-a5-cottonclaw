# library calls to packages
library(palmerpenguins)
library(tidyverse)
library(plotly)
library(htmlwidgets)

# assigning dataset to variable
df <- penguins

# plotly example
p <- ggplot(df, aes(x = bill_length_mm, y = body_mass_g)) + 
  geom_point()
plt <- ggplotly(p)

# saving plot as html
saveWidget(plt, "plotly.html")


