//
//  customTabView.swift
//  CustomView
//
//  Created by 大沼優希人 on 2023/11/03.
//

import SwiftUI
import AVFoundation
import SwiftData
import Combine



struct mainView: View {
    @Environment(\.modelContext) private var context
    @State var index = 1  //押されたボタンの情報
    @ObservedObject var model = changeDisplayPinModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 以下に遷移先ページ記入。左から順に0,1,(camera),3,4
            if self.index == 0 {
                UserProfileView()
                    .onAppear() {
                        DispatchQueue.global().async {
                            saveUserData()
                        }
                    }
                Divider()
                tabView(index: self.$index)
                    .foregroundColor(Color.white)
            } else if self.index == 1 {
                MapView(model: model)
                    .ignoresSafeArea(.all)
                Divider()
                tabView(index: self.$index)
                    .foregroundColor(Color.white)
            } else if self.index == 3 {
                TimelineView()
                Divider()
                tabView(index: self.$index)
                    .foregroundColor(Color.white)
            } else if self.index == 4 {
                FriendList()
                    .onAppear() {
                        DispatchQueue.global().async {
                            saveFriendsData(context: context)
                        }
                    }
                Divider()
                tabView(index: self.$index)
                    .foregroundColor(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


