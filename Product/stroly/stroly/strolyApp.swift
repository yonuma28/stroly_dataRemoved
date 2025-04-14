//
//  strolyApp.swift
//  stroly
//
//  Created by 長濱聖英 on 2023/11/03.
//

import SwiftUI
import SwiftData

@main
    struct strolyApp: App {
    let persistenceController = PersistenceController.shared
    
//    var sharedModelContainer: ModelContainer = {
//            let schema = Schema([
//                MyPosts.self,
//            ])
//            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//            do {
//                return try ModelContainer(for: schema, configurations: [modelConfiguration])
//            } catch {
//                fatalError("Could not create ModelContainer: \(error)")
//            }
//        }()


    var body: some Scene {
        WindowGroup {
            LaunchScreen()
        }
        .modelContainer(for: [MyPosts.self, Friends.self])
    }
}
