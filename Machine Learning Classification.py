import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from mpl_toolkits.mplot3d import Axes3D

# Load the data from the CSV file
data = pd.read_csv('C:/Users/Gib/Research Projects/Data Science Projects/Business-Telecom/telecom_company_data_22.csv')

# Select the features for clustering
features = ['tenure', 'age', 'marital', 'income', 'ed', 'employ']

# Standardize the features
scaler = StandardScaler()
data_scaled = scaler.fit_transform(data[features])

# Perform K-means clustering
kmeans = KMeans(n_clusters=4, random_state=42)
data['cluster'] = kmeans.fit_predict(data_scaled)

# Print the cluster centers
print("Cluster Centers:")
print(scaler.inverse_transform(kmeans.cluster_centers_))

# Save the results to a new CSV file
data.to_csv('telecom_clients_with_clusters.csv', index=False)

# Visualize the clusters in 3D
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
scatter = ax.scatter(data['age'], data['income'], data['tenure'], c=data['cluster'], cmap='viridis')

ax.set_xlabel('Age')
ax.set_ylabel('Income')
ax.set_zlabel('Tenure')
ax.set_title('3D Clusters of Telecom Clients')
legend = ax.legend(*scatter.legend_elements(), title="Clusters")
ax.add_artist(legend)

plt.show()
