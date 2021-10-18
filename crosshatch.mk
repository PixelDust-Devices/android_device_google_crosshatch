#
# Copyright 2018 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit AOSP product configuration
$(call inherit-product, device/google/crosshatch/aosp_crosshatch.mk)

# Bootanimation
BOOTANIMATION := 1440

# Ignore selinux neverallows
SELINUX_IGNORE_NEVERALLOWS := true

# Google Apps
WITH_GMS := true
DEVICE_REQUIRES_CARRIER_APPS := true
REMOVE_GAPPS_PACKAGES += \
    pixel_2016_exclusive \
    pixel_experience_2019_midyear \
    pixel_experience_2019 \
    pixel_experience_2020_midyear \
    pixel_experience_2020 \
    NetworkPermissionConfigGoogle \
    NetworkStackGoogle \

# Product properties
PRODUCT_NAME := crosshatch
PRODUCT_DEVICE := crosshatch
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3 XL

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.pixeldust.maintainer="spezi77" \
    ro.pixeldust.device="crosshatch"
