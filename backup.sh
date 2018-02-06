#!/bin/bash

ETCDCTL_API=3
BACKUP_FILE_NAME=etcd-backup-$(date +%Y-%m-%d-%H-%M).db
ETCD_CA_PATH=${ETCD_CA_PATH:-}
ETCD_CERT_PATH=${ETCD_CERT_PATH:-}
ETCD_KEY_PATH=${ETCD_KEY_PATH:-}
ETCD_ENDPOINTS=${ENDPOINTS:-}
S3_BUCKET_NAME=${BUCKET_NAME:-}
CLUSTER_NAME=${CLUSTER_NAME:-}

"${ETCD_CA_PATH:?ETCD_CA_PATH unset}"
"${ETCD_CERT_PATH:?ETCD_CERT_PATH unset}"
"${ETCD_KEY_PATH:?ETCD_KEY_PATH unset}"
"${ETCD_ENDPOINTS:?ETCD_ENDPOINTS unset}"
"${S3_BUCKET_NAME:?S3_BUCKET_NAME unset}"
"${CLUSTER_NAME:?CLUSTER_NAME unset}"

/tmp/etcd/etcdctl --endpoints=${ETCD_ENDPOINTS} --cacert=${ETCD_CA_PATH} --cert=${ETCD_CERT_PATH} --key=${ETCD_KEY_PATH} snapshot save /backup/${BACKUP_FILE_NAME}.db
aws s3api put-object --region ap-south-1 --bucket ${S3_BUCKET_NAME} --key ${CLUSTER_NAME}/etcd-backup/${BACKUP_FILE_NAME} --body /backup/${BACKUP_FILE_NAME}
