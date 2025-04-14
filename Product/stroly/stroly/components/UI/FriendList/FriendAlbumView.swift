//
//  FriendAlbumView.swift
//  stroly
//
//  Created by 大坪雄也 on 2023/1/21.
//

import SwiftUI
import SwiftData
import CoreLocation

struct FriendAlbumView: View {
    private let decoSet = DecorationSettings()
    
    @Binding var isPostTapped: Bool
    @Binding var selectedPost: postResponse?
    var friend: Friend
    
    private var userId: String
    @State private var userPosts: [postResponse]?
    private let locationManager = CLLocationManager()
    @State private var currentLocation: CLLocation? = nil
    private let postImagePrefix = "https://backend.2xseitest.workers.dev/api/"
    
    init(userId: String, isPostTapped: Binding<Bool>, selectedPost: Binding<postResponse?>, friend: Friend) {
        self.userId = userId
        self._isPostTapped = isPostTapped
        self._selectedPost = selectedPost
        self.friend = friend
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Spacer()
                .frame(height: 16)
            HStack {
                Spacer()
                    .frame(width: decoSet.sideWidth)
                Text("\(friend.userName)の投稿一覧")
                Spacer()
            }
            Spacer()
                .frame(height: 16)
            Divider()
            
            if let posts = userPosts {
                let columns: [GridItem] = Array(repeating: .init(.fixed(decoSet.screenWidth / 3), spacing: 1.5, alignment: .leading), count: 3)
                LazyVGrid(columns: columns, spacing: 1.5) {
                    ForEach(posts, id: \.id) { post in
                        Button(action: {
                            isPostTapped = true
                            selectedPost = post
                        }, label: {
                            AlbumImageView(imageUrl: postImagePrefix + post.key)
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            fetchFriendsPostsData(completion: { posts in
                self.userPosts = posts
            }, friendId: userId)
        })
    }
}

struct AlbumImageView: View {
    @StateObject private var imageLoader: ImageLoader
    private var decoSet = DecorationSettings()
    
    init(imageUrl: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(imageUrl: imageUrl))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                .clipped()
        } else if imageLoader.isLoading {
            ProgressView()
                .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
        } else {
            Text("Image not available")
                .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
        }
    }
}
