import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
import os

# 读取CSV数据
file_path = 'C:/Users/304/Desktop/julei_orig1.csv'
data = pd.read_csv(file_path)

# 选择要聚类的特征
X = data[['F1', 'F2']].values  # 替换为你自己的特征列名

# 使用K-means++进行聚类
kmeans = KMeans(n_clusters=6, init='k-means++', n_init=10, max_iter=300, random_state=42)
kmeans.fit(X)

# 获取聚类标签
y_kmeans = kmeans.predict(X)

# 将聚类结果添加到原始数据中
data['Cluster'] = y_kmeans  # 在数据中添加新列 'Cluster'

output_file_path = os.path.splitext(file_path)[0] + '_clustered.txt'  # 生成新的文件名
data.to_csv(output_file_path, sep='\t', index=False)  # 使用制表符分隔，保存为 TXT 文件

# 打印包含分类结果的数据
print(data)

# 如果数据是二维的，直接可视化
plt.scatter(X[:, 0], X[:, 1], c=y_kmeans, s=50, cmap='viridis')
centers = kmeans.cluster_centers_
plt.scatter(centers[:, 0], centers[:, 1], c='red', s=200, alpha=0.75)
plt.title("K-means++ Clustering Result")
plt.show()

# 如果数据是高维的，使用PCA降维后可视化
pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
plt.scatter(X_reduced[:, 0], X_reduced[:, 1], c=y_kmeans, s=50, cmap='viridis')
plt.title("K-means++ Clustering (PCA Reduced Data)")
plt.show()