//
//  FriendList.swift
//  stroly
//
//  Created by 小平暖太 on 2023/12/15.
//

import SwiftUI
import SwiftData
import Alamofire

struct decolation {
    let listHeight: CGFloat = 2
}

struct FriendList: View {
    @Environment(\.modelContext) private var context
    @Query var friends: [Friends]
    @State var isDeleteFriend = false
    @State var isProfileTapped = false
    @State var selectedFriend: Friend = Friend(friendId: "", userName: "", icon: nil)
    let deco = decolation()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("ともだちの数：\(friends.count)")
                    .padding(.top, 10)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                    .frame(height: 10)
                //線を引く
                Divider()
                    .foregroundColor(.gray)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(friends, id: \.self) { friend in
                                let imageUrlPrefix = "https://backend.2xseitest.workers.dev/api/"
                                let iconKey = friend.iconKey
                                let imageUrl = imageUrlPrefix + iconKey
                                let imageData = loadImageIfNeeded(imageUrl: imageUrl)
                                let friendId = friend.friendId
                                let userName = friend.userName
                                VStack(spacing: 5) {
                                    Spacer()
                                        .frame(height: deco.listHeight)
                                    HStack {
                                        Button(action: {
                                            isProfileTapped = true
                                            selectedFriend = Friend(friendId: friendId, userName: userName, icon: imageData)
                                        }, label: {
                                            HStack(alignment: .top) {
                                                if let icon = imageData {
                                                    Image(uiImage: icon)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                                        )
                                                        .frame(width: 60, height: 60)
                                                } else {
                                                    Image(systemName: "person.circle")
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                                        ) .frame(width: 60, height: 60)
                                                }
                                                VStack {
                                                    Spacer()
                                                    Text("\(friend.userName)")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                        })
                                        Spacer()
                                        Menu {
                                            Button(action: {
                                                isDeleteFriend = true
                                                selectedFriend = Friend(friendId: friendId, userName: userName, icon: imageData)
                                                print("Deleteボタンが押されました")
                                            }) {
                                                Text("削除する")
                                                    .font(.headline)
                                                    .padding()
                                                    .background(Color.pink)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                        } label: {
                                            Image(systemName:"ellipsis")
                                                .padding()
                                                .foregroundColor(.gray)
                                        }
                                        .alert(isPresented: $isDeleteFriend) {
                                            Alert(title: Text("\"\(selectedFriend.userName)\"を友達から削除しますか？"),
                                                  primaryButton: .cancel(Text("キャンセル")),
                                                  secondaryButton: .destructive(Text("削除"))
                                            )
                                        }
                                    }
                                    Spacer()
                                        .frame(height: deco.listHeight)
                                }
                                Divider()
                            }
                            .padding(.horizontal, 10)
                    }
                }
                NavigationLink(destination: FriendProfileView(friend: selectedFriend), isActive: $isProfileTapped, label: {EmptyView()})
            }
        }
    }
}
