import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_samples, silhouette_score
import itertools
import matplotlib.cm as cm
import numpy as np
import matplotlib.style as style

# Load the data from the CSV file
data = pd.read_csv('C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_22.csv')

# Define the possible features
features = ['region', 'tenure', 'age', 'marital', 'income', 'ed', 'employ', 'retire', 'gender']

# Function to compute silhouette score for a given combination of features
def compute_silhouette_score(data, feature_combination, n_clusters=4):
    scaler = StandardScaler()
    data_scaled = scaler.fit_transform(data[feature_combination])
    kmeans = KMeans(n_clusters=n_clusters, random_state=42)
    cluster_labels = kmeans.fit_predict(data_scaled)
    silhouette_avg = silhouette_score(data_scaled, cluster_labels)
    return silhouette_avg

# Store the silhouette scores for different combinations
silhouette_scores = []

# Iterate through all possible combinations of features
for r in range(1, len(features) + 1):
    for combination in itertools.combinations(features, r):
        score = compute_silhouette_score(data, list(combination))
        silhouette_scores.append((combination, score))

# Sort the combinations based on the silhouette score in descending order
silhouette_scores.sort(key=lambda x: x[1], reverse=True)

# Print the sorted silhouette scores
print("Ranked Silhouette Scores (from highest to lowest):")
for combination, score in silhouette_scores:
    print(f"Features: {combination}, Silhouette Score: {score}")

# Plot the silhouette score for the highest scoring combination
best_combination = silhouette_scores[0][0]
scaler = StandardScaler()
data_scaled = scaler.fit_transform(data[list(best_combination)])
kmeans = KMeans(n_clusters=4, random_state=42)
cluster_labels = kmeans.fit_predict(data_scaled)
silhouette_avg = silhouette_score(data_scaled, cluster_labels)
sample_silhouette_values = silhouette_samples(data_scaled, cluster_labels)

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(18, 7)

ax1.set_xlim([-0.1, 1])
ax1.set_ylim([0, len(data_scaled) + (4 + 1) * 10])

y_lower = 10
for i in range(4):
    ith_cluster_silhouette_values = sample_silhouette_values[cluster_labels == i]
    ith_cluster_silhouette_values.sort()

    size_cluster_i = ith_cluster_silhouette_values.shape[0]
    y_upper = y_lower + size_cluster_i

    color = cm.nipy_spectral(float(i) / 4)
    ax1.fill_betweenx(np.arange(y_lower, y_upper), 0, ith_cluster_silhouette_values,
                      facecolor=color, edgecolor=color, alpha=0.7)

    ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))
    y_lower = y_upper + 10

ax1.set_title("The silhouette plot for the best combination of features.")
ax1.set_xlabel("The silhouette coefficient values")
ax1.set_ylabel("Cluster label")

ax1.axvline(x=silhouette_avg, color="red", linestyle="--")
ax1.set_yticks([])
ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])

plt.show()
