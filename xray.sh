#!/bin/sh

# Set ARG
PLATFORM=$1
TAG=$2

if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
XRAY_FILE="Xray-linux-${ARCH}.zip"
DGST_FILE="Xray-linux-${ARCH}.zip.dgst"
echo "Downloading binary file: ${XRAY_FILE}"
echo "Downloading binary file: ${DGST_FILE}"

wget -O ${PWD}/xray.zip https://github.com/XTLS/Xray-core/releases/download/${TAG}/${XRAY_FILE} > /dev/null 2>&1
wget -O ${PWD}/xray.zip.dgst https://github.com/XTLS/Xray-core/releases/download/${TAG}/${DGST_FILE} > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE} ${DGST_FILE}" && exit 1
fi
echo "Download binary file: ${XRAY_FILE} ${DGST_FILE} completed"

# Check SHA512
XRAY_ZIP_HASH=$(sha512sum xray.zip | cut -f1 -d' ')
XRAY_ZIP_DGST_HASH=$(cat xray.zip.dgst | grep -e 'SHA512' -e 'SHA2-512' | head -n1 | cut -f2 -d' ')

if [ "${XRAY_ZIP_HASH}" = "${XRAY_ZIP_DGST_HASH}" ]; then
    echo " Check passed" && rm -fv xray.zip.dgst
else
    echo "XRAY_ZIP_HASH: ${XRAY_ZIP_HASH}"
    echo "XRAY_ZIP_DGST_HASH: ${XRAY_ZIP_DGST_HASH}"
    echo " Check have not passed yet " && exit 1
fi

# Prepare
echo "Prepare to use"
unzip xray.zip && chmod +x xray
mv xray /usr/local/bin/
mv geosite.dat geoip.dat /usr/local/lib/xray/

for BASE in 00_log 01_api 02_dns 03_routing 04_policy 05_inbounds 06_outbounds 07_transport 08_stats 09_reverse; do
    echo '{}' > "/usr/local/etc/xray/$BASE.json"
done

# Clean
rm -rf ${PWD}/*
echo "Done"
