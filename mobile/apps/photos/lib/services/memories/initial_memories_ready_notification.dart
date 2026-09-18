import "package:photos/models/memories/smart_memory.dart";
import "package:photos/service_locator.dart";
import "package:photos/services/app_lifecycle_service.dart";
import "package:photos/services/language_service.dart";
import "package:photos/services/notification_service.dart";
import "package:synchronized/synchronized.dart";

final _notificationLock = Lock();

bool _hasEnoughMemories(List<SmartMemory> memories) {
  return memories.any(
    (m) =>
        (m.type == .people || m.type == .clip) &&
        m.memories.isNotEmpty &&
        m.shouldShowNow(),
  );
}

Future<void> scheduleMemoriesNotification(List<SmartMemory> memories) async {
  if (!flagService.internalUser || !_hasEnoughMemories(memories)) {
    return;
  }
  await _notificationLock.synchronized(() async {
    if (localSettings.initialMemoriesNotificationScheduledAt() != null) return;
    if (DateTime.now().difference(localSettings.getInstallDateTime()).inDays >=
        21) {
      await localSettings.markInitialMemoriesNotificationScheduled();
      return;
    }
    final notifications = NotificationService.instance;
    if (!await notifications.hasGrantedPermissions()) return;
    final strings = await LanguageService.locals;
    if (AppLifecycleService.instance.isForeground) {
      await localSettings.markInitialMemoriesNotificationScheduled();
      return;
    }
    await notifications.showNotification(
      strings.memoriesReadyNotificationTitle,
      strings.memoriesReadyNotificationBody,
      id: 314159265,
      channelID: "memoriesReady",
      channelName: strings.memories,
    );
    await localSettings.markInitialMemoriesNotificationScheduled();
  });
}
