---
description: Run mobile app on physical device with ADB reverse port forwarding
---

# Running Mobile App on Physical Device

This workflow sets up ADB reverse port forwarding and runs the Flutter app on a physical Android device.

## Prerequisites
- Physical Android device connected via USB
- USB debugging enabled on the device
- Backend server running on port 8000

## Steps

// turbo-all

1. Set up ADB reverse port forwarding (routes phone's localhost:8000 to PC's localhost:8000):
```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" reverse tcp:8000 tcp:8000
```

2. Verify reverse port forwarding is active:
```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" reverse --list
```

3. Run the Flutter app:
```powershell
cd c:\Users\asus\App projects\devapp\mobile
flutter run
```

## Running on Emulator Instead

If you want to run on an Android emulator instead of a physical device:
```powershell
flutter run --dart-define=DEV_MODE=emulator
```

## Running with WiFi (Physical Device on Same Network)

If your phone is on the same WiFi as your PC:
1. Find your PC's IP: `ipconfig` (look for IPv4 address)
2. Update `localLanIp` in `lib/core/config/api_config.dart`
3. Run with: `flutter run --dart-define=DEV_MODE=wifi`

## Troubleshooting

### Connection Timeout
- Verify backend is running: `curl http://localhost:8000/health`
- Check ADB reverse is active: `adb reverse --list`
- Re-run ADB reverse if needed: `adb reverse tcp:8000 tcp:8000`

### Device Not Found
- Run `adb devices` to check if device is connected
- Enable USB debugging on the phone
- Try a different USB cable
