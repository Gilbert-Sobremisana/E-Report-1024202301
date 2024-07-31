import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_samples, silhouette_score
import matplotlib.cm as cm
import numpy as np
import matplotlib.style as style

# Load the data from the CSV file
data = pd.read_csv('C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_22.csv')

# Select the features for clustering
features = ['tenure', 'income', 'age', 'ed', 'employ', 'marital']

# Standardize the features
scaler = StandardScaler()
data_scaled = scaler.fit_transform(data[features])

# Perform K-means clustering with n_clusters=4
kmeans = KMeans(n_clusters=4, random_state=42)
data['cluster'] = kmeans.fit_predict(data_scaled)

# Print the cluster centers
print("Cluster Centers:")
print(scaler.inverse_transform(kmeans.cluster_centers_))

# Save the results to a new CSV file
data.to_csv('C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_22_with_cluster2.csv', index=False)

# Set the style and font
sns.set(style="whitegrid")
plt.rc('font', family='Arial')

# Define the specified colors for each cluster
colors = ['#717171', '#0A72D5', '#F4C430', '#1D8BF2']
markers = ['o', 's', 'D', '^']  # Different symbols

fig, ax = plt.subplots()
for cluster in range(4):
    filtered_data = data[data['cluster'] == cluster]
    sns.scatterplot(x='tenure', y='age', data=filtered_data,
                    ax=ax, color=colors[cluster], marker=markers[cluster],
                    label=f'Cluster {cluster + 1}', s=50)

# Set axis labels, title, and legend
ax.set_xlabel('tenure')
ax.set_ylabel('age')
ax.set_title('Clusters of Telecom Clients', fontweight='bold')

# Use gray for the border and other elements
ax.spines['top'].set_color('gray')
ax.spines['bottom'].set_color('gray')
ax.spines['left'].set_color('gray')
ax.spines['right'].set_color('gray')
ax.xaxis.label.set_color('black')
ax.yaxis.label.set_color('black')
ax.title.set_color('black')
ax.tick_params(axis='x', colors='black')
ax.tick_params(axis='y', colors='black')
ax.legend()

plt.show()

# Silhouette score for n_clusters=4
n_clusters = 4
clusterer = KMeans(n_clusters=n_clusters, random_state=42)
cluster_labels = clusterer.fit_predict(data_scaled)
silhouette_avg = silhouette_score(data_scaled, cluster_labels)
print(f"For n_clusters = {n_clusters}, the average silhouette_score is : {silhouette_avg}")

# Silhouette analysis plot for n_clusters=4
fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(18, 7)

# The 1st subplot is the silhouette plot
ax1.set_xlim([-0.1, 1])
ax1.set_ylim([0, len(data_scaled) + (n_clusters + 1) * 10])

# Compute the silhouette scores for each sample
sample_silhouette_values = silhouette_samples(data_scaled, cluster_labels)

y_lower = 10
for i in range(n_clusters):
    ith_cluster_silhouette_values = sample_silhouette_values[cluster_labels == i]
    ith_cluster_silhouette_values.sort()

    size_cluster_i = ith_cluster_silhouette_values.shape[0]
    y_upper = y_lower + size_cluster_i

    color = cm.nipy_spectral(float(i) / n_clusters)
    ax1.fill_betweenx(np.arange(y_lower, y_upper), 0, ith_cluster_silhouette_values,
                      facecolor=color, edgecolor=color, alpha=0.7)

    ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))
    y_lower = y_upper + 10

ax1.set_title("The silhouette plot for the various clusters.")
ax1.set_xlabel("The silhouette coefficient values")
ax1.set_ylabel("Cluster label")

# The vertical line for average silhouette score of all the values
ax1.axvline(x=silhouette_avg, color="red", linestyle="--")

ax1.set_yticks([])  # Clear the yaxis labels / ticks
ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])

plt.show()

# Elbow Plot
range_n_clusters = [2, 3, 4, 5, 6]
silhouette_avg_n_clusters = []

for n_clusters in range_n_clusters:
    clusterer = KMeans(n_clusters=n_clusters, random_state=42)
    cluster_labels = clusterer.fit_predict(data_scaled)
    silhouette_avg = silhouette_score(data_scaled, cluster_labels)
    silhouette_avg_n_clusters.append(silhouette_avg)

style.use("fivethirtyeight")
plt.plot(range_n_clusters, silhouette_avg_n_clusters, marker='o')
plt.xlabel("Number of Clusters (k)")
plt.ylabel("Silhouette Score")
plt.title("Elbow Plot for KMeans Clustering")
plt.show()
