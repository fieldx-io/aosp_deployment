LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := DeviceManager
LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVATE_PLATFORM_APIS := true
#LOCAL_PRODUCT_MODULE=true
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_TAGS := optional
LOCAL_USE_AAPT2 := true

include $(BUILD_PREBUILT)
include $(call all-makefiles-under,$(LOCAL_PATH))
