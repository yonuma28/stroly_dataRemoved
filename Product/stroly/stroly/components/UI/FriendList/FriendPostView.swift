//
//  FriendPostView.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/21.
//

import SwiftUI
import CoreLocation

struct FriendPostView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPost: postResponse?
    
    @State private var showingAlert = false
    private let postImagePrefix = "https://backend.2xseitest.workers.dev/api/"
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="

    @ObservedObject var stampModel = StampModel()
    
    var locationManager = CLLocationManager()
    
    var body: some View {
        if let post = selectedPost {
            ScrollView {
                // VStackを以下の書き方すると左揃えできる便利！
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 0) {
                            if let iconImage = loadImageIfNeeded(imageUrl: iconUrlPrefix + post.userId) {
                                Image(uiImage: iconImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                    )
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                    )
                                    .frame(width: 60, height: 60)
                            }
                        }
                        Spacer()
                            .frame(width: 20)
                        VStack (alignment: .leading, spacing: 0){
                            Text("\(post.userName)")
                                .font(.headline)
                        }
                        Spacer()
                        Season_TimeIconView(post: post)
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .imageScale(.small)
                                .foregroundColor(.white)
                        }
                        .frame(width: 30, height: 30)  // ボタンのサイズを設定
                        .background(Color.gray)  // ボタンの背景色
                        .clipShape(Circle())  // ボタンを丸形にする
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)  // ボタンの枠線
                        )
                    }
                    CustomImageView(imageUrl: postImagePrefix + post.key)
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if post.title == "" {
                                Text("タイトルなし")
                                    .font(.headline)
                            } else {
                                Text("\(post.title )")
                                    .font(.headline)
                            }
                            if let location = locationManager.location {
                                let distance = location.distance(from: CLLocation(latitude: post.latitude, longitude: post.longitude))
                                if distance < 1000 {
                                    Text("約\(String(format: "%.0f", distance))m先")
                                        .font(.caption)
                                } else {
                                    Text("約\(String(format: "%.2f", Double(distance / 1000)))km先")
                                        .font(.caption)
                                }
                            } else {
                                Text("位置情報が取得できませんでした")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        Text("\(formattedDate(from: post.createdAt))")
                            .font(.caption)
                    }
                    StampButton(stampModel: stampModel, postId: post.id)
                }
                .background(Color.white)
                .padding(.horizontal)
                .padding(.bottom, 5)
            }.onAppear() {
                stampModel.fetchStamps(postId: post.id)
            }
        }
    }
}
