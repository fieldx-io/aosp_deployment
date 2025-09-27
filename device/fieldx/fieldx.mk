#
# Copyright 2016 The Android Open Source Project
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
 
PRODUCT_PACKAGES += \
	DeviceManager \
	Updater \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/device_owner_2.xml:/system/etc/device_owner_2.xml \
    $(LOCAL_PATH)/device_policies.xml:/system/etc/device_policies.xml \
    $(LOCAL_PATH)/fieldx.rc:/system/etc/init/fieldx.rc \
    $(LOCAL_PATH)/privapp-permissions-fieldx.xml:/system/etc/permissions/privapp-permissions-fieldx.xml
    $(LOCAL_PATH)/fieldx_settings.json:/system/etc/system_settings.txt \
