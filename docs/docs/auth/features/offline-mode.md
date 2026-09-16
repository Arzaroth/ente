---
title: Using offline mode safely - Auth
description: Guidelines for backing up and recovering Ente Auth codes when using offline mode
---

# Using offline mode safely

Ente Auth can be used without an account by choosing **Use without backups**. In offline mode, your codes are stored only on that device. They are not synced to Ente and cannot be restored from Ente's servers.

## How offline storage works

The local vault is encrypted using a key protected by the device's secure storage, such as the OS keychain, keyring, credential store, or secure storage service. If that secure-storage key becomes unavailable, Ente cannot recover the offline vault from the local database alone.

Device transfers and OS backups are not supported recovery methods for offline-mode codes. They may not include the secure-storage key, or the restored key may not be usable on the new system.

## Before device or OS changes

If you use Ente Auth in offline mode, create an encrypted export or local backup before resetting credentials, reinstalling your OS, transferring devices, restoring a device backup, or making major system changes. Verify that you know the backup password, and store the backup or export file in a separate location you can access after the change.

## App lock is not a recovery password

App lock protects access to the app UI. It is not a recovery password for your codes and does not re-encrypt the stored Auth data.

## Keep a backup before setting an app lock

Before you set an app lock PIN or password in offline mode, save a backup of your codes outside the app. Keep the backup password safe too.

## Forgot your app lock in offline mode

If you forget your app lock there is no way to reset it. You will need to clear the app's data or delete and reinstall the app. This erases your saved codes and Ente cannot recover them.

### Android

Open your device's `Settings > Apps > Ente Auth > Storage` and tap **Clear data** or **Clear storage**. The names vary by device. This removes the app lock and the codes saved in the app. Clearing the cache does not reset the app lock.

### iOS

Delete Ente Auth and reinstall it from the App Store. Choose **Delete App**. This removes the codes saved in the app. Offloading the app keeps its data and does not reset the app lock.

### Windows, macOS and Linux

Uninstalling Ente Auth removes the program but leaves your saved data and app lock settings behind. Reinstalling it does not reset the lock.

Quit Ente Auth fully before changing its saved data. On Windows and Linux, choose **Exit App** from the tray icon's menu.

**Windows:**

Ente Auth keeps its current data and saved secrets in `%APPDATA%\Ente Technologies, Inc\Ente Auth`. Older versions also used `ente` or `enteauth` folders inside Documents. Do not delete these older folders without checking that they contain only Auth data.

**macOS:**

Ente Auth keeps its app data in `~/Library/Containers/io.ente.auth.mac` and its saved secrets in the keychain. Removing the app from Applications leaves this data behind.

**Linux:**

The default data folder is `~/.local/share/io.ente.auth`. Older versions also used `~/.local/share/enteauth` or `~/.local/share/ente_auth`. Flatpak installs keep Auth's files inside `~/.var/app/io.ente.auth/`. These locations differ if you have changed your system's user data folder.

Auth also keeps its saved secrets in the desktop keyring under `io.ente.auth/FlutterSecureStorage`. Deleting this entry removes all Auth secrets, including the key needed to read your codes. It does more than remove the app lock.

## Back up your codes

Open `Settings > Data > Local backup` to enable automatic local backups, or create an encrypted export from the Data settings. Keep your backup or export files and password somewhere safe.
