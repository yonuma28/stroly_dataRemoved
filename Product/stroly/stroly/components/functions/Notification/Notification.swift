//
//  Notification.swift
//  stroly
//
//  Created by 大沼優希人 on 2024/01/19.
//

import Foundation
import UserNotifications

class NotificationSettings: ObservableObject {
    static let shared = NotificationSettings()
    
    @Published var notificationType: NotificationType = .daily
    var notificationTime: Date = Date()
    
    // 通知の許可を求めるメソッド
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification Authorization Error: \(error)")
            }
        }
    }
    
    enum NotificationType {
        case daily
        case weekly
    }
    
    // UserDefaultsに時刻を保存する
    func saveNotificationTime(_ date: Date) {
        let timeInterval = date.timeIntervalSince1970
        UserDefaults.standard.set(timeInterval, forKey: "notificationTime")
    }

    // UserDefaultsから時刻を読み込む
    func loadNotificationTime() -> Date {
        let timeInterval = UserDefaults.standard.double(forKey: "notificationTime")
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func saveNotificationTimeWeekly(_ date: Date) {
        let timeInterval = date.timeIntervalSince1970
        UserDefaults.standard.set(timeInterval, forKey: "notificationTimeWeekly")
    }
    
    func loadNotificationTimeWeekly() -> Date {
        let timeInterval = UserDefaults.standard.double(forKey: "notificationTimeWeekly")
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    // UserDefaultsに通知の種類を保存する
    func saveNotificationType(_ type: NotificationType) {
        UserDefaults.standard.set(type == .daily, forKey: "isDailyNotification")
    }
    
    // UserDefaultsから通知の種類を読み込む
    func loadNotificationType() -> NotificationType {
        let isDailyNotification = UserDefaults.standard.bool(forKey: "isDailyNotification")
        return isDailyNotification ? .daily : .weekly
    }
    
    func scheduleNotification() {
        switch notificationType {
        case .daily:
            // 既存の通知をキャンセル
            cancelNotifications()
            scheduleDailyNotification(at: notificationTime)
        case .weekly:
            // 既存の通知をキャンセル
            cancelNotifications()
            scheduleWeeklyNotification(on: notificationTime)
        }
    }
    
    // 指定した条件に基づいて毎日特定の時刻に通知をスケジュールする
    func scheduleDailyNotification(at time: Date) {
        let userDefaults = UserDefaults.standard
        let allEntries = userDefaults.dictionaryRepresentation()

        for (key, value) in allEntries {
            if let boolValue = value as? Bool, boolValue == false {
                // Bool型の値がfalseの場合、特定の時刻で毎日通知をスケジュール
                scheduleNotificationForKeyDaily(key, at: time)
                break // 1つ見つかったらループを抜ける
            }
        }
    }
    
    // 指定した日付から毎週通知が来る
    func scheduleWeeklyNotification(on selectedDate: Date) {
        let userDefaults = UserDefaults.standard
        let allEntries = userDefaults.dictionaryRepresentation()

        for (key, value) in allEntries {
            if let boolValue = value as? Bool, boolValue == false {
                // Bool型の値がfalseの場合、特定の曜日と時刻で通知をスケジュール
                scheduleNotificationForKeyWeekly(key, on: selectedDate)
                break // 1つ見つかったらループを抜ける
            }
        }
    }

    // 特定のキーと指定された時刻に基づいて毎日通知をスケジュールする
    private func scheduleNotificationForKeyDaily(_ key: String, at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Stroly"
        content.body = "近くに開放していないピンがあります。"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "UserDefaultsNotification-\(key)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for key \(key): \(error)")
            }
        }
    }


    // 特定のキーと選択された日付に基づいて毎週通知をスケジュールする
    private func scheduleNotificationForKeyWeekly(_ key: String, on selectedDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Stroly"
        content.body = "近くに開放していないピンがあります。"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.weekday, .hour, .minute], from: selectedDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "UserDefaultsNotification-\(key)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification for key \(key): \(error)")
            }
        }
    }

    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
