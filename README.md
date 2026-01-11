# FieldX AOSP build integration instructions.


FieldX is a Mobile Device Management (MDM) software that provides device management and OTA (Over-the-Air) update features. This guide explains how to integrate FieldX as part of your Android Open Source Project (AOSP) build.



## Prerequisites
- Access to AOSP source code directory (`$AOSP`)
- Internet access to download the updated FieldX Plugin Apps from the [FieldX Releases](https://fieldx.io/releases) page. For this purpose, you will need DeviceManager.apk (Manager) and Updater.apk (OTA)

--

### Integration Steps

1. **Navigate to your AOSP source directory**
   ```
   bash
   cd $AOSP
   ```

2. **Clone the FieldX repository**  
   Paste the FieldX zip file provided under the AOSP device tree:
   ```bash
   unzip fieldx.zip $AOSP/device/fieldx
   ```

3. **Add the FieldX Device Manager**  
   - Download the latest *Device Manager* APK from the [Releases](https://fieldx.io/releases) page.
   - Replace the stub APK with updated one:
     ```bash
     $AOSP/device/fieldx/DeviceManager/DeviceManager.apk
     ```

4. **Add the FieldX Firmware Updater**  
   - Download the latest *Updater* APK from the [Releases](https://fieldx.io/releases) page.  
   - Replace the stub APK with updated one:
     ```bash
     $AOSP/device/fieldx/Updater/Updater.apk
     ```
5. **Download FieldX Settings from Portal**
   - Download the `fieldx_settings.json` from the Downloads -> [Manual Installation](https://admin.fieldx.io/downloads/manual-installation) page.
   - Replace the stub fieldx_settings.json file with the updated one that has your secret token for enrolling devices directly to the platform.


6. **Link FieldX to your device target**  
   - Go to your device-specific `device.mk` file.
   - Add the following line at the bottom of the file:
     ```
     $(call inherit-product, device/fieldx/fieldx.mk)
     ```

--

##### Example: Google Pixel 9 Pro
If your AOSP target is Google Pixel 9 Pro XL (`caiman`), edit the following file:

```bash
$AOSP/device/google/caiman/device.mk
```

Append this line at the end:

```
$(call inherit-product, device/fieldx/fieldx.mk)
```


**Note:** A Device specific make file is usually found under `$AOSP/device` folder. For some mediatek, spreadtrum or qualcomm devices, the make file might be buried under their respective chipset code names. 

--


### Building the AOSP Image with FieldX

This is an example for building the AOSP image for `Google Pixel 3a`

1. **Set up the environment**
   ```bash
   source build/envsetup.sh
   ```

2. **Choose your device target**  
   For Pixel 9 Pro (`caiman`):
   ```bash
   lunch caiman-cur-userdebug
   ```

3. **Build the AOSP system image**
   ```
   make -j$(nproc)
   ```

The build will generate the system image with the integrated FieldX Device Manager and Updater apps.



## Verifying FieldX Integration

1. **Check system image content**  
   After build completion, verify that FieldX APKs are packaged into the system image:
   ```
   ls $AOSP/out/target/product/<device>/system/priv-app/
   ```

   You should see `DeviceManager` and `Updater` directories inside `priv-app` folder.


2. **Boot the device with the new image**  
   Flash the image to your device:
   ```
   fastboot flashall
   ```


3. **Verify apps on device**  
   Once the device boots, check that the FieldX apps are installed as system apps:
   ```bash
   adb shell pm list packages | grep fieldx
   ```

   You should see:
   ```
   package:io.fieldx.app.devices
   package:io.fieldx.ota
   ```

4. **Test OTA and management workflows**  
   - Open the *FieldX Device Manager* app to confirm enrollment workflows.  
   - Trigger updates from the *FieldX Server* to validate OTA functionality.  

   
    

## Troubleshooting FieldX Integration

If FieldX APKs do not appear on your device, or if device management features do not work as expected, check the common issues below.

#### System Apps Not Showing Up

- **Validate APK Placement**
  - Ensure the APK files are located in `$AOSP/device/fieldx/DeviceManager/DeviceManager.apk` and `$AOSP/device/fieldx/Updater/Updater.apk`.
  - Confirm that the APKs are referenced correctly in `fieldx.mk`.

- **Check System Image Build Output**
  - After build, verify the APKs exist under:
    ```
    $AOSP/out/target/product/<device>/system/priv-app/
    ```
  - If missing, review your `fieldx.mk` file and make sure `BUILD_PREBUILT` or similar construct is used with the right APK path.



#### Privileged Permissions Not Granted

If the device goes into bootloop, then there are chances that all permissions are not granted by default to the FieldX Apps.

- **App Requires Privileged Permissions**
  - Grant required permissions via an entry in `privapp-permissions-fieldx.xml`, placing the XML file in the appropriate location under `system/etc/permissions`.
  - If permissions are still not auto-granted, confirm the app’s package name matches your XML entry.  
  - Permissions can be checked with:
    ```s
    adb shell pm list permissions -g -d io.fieldx.app.devices
    ```

#### APK Signing Issues

- **Signature Mismatch**
  - APKs must be signed with platform or test keys (for non-PRESIGNED builds).
  - Verify with:
    ```
    apksigner verify --print-certs DeviceManager.apk
    ```
  - If signature is broken, resign the APK with correct key or use `LOCAL_CERTIFICATE := platform` in your makefile
