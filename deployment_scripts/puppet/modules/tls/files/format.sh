#!/bin/bash

CRT=$1
KEY=$2
CA=$3
SSL_PATH=$4
############################################################################################################################
# Horizon part
############################################################################################################################
echo "-----BEGIN CERTIFICATE-----" > $SSL_PATH/horizon.crt
echo $CRT  | awk -F "-----" '{ print $3}' | sed 's/ /\n/g' | sed '/^$/d' >> $SSL_PATH/horizon.crt
echo "-----END CERTIFICATE-----" >> $SSL_PATH/horizon.crt

echo "-----BEGIN PRIVATE KEY-----" > $SSL_PATH/horizon.key
echo $KEY  | awk -F "-----" '{ print $3}' | sed 's/ /\n/g' | sed '/^$/d' >> $SSL_PATH/horizon.key
echo "-----END PRIVATE KEY-----" >> $SSL_PATH/horizon.key

echo "-----BEGIN CERTIFICATE-----" > $SSL_PATH/horizon.ca
echo $CA  | awk -F "-----" '{ print $3}' | sed 's/ /\n/g' | sed '/^$/d' >> $SSL_PATH/horizon.ca
echo "-----END CERTIFICATE-----" >> $SSL_PATH/horizon.ca



############################################################################################################################
# Nova part
############################################################################################################################
echo "-----BEGIN CERTIFICATE-----" > /etc/nova/tls/nova.crt
echo $CRT  | awk -F "-----" '{ print $3}' | sed 's/ /\n/g' | sed '/^$/d' >> /etc/nova/tls/nova.crt
echo "-----END CERTIFICATE-----" >> /etc/nova/tls/nova.crt

echo "-----BEGIN PRIVATE KEY-----" > /etc/nova/tls/nova.key
echo $KEY  | awk -F "-----" '{ print $3}' | sed 's/ /\n/g' | sed '/^$/d' >> /etc/nova/tls/nova.key
echo "-----END PRIVATE KEY-----" >> /etc/nova/tls/nova.key
