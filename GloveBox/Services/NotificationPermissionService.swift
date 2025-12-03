import UserNotifications

enum NotificationPermissionStatus {
    case granted
    case denied
    case undecided
}

final class NotificationPermissionService {

    static let shared = NotificationPermissionService()
    
    private init() {}

    private let notificationCenter = UNUserNotificationCenter.current()

    var status: NotificationPermissionStatus {
        get async {
            let settings = await notificationCenter.notificationSettings()

            switch settings.authorizationStatus {
                case .authorized, .provisional:
                    return .granted

                case .notDetermined:
                    return .undecided

                case .denied:
                    fallthrough

                default:
                    return .denied
            }
        }
    }

    @discardableResult
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [
                .alert,
                .sound,
                .badge
            ])
            return granted

        } catch {
            print("❌ NotificationPermissionService error: \(error.localizedDescription)")
            return false
        }
    }
}
