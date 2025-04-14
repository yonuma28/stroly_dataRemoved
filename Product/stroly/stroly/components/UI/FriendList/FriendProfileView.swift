//
//  FriendProfileView.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/12.
//

import SwiftUI

struct FriendProfileView: View {
    var friend: Friend
    var deco = DecorationSettings()
    
    @State private var isPostTapped = false
    @State private var selectedPost: postResponse? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            ScrollView {
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
                        .frame(height: 10)
                    HStack {
                        Spacer()
                            .frame(width: deco.sideWidth)
                        if let icon = friend.icon {
                            Image(uiImage: icon)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                )
                                .frame(width: deco.iconWidth, height: deco.iconHeight)
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1.0) // 1.0やそれ以下の値に調整
                                )
                                .frame(width: deco.iconWidth, height: deco.iconHeight)
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: deco.heightBetweenString)
                    
                        HStack {
                            Spacer()
                                .frame(width: deco.sideWidth)
                            Text(friend.userName)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    Spacer()
                    FriendAlbumView(userId: friend.friendId, isPostTapped: $isPostTapped, selectedPost: $selectedPost, friend: friend)
                }
                .sheet(isPresented: $isPostTapped) {
                    FriendPostView(selectedPost: $selectedPost)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
