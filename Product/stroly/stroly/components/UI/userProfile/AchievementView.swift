//
//  AchievementView(.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/24.
//

import SwiftUI
import SwiftData

struct AchievementView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var myPosts: [MyPosts]
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("\(myPosts.count)")
                    .font(.title2)
                Text("投稿数")
                    .font(.caption)
            }
            Spacer()
                .frame(width: 32)
            VStack {
                    Text("\(UserDefaults.standard.integer(forKey: "count"))")
                               .font(.title2)
                           Text("解放したピン")
                               .font(.caption)
                       }
            Spacer()
        }
    }
}
//プレビュー表示
struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}

