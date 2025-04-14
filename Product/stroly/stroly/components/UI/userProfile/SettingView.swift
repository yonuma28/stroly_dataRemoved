//
//  SettingView.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/17.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    private let decoSet = DecorationSettings()
    
    @State private var userName = UserDefaults.standard.string(forKey: "name") ?? "ユーザー名"
    @State private var mail = UserDefaults.standard.string(forKey: "email") ?? "メールアドレス"
    
    @State private var isShowingAlert = false
    @State private var isShowingNotificationAlert = false
    @State private var isNameChangeTapped = false
    @State private var isMailChangeTapped = false
    @State private var newUserName = ""
    @State private var newMail = ""
    
    @State private var notificationTime = Date()
    @State private var showingNotificationSettings = false
    @ObservedObject var notificationSettings = NotificationSettings.shared
    
    @State private var notificationFrequency: NotificationSettings.NotificationType = .daily
    @State private var isNotificationEnabled: Bool = false
    
    @AppStorage("isLogined") var isLogined = UserDefaults.standard.bool(forKey: "isLogined")
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query private var myPosts: [MyPosts]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Spacer()
                        .frame(width: 5)
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 15, height: 25)
                            .padding()
                        
                    })
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 20)
                //ユーザーネームの行
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                        Text("ユーザーネーム")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: decoSet.heightBetweenString)
                    HStack {
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                        if !isNameChangeTapped {
                            Text(userName)
                        } else {
                            TextField(userName + "(ここに入力)", text: $newUserName)
                        }
                        Spacer()
                        Button(action: {
                            if isNameChangeTapped {
                                if newUserName != "" {
                                    userName = newUserName
                                    newUserName = ""
                                }
                            }
                            isNameChangeTapped.toggle()
                        }, label: {
                            if !isNameChangeTapped {
                                Text("変更")
                            } else {
                                Text("更新")
                            }
                            Spacer()
                                .frame(width: decoSet.sideWidth)
                            
                        })
                    }
                }
                
                //メールの行
                HStack {
                    Spacer()
                        .frame(width: decoSet.lineWidth)
                    Rectangle()
                        .frame(height: decoSet.rectangleHeight)
                        .foregroundColor(.gray.opacity(decoSet.opacity))
                    Spacer()
                        .frame(width: decoSet.lineWidth)
                }
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                        Text("メールアドレス")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: decoSet.heightBetweenString)
                    HStack {
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                        if !isMailChangeTapped {
                            Text(mail)
                        } else {
                            TextField(mail + "(ここに入力)", text: $newMail)
                        }
                        Spacer()
                        Button(action: {
                            if isMailChangeTapped {
                                if newMail != "" {
                                    mail = newMail
                                    newMail = ""
                                }
                            }
                            isMailChangeTapped.toggle()
                        }, label: {
                            if !isMailChangeTapped {
                                Text("変更")
                            } else {
                                Text("更新")
                            }
                            Spacer()
                                .frame(width: decoSet.sideWidth)
                            
                        })
                    }
                }
                
                HStack {
                    Spacer()
                        .frame(width: decoSet.lineWidth)
                    Rectangle()
                        .frame(height: decoSet.rectangleHeight)
                        .foregroundColor(.gray.opacity(decoSet.opacity))
                    Spacer()
                        .frame(width: decoSet.lineWidth)
                }
                
                Toggle(isOn: $isNotificationEnabled) {
                    Text("通知を有効にする")
                }
                .onChange(of: isNotificationEnabled) { isEnabled in
                    checkNotificationAuthorization(isEnabled: isEnabled)
                }
                .onAppear {
                    checkNotificationSettings()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    checkNotificationSettings()
                }
                .alert(isPresented: $isShowingNotificationAlert) {
                    Alert(
                        title: Text("通知許可が必要"),
                        message: Text("本体のアプリ設定から通知を許可してください。"),
                        dismissButton: .default(Text("了解"))
                    )
                }
                .padding(.horizontal, 10)
                
                // トグルがオンの場合にのみ表示されるDatePicker
                if isNotificationEnabled {
                    Picker("通知頻度", selection: $notificationFrequency) {
                        Text("毎日").tag(NotificationSettings.NotificationType.daily)
                        Text("毎週").tag(NotificationSettings.NotificationType.weekly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 10)
                    .onChange(of: notificationFrequency) {
                        notificationSettings.notificationType = notificationFrequency
                        notificationSettings.saveNotificationType(notificationFrequency)
                    }
                    .onAppear {
                        notificationFrequency = notificationSettings.loadNotificationType()
                    }
                    
                    if notificationSettings.notificationType == .daily {
                        // 毎日の通知のための時間選択
                        DatePicker("通知時刻:", selection: $notificationTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: notificationTime) { date in
                                notificationSettings.notificationTime = date
                                notificationSettings.scheduleNotification()
                                notificationSettings.saveNotificationTime(date) // ここで時刻を保存
                            }
                            .onAppear {
                                notificationTime = notificationSettings.loadNotificationTime()
                            }
                        
                        
                    } else if notificationSettings.notificationType == .weekly {
                        // 毎週の通知のための曜日選択
                        DatePicker("通知日:", selection: $notificationTime, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .onChange(of: notificationTime) { date in
                                notificationSettings.notificationTime = date
                                print(date)
                                notificationSettings.scheduleNotification()
                                notificationSettings.saveNotificationTimeWeekly(date) // ここで時刻を保存
                            }
                            .onAppear {
                                notificationTime = notificationSettings.loadNotificationTimeWeekly()
                            }
                    }
                    Divider()
                        .padding(.horizontal, 10)
                }
                
                Spacer()
                // Logoutボタン
                Button(action: {
                    isShowingAlert = true
                }, label: {
                    Text("ログアウト")
                        .foregroundColor(.white)
                })
                .padding()
                .background(.pink)
                .clipShape(Capsule())
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("確認"),
                        message: Text("本当にログアウトしますか？"),
                        primaryButton: .destructive(Text("ログアウト")) {
                            // Documentフォルダの内容全削除
                            let fileManager = FileManager.default
                            let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURLs = try! fileManager.contentsOfDirectory(at: documentDir, includingPropertiesForKeys: nil, options: [])
                            for fileURL in fileURLs {
                                try! fileManager.removeItem(at: fileURL)
                            }
                            isLogined = false
                            do {
                                let fetchPostsDescriptor = FetchDescriptor<MyPosts>()
                                let fetchFriendsDescriptor = FetchDescriptor<Friends>()
                                let postsCount = try context.fetchCount(fetchPostsDescriptor)
                                let friendsCount = try context.fetchCount(fetchFriendsDescriptor)
                                print("posts count: \(postsCount)")
                                print("friends count: \(friendsCount)")
                                try context.delete(model: MyPosts.self, includeSubclasses: true)
                                try context.delete(model: Friends.self, includeSubclasses: true)
                                // UserDefaultsのデータを全部消す
                                let domain = Bundle.main.bundleIdentifier!
                                UserDefaults.standard.removePersistentDomain(forName: domain)
                                UserDefaults.standard.synchronize()
                                print("deleted")
                            } catch {
                                print("error")
                            }
                            let _ = LaunchScreen()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }.navigationBarBackButtonHidden(true)
        Spacer()
            .frame(height: 40)
    }
    // 通知設定をチェックしてトグルの状態を更新する
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    // 通知が許可されている場合
                    isNotificationEnabled = UserDefaults.standard.bool(forKey: "isNotificationEnabled")
                } else {
                    // 通知が拒否されている場合
                    isNotificationEnabled = false
                }
            }
        }
    }
    
    func checkNotificationAuthorization(isEnabled: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .notDetermined {
                    // 通知がまだ許可されていない場合は、ユーザーに許可を求める
                    requestNotificationAuthorization(isEnabled: isEnabled)
                } else if settings.authorizationStatus == .denied {
                    // 通知が拒否されている場合はアラートを表示
                    isShowingNotificationAlert = true
                    isNotificationEnabled = false
                } else {
                    // 通知が許可されている場合は通知設定を変更
                    updateNotificationSettings(isEnabled: isEnabled)
                }
            }
        }
    }

    func requestNotificationAuthorization(isEnabled: Bool) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    // 通知の許可が得られた場合は通知設定を更新
                    updateNotificationSettings(isEnabled: isEnabled)
                } else {
                    // 許可が得られなかった場合はアラートを表示
                    isShowingNotificationAlert = true
                    isNotificationEnabled = false
                }
            }
        }
    }

    func updateNotificationSettings(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "isNotificationEnabled")
        if isEnabled {
            // 通知をスケジュール
            NotificationSettings.shared.scheduleNotification()
        } else {
            // 通知をキャンセル
            NotificationSettings.shared.cancelNotifications()
        }
    }
}
