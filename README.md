##### Steps to deploy FieldX as part of AOSP build


* Assuming the top of AOSP source code directory is `$AOSP`
* Clone this repo under `$AOSP/device/fieldx`
* Download latest FieldX Device Manager app from FieldX [Releases](https://fieldx.io/releases) page and replace the dummy `$AOSP/device/fieldx/DeviceManager/DeviceManager.apk` file
* To integrate `Firmware Updater` app, download the latest Updater APK from Releases page and replace the dummy `$AOSP/device/fieldx/Updater/Updater.apk`
* Final step, in order to wire the `fieldx.mk` to your device build target, add `$(call inherit-product, device/fieldx/fieldx.mk)` at the bottom of the `device.mk` file of your target directory.


For instance:

* If you are integrating for `Google Pixel3a` AOSP target, then edit `$AOSP/device/google/bonito/device.mk`