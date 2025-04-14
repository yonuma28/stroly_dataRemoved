//
//  posts.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import SwiftUI
import CoreLocation
import SwiftData

struct PostsCardView: View {
    private var post: postResponse
    @ObservedObject var changeMapType = changeDisplayPinModel()
    @ObservedObject var stampModel = StampModel()
    private let locationManager = CLLocationManager()
    
    @Environment(\.modelContext) private var context
    @Query var friends: [Friends]
    
    @State private var selectedPost: postResponse?
    @Binding var isFriendTapped: Bool
    @Binding var selectedFriend: Friend
    @State private var isGoToMap: Bool = false
    @State private var isShowingAlert: Bool = false
    let imageUrlPrefix = "https://backend.2xseitest.workers.dev/api/"
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    init(post: postResponse, isFriendTapped: Binding<Bool>, selectedFriend: Binding<Friend>) {
        self.post = post
        self._isFriendTapped = isFriendTapped
        self._selectedFriend = selectedFriend
        stampModel.fetchStamps(postId: post.id)
    }
    
    var body: some View {
        NavigationStack() {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button {
                        if let friend = friends.first(where: {$0.friendId == post.userId}) {
                            selectedFriend = Friend(friendId: friend.friendId, userName: friend.userName, icon: loadImageIfNeeded(imageUrl: iconUrlPrefix + post.userId) ?? nil)
                            isFriendTapped = true
                        } else {
                            for friend in friends {
                                print("friendId: \(friend.friendId)")
                            }
                            print("post.userId: \(post.userId)")
                            isShowingAlert = true
                        }
                    } label: {
                        if let iconImage = loadImageIfNeeded(imageUrl:iconUrlPrefix + post.userId) {
                            Image(uiImage: iconImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            // 周りを灰色で囲む
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
                                .frame(width: 60, height: 60, alignment: .leading)
                        }
                        Spacer()
                            .frame(width: 10)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(post.userName)
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .alert(isPresented: $isShowingAlert, content: {
                        Alert(title: Text("友達ではありません"), message: Text("このユーザーはあなたの友達ではありません。"), dismissButton: .default(Text("OK")))
                    })
                    Season_TimeIconView(post: post)
                }
                CustomImageView(imageUrl: imageUrlPrefix + post.key)
                
                HStack {
                    VStack(alignment: .leading) {
                        if post.title == "" {
                            Text("タイトルなし")
                                .font(.headline)
                        } else {
                            Text("\(post.title)")
                                .font(.headline)
                        }
                        if let location = locationManager.location {
                            Text("約\(String(format: "%.0f", location.distance(from: CLLocation(latitude: post.latitude, longitude: post.longitude))))m先")
                                .font(.caption)
                        } else {
                            Text("位置情報を取得できません")
                                .font(.caption)
                        }
                    }
                    Spacer()
                    Text("\(formattedDate(from: post.createdAt))")
                        .font(.caption)
                }
                PostCardStampButton(stampModel: stampModel, postId: post.id)

            }
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black, lineWidth: 0.5))
            .padding(.horizontal)
            .padding(.bottom, 11)
            .padding(.top, 5)
        }
        .onAppear() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}
