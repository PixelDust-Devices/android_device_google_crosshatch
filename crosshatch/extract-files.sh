#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=crosshatch
VENDOR=google

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

PIXELDUST_ROOT="$MY_DIR"/../../..

HELPER="$PIXELDUST_ROOT/vendor/pixeldust/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    # Fix typo in qcrilmsgtunnel whitelist
    product/etc/sysconfig/nexus.xml)
        sed -i 's/qulacomm/qualcomm/' "${2}"
        ;;
    vendor/rfs/msm/mpss/readonly/vendor/mbn/mcfg_sw/mbn_sw.txt)
        sed -i '7 a\mcfg_sw/generic/China/CMCC/Commercial/Volte_OpenMkt/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/AGNSS_LocTech/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/Conf_VoLTE/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/EPS_Only/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/LPP_LocTech/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/Nsiot_VoLTE/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/RRLP_LocTech/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/TGL_Comb_Attach/mcfg_sw.mbn\nmcfg_sw/generic/China/CMCC/Lab/W_IRAT_Comb_Attach/mcfg_sw.mbn\nmcfg_sw/generic/China/CT/Commercial/hVoLTE_OpenMkt/mcfg_sw.mbn\nmcfg_sw/generic/China/CT/Commercial/OpenMkt/mcfg_sw.mbn\nmcfg_sw/generic/China/CT/Commercial/VoLTE_OpenMkt/mcfg_sw.mbn\nmcfg_sw/generic/China/CU/Commercial/OpenMkt/mcfg_sw.mbn\nmcfg_sw/generic/China/CU/Commercial/VoLTE/mcfg_sw.mbn' "${2}"
        ;;
    system_ext/lib64/libpowerstatshaldataprovider.so)
        "${PATCHELF}" --replace-needed "android.hardware.power.stats-V1-ndk_platform.so" "android.hardware.power.stats-V1-ndk.so" "${2}"
        ;;
    vendor/bin/hw/android.hardware.rebootescrow-service.citadel)
        "${PATCHELF}" --replace-needed "android.hardware.rebootescrow-V1-ndk_platform.so" "android.hardware.rebootescrow-V1-ndk.so" "${2}"
        ;;
    vendor/lib64/hw/com.qti.chi.override.so)
        "${PATCHELF}" --replace-needed "android.hardware.power-V1-ndk_platform.so" "android.hardware.power-V1-ndk.so" "${2}"
        ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${PIXELDUST_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/../crosshatch/${DEVICE}/device-proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
extract "${MY_DIR}/../crosshatch/${DEVICE}/device-proprietary-files-other.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/../crosshatch/${DEVICE}/setup-makefiles.sh"