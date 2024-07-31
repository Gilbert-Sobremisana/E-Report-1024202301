require(pacman)
p_load(rio, dplyr, ggplot2,car,extrafont)

#read data
telecom_data = import("C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_22_with_cluster.csv")

region = telecom_data$region
cluster = telecom_data$custclass
age = telecom_data$age
income = telecom_data$income
# Reset plotting parameters
par(mfrow = c(1.5, 1.5)) # Set the plotting area to 1x1 grid
par(mar = c(5, 4, 4, 2) + 0.1) # Set the margins to default values (can be adjusted if needed)


hist(region, col = "lightblue", main = "Region Distribution", xlab = "Region")
hist(cluster, col = "blue", main = "Customer Cluster Distribution", xlab = "Customer Cluster")

plot(income)

# Create the scatter plot
ggplot(telecom_data, aes(x = factor(1), y = income)) +
  geom_jitter(width = 0.5, size = 2, color = "#0073C2FF", alpha = 0.6) +
  theme_minimal(base_family = "Arial") +
  labs(title = "Income Distribution",
       x = "Customer",
       y = "Income (x $1,000)",
       caption = "Source: Telecom Company Data") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.y = element_text(size = 12),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    plot.caption = element_text(size = 10, hjust = 1),
    panel.grid.minor = element_blank()
  )

hist(age)
# Calculate the average income and standard error for each cluster
average_income <- telecom_data %>%
  group_by(custclass) %>%
  summarize(
    avg_income = mean(income, na.rm = TRUE),
    se_income = sd(income, na.rm = TRUE) / sqrt(n())
  (avg_income - se_income))


# Print the result
print(average_income)





# Create the bar plot with error bars
ggplot(average_income, aes(x = factor(custclass), y = avg_income)) +
  geom_bar(stat = "identity", fill = "#0073C2FF", alpha = 0.8) +
  geom_errorbar(aes(ymin = avg_income - se_income, ymax = avg_income + se_income), width = 0.2, color = "black") +
  labs(title = "Average Income by Customer Cluster",
       x = "Customer Cluster",
       y = "Income (x $1,000)",
       caption = "Source: Telecom Company Data") +
  ylim(0, max(average_income$avg_income + average_income$se_income)) + # Adjust the y-axis limits
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12),
    axis.text = element_text(size = 10),
    plot.caption = element_text(size = 10, hjust = 1),
    panel.grid.minor = element_blank()
  )


# Preprocess data for Region Distribution Pie Chart
region_data <- telecom_data %>%
  count(region) %>%
  mutate(prop = n / sum(n))

# Region Distribution Pie Chart
ggplot(region_data, aes(x = "", y = prop, fill = factor(region))) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  labs(title = "Region Distribution",
       x = "",
       y = "",
       fill = "Region",
       caption = "Source: Telecom Company Data") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(size = 10, hjust = 1),
    legend.position = "right"
  ) +
  scale_fill_brewer(palette = "Blues")

# Save the Region Distribution Pie Chart
ggsave("region_distribution_pie_chart.png", width = 6, height = 6)

# Preprocess data for Customer Cluster Distribution Pie Chart
cluster_data <- telecom_data %>%
  count(custclass) %>%
  mutate(prop = n / sum(n))

# Customer Cluster Distribution Pie Chart
ggplot(cluster_data, aes(x = "", y = prop, fill = factor(custclass))) +
  geom_bar(width = 1, stat = "identity", color = "white") +   geom_text(aes(label = paste0(round(prop, 2), "%")),
            position = position_stack(vjust = 0.5),
            size = 5, color = "#262626", family = "Arial") +
  coord_polar("y", start = 0) +
  labs(title = "Customer Cluster Distribution",
       x = "",
       y = "",
       fill = "Customer Cluster",
       caption = "Source: Telecom Company Data") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(size = 10, hjust = 1),
    legend.position = "right"
  ) +
  scale_fill_brewer(palette = "Blues")




#Age
age <- telecom_data$age

# Calculate percentage of customers within the age range 33-38
age_range_count <- sum(age >= 33 & age <= 38)
total_count <- length(age)
percentage <- age_range_count / total_count * 100

# Calculate the density data
density_data <- density(age)
density_df <- data.frame(x = density_data$x, y = density_data$y * total_count)

# Filter density data for the age range 33-38
highlight_df <- density_df %>% filter(x >= 33 & x <= 38)

# Create the density plot with shaded area and scaled y-axis
ggplot() +
  geom_line(data = density_df, aes(x = x, y = y), color = "#0A72D5") +
  geom_area(data = highlight_df, aes(x = x, y = y), fill = "#0A72D5", alpha = 0.6) +
  annotate("text", x = 35.5, y = max(density_df$y) * 0.05,
           label = paste0( round(percentage, 1), "%"),
           color = "#262626", size = 5, family = "Arial", fontface = "bold") +
  theme_minimal(base_size = 15, base_family = "Arial") + # Use minimal theme with increased base font size
  labs(
    title = "Age Distribution of Customers",
    x = "Age",
    y = "Number of Customers",
    caption = "Source: Telecom Company Data"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), # Center and bold the title
    axis.title.x = element_text(margin = margin(t = 10)), # Add margin to x-axis title
    axis.title.y = element_text(margin = margin(r = 10)), # Add margin to y-axis title
    axis.text = element_text(size = 12), # Adjust the size of axis text
    panel.grid.major = element_line(color = "grey80"), # Lighter grid lines for a cleaner look
    panel.grid.minor = element_blank(), # Remove minor grid lines
    plot.caption = element_text(size = 10, hjust = 1), # Caption styling
    legend.position = "none" # Remove legend as it is not necessary here
  ) +
  scale_x_continuous(breaks = seq(min(age), max(age), by = 5)) + # Add more tick labels on x-axis
  scale_y_continuous(labels = scales::comma) # Format y-axis labels with commas

#Gender
# Preprocess data for Region Distribution Pie Chart
gender_data <- telecom_data %>%
  count(gender) %>%
  mutate(prop = n / sum(n))

# Sample data (gender_data)
gender_data <- telecom_data %>%
  count(gender) %>%
  mutate(prop = n / sum(n) * 100) # Calculate proportion in percentage

# Ensure the necessary fonts are available
loadfonts(device = "win") # If on Windows, otherwise adjust for your OS

# Create the pie chart with percentages inside the pie and updated legend labels
ggplot(gender_data, aes(x = "", y = prop, fill = factor(gender))) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste0(round(prop, 2), "%")),
            position = position_stack(vjust = 0.5),
            size = 5, color = "#262626", family = "Arial") + # Add percentage labels inside the pie
  labs(title = "Gender Distribution",
       x = "",
       y = "",
       fill = "Gender",
       caption = "Source: Telecom Company Data") +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(size = 10, hjust = 1),
    legend.position = "right"
  ) +
  scale_fill_brewer(palette = "Blues", labels = c("Female", "Male")) # Change legend labels