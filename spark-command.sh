#!/bin/bash
spark-submit \
		--master k8s://https://192.168.1.20:6443 \
		--deploy-mode cluster \
		--conf spark.kubernetes.container.image=lieslycat/spark-py:latest \
		--conf spark.kubernetes.namespace=spark-ns \
		--conf spark.kubernetes.hadoop.configMapName=hadoop-cm \
		--conf spark.kubernetes.driver.podTemplateFile=/home/sarah/spark_pod_temp/driver.template.yml \
		--conf spark.kubernetes.executor.podTemplateFile=/home/sarah/spark_pod_temp/executor.template.yml \
		--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.data.options.claimName=data-pvc \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.data.mount.path=/mnt \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.data.mount.readOnly=false \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.data.options.claimName=data-pvc \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.data.mount.path=/mnt \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.data.mount.readOnly=false \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.metadata.options.claimName=meta-pvc \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.metadata.mount.path=/opt/spark/work-dir/spark-warehouse \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.metadata.mount.subPath=spark-warehouse \
		--conf spark.kubernetes.driver.volumes.persistentVolumeClaim.metadata.mount.readOnly=false \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.metadata.options.claimName=meta-pvc \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.metadata.mount.path=/user/hive/warehouse \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.metadata.mount.subPath=spark-warehouse \
		--conf spark.kubernetes.executor.volumes.persistentVolumeClaim.metadata.mount.readOnly=false \
		--name write_tbl \
		--conf spark.executor.instances=5 \
		local:///mnt/spark_app/insert_data.py
