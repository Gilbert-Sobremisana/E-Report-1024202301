require(pacman)
p_load(rio, dplyr, ggplot2,car)

#read data
telecom_data = import("C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_2.csv")

region = telecom_data$region
cluster = telecom_data$custcat
age = telecom_data$age
income = telecom_data$income
hist(region, col = "lightblue", main = "Region Distribution", xlab = "Region")
hist(cluster, col = "blue", main = "Customer Cluster Distribution", xlab = "Customer Cluster")
plot(income)

# Print the calculated values for verification
print(average_income)

# Create the bar plot with error bars
ggplot(average_income, aes(x = factor(custcat), y = avg_income)) +
  geom_bar(stat = "identity", fill = "blue") +
  geom_errorbar(aes(ymin = avg_income - se_income, ymax = avg_income + se_income), width = 0.2) +
  labs(title = "Average Income by Customer Cluster",
       x = "Customer Cluster",
       y = "Average Income") +
  ylim(0, max(average_income$avg_income + average_income$se_income)) + # Adjust the y-axis limits
  theme_minimal()

# Calculate the mean age for each cluster
mean_age_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mean_age = mean(age, na.rm = TRUE))

# Calculate the mean education for each cluster
mean_education_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mean_ed = mean(ed, na.rm = TRUE))

# Calculate the mean tenure for each cluster
mean_tenure_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mean_ed = mean(tenure, na.rm = TRUE))

# Calculate the mean income for each cluster
mean_income_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mean = mean(income, na.rm = TRUE))

average_age <- telecom_data %>%
  group_by(custclass) %>%
  summarize(
    avg_income = mean(age, na.rm = TRUE),
    se_income = sd(age, na.rm = TRUE) / sqrt(n()))

average_income <- telecom_data %>%
  group_by(custclass) %>%
  summarize(
    avg_income = mean(income, na.rm = TRUE),
    se_income = sd(income, na.rm = TRUE) / sqrt(n()))

average_employ <- telecom_data %>%
  group_by(custclass) %>%
  summarize(
    avg_income = mean(employ, na.rm = TRUE),
    se_income = sd(employ, na.rm = TRUE) / sqrt(n()))

average_tenure <- telecom_data %>%
  group_by(custclass) %>%
  summarize(
    avg_income = mean(tenure, na.rm = TRUE),
    se_income = sd(tenure, na.rm = TRUE) / sqrt(n()))

# Print the result
print(mean_age_per_cluster)
print(average_tenure)
print(mean_education_per_cluster)
print(mean_tenure_per_cluster)
print(mean_income_per_cluster)


# Function to calculate the mode
get_mode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Group by custclass and calculate the mode of marital for each group
mode_marital_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mode_marital_status = get_mode(marital))

# Group by custclass and calculate the mode of education for each group
mode_education_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mode_marital_status = get_mode(ed))

# Group by custclass and calculate the mode of region for each group
mode_region_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mode_marital_status = get_mode(region))

# Group by custclass and calculate the mode of gender for each group
mode_gender_per_cluster <- telecom_data %>%
  group_by(custclass) %>%
  summarise(mode_marital_status = get_mode(gender))


print(mode_marital_per_cluster)
print(mode_education_per_cluster)
print(mode_region_per_cluster)
print(mode_gender_per_cluster)

