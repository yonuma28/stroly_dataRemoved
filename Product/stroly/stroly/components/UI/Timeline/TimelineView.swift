//
//  TimelineView.swift
//  stroly
//
//  Created by 大坪雄也 on 2023/12/15.
//

// 参考URL : https://d1v1b.com/swiftui/twitter_home_menu (タイムライン表示の参考)
//          https://swifty-ui.com/pull-to-refresh/ (pull to refreshの参考)

import SwiftUI
import SwiftData
import CoreLocation

struct TimelineView: View {
    let decoSet = DecorationSettings()
    
    @State private var isGoToMap = false
    @State private var selectedPost: postResponse?
    @State private var postImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    @Query var friends: [Friends]
    @State private var selectedFriend: Friend = Friend(friendId: "", userName: "", icon: nil)
    @State private var isFriendTapped: Bool = false
    @State private var isShowingAlert = false

    @State private var timelinePosts: [postResponse]?
    @State private var sortedPosts: [postResponse]?

    private let locationManager = CLLocationManager()
    
    @State private var sortType: SortType = .dateAscending
    @State private var filterType: FilterType = .all
    
    @State private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var body: some View {
        NavigationStack {
            if let _ = timelinePosts {
                VStack {
                    Spacer()
                        .frame(height: 12)
                    HStack {
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                        Text("タイムライン")
                            .foregroundColor(.black)
                            .font(.title2)
                            .fontWeight(.bold)
                        Button(action: {
                            isShowingAlert = true
                        }, label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .foregroundColor(Color(0xB6CC77, alpha: 1.0))
                                .frame(width: 25, height: 25)
                        })
                        .alert(isPresented: $isShowingAlert) {
                            Alert(title: Text("タイムラインについて"), message: Text("現在地から半径400m以内の投稿が表示されます！"), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                        // 絞り込みボタン
                        TimelineFilterButton(filterType: $filterType, sortedPosts: $sortedPosts, timelinePosts: $timelinePosts)
                        Spacer()
                            .frame(width: 16)
                            .foregroundColor(.black)
                        // sortボタン
                        TimelineSortButton(sortType: $sortType, sortedPosts: $sortedPosts, timelinePosts: $timelinePosts)
                        Spacer()
                            .frame(width: decoSet.sideWidth)
                            .foregroundColor(.black)
                    }
                    
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        LazyVStack{
                            ForEach (sortedPosts ?? timelinePosts!, id: \.id) { post in
                                if let location = locationManager.location {
                                    if location.distance(from: CLLocation(latitude: post.latitude, longitude: post.longitude)) < 400 {
                                        PostsCardView(post: post, isFriendTapped: $isFriendTapped, selectedFriend: $selectedFriend)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            NavigationLink(destination: FriendProfileView(friend: selectedFriend), isActive: $isFriendTapped) {
                EmptyView()
            }
        }
        .onAppear() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                self.currentLocation = location.coordinate
                print("(\(currentLocation.latitude), \(currentLocation.longitude))")
            } else {
                print("cannot get currentLocation")
                self.currentLocation = CLLocationCoordinate2D(latitude: 35.68154, longitude: 139.752498)
            }
            fetchTimelinePostsData(completion: { posts in
                self.timelinePosts = posts
            }, location: currentLocation)
        }
    }
    
    @ViewBuilder
    func LoadingView(title: String) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                ProgressView(title)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            )
    }
}
