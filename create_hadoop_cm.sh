#!/bin/bash
kubectl create configmap -n spark-ns --from-file=spark_conf/
