//
//  AlbumView.swift
//  stroly
//
//  Created by 大坪雄也 on 2023/12/12.
//

//import SwiftUI
//
//struct AlbumView: View {
//    var body: some View {
//        Text("World!")
//    }
//}
//
//#Preview {
//    AlbumView()
//}

import SwiftUI
import SwiftData
import CoreLocation

// sortの種類はenumで管理
enum SortType {
    case dateAscending
    case dateDescending
    case distanceAscending
    case distanceDescending
}

enum FilterType {
    case season
    case time
    case postStatus
    case user
    case all
}

struct AlbumView: View {
    private let decoSet = DecorationSettings()
    @Environment(\.modelContext) private var context
    @Query private var myPosts: [MyPosts]
    @Binding var isPostTapped: Bool
    @Binding var selectedPost: MyPosts?
    @Binding var selectedImage: UIImage?
    @State private var sortedPosts: [MyPosts]? = nil
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @State private var sortType: SortType = .dateAscending
    @State private var filterType: FilterType = .all
    @State private var canNotGetLocation: Bool = false
    
    private let locationManager = CLLocationManager()
    @State private var currentLocation: CLLocation? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 12)
            // 写真一覧表示
            HStack {
                Spacer()
                    .frame(width: decoSet.sideWidth)
                Text("あなたの投稿一覧")
                    .foregroundColor(.black)
                Spacer()
                // 絞り込みボタン
                Menu {
                    Button(action: {
                        filterType = .all
                    }, label: {
                        Text("すべて")
                    })
                    Button(action: {
                        filterType = .season
                    }, label: {
                        Text("季節")
                    })
                    Button(action: {
                        filterType = .time
                    }, label: {
                        Text("時間")
                    })
                    Button(action: {
                        filterType = .postStatus
                    }, label: {
                        Text("投稿設定")
                    })
                } label: {
                    VStack {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.gray)
                            .opacity(decoSet.opacity)
                        Text("カテゴリ")
                            .foregroundColor(.gray)
                            .opacity(decoSet.opacity)
                            .font(.caption)
                    }
                }
                Spacer()
                    .frame(width: 16)
                
                // sortボタン
                Menu {
                    Button(action: {
                        sortType = .dateAscending
                        sortedPosts = myPosts
                        sortedPosts!.sort(by: { (a, b) -> Bool in
                            if a.createdAt > b.createdAt {
                                return true
                            } else {
                                return false
                            }
                        })
                    }, label: {
                        if sortType == .dateAscending {
                            Image(systemName: "checkmark")
                        }
                        Text("新しい順")
                    })
                    Button(action: {
                        sortType = .dateDescending
                        sortedPosts = myPosts
                        sortedPosts!.sort(by: { (a, b) -> Bool in
                            if a.createdAt < b.createdAt {
                                return true
                            } else {
                                return false
                            }
                        })
                    }, label: {
                        if sortType == .dateDescending {
                            Image(systemName: "checkmark")
                        }
                        Text("古い順")
                    })
                    Button(action: {
                        sortType = .distanceAscending
                        sortedPosts = myPosts
                        currentLocation = locationManager.location
                        sortedPosts!.sort(by: { (a, b) -> Bool in
                            let aCoordinate = CLLocation(latitude: a.latitude, longitude: a.longitude)
                            let bCoordinate = CLLocation(latitude: b.latitude, longitude: b.longitude)
                            if let currentLocation = currentLocation {
                                if currentLocation.distance(from: aCoordinate) < currentLocation.distance(from: bCoordinate) {
                                    return true
                                } else {
                                    return false
                                }
                            } else {
                                canNotGetLocation = true
                                return false
                            }
                        })
                        if canNotGetLocation == true {
                            sortedPosts = myPosts
                        }
                        print("sortedPosts.count: \(sortedPosts!.count)")
                    }, label: {
                        if sortType == .distanceAscending {
                            Image(systemName: "checkmark")
                        }
                        Text("ここから近い順")
                    })
                    Button(action: {
                        sortType = .distanceDescending
                        sortedPosts = myPosts
                        currentLocation = locationManager.location
                        sortedPosts!.sort(by: { (a, b) -> Bool in
                            let aCoordinate = CLLocation(latitude: a.latitude, longitude: a.longitude)
                            let bCoordinate = CLLocation(latitude: b.latitude, longitude: b.longitude)
                            if let currentLocation = currentLocation {
                                if currentLocation.distance(from: aCoordinate) > currentLocation.distance(from: bCoordinate) {
                                    return true
                                } else {
                                    return false
                                }
                            } else {
                                canNotGetLocation = true
                                return false
                            }
                        })
                        if canNotGetLocation == true {
                            sortedPosts = myPosts
                        }
                    }, label: {
                        if sortType == .distanceDescending {
                            Image(systemName: "checkmark")
                        }
                        Text("ここから遠い順")
                    })
                } label: {
                    VStack {
                        switch sortType {
                        case .dateAscending:
                            Image(systemName: "arrow.down")
                                .foregroundColor(.gray)
                                .opacity(decoSet.opacity)
                        case .dateDescending:
                            Image(systemName: "arrow.up")
                                .foregroundColor(.gray)
                                .opacity(decoSet.opacity)
                        case .distanceAscending:
                            Image(systemName: "figure.walk")
                                .foregroundColor(.gray)
                                .opacity(decoSet.opacity)
                        case .distanceDescending:
                            Image(systemName: "car.side")
                                .foregroundColor(.gray)
                                .opacity(decoSet.opacity)
                        }
                        Text("並び替え")
                            .foregroundColor(.gray)
                            .opacity(decoSet.opacity)
                            .font(.caption)
                    }
                }
                Spacer()
                    .frame(width: decoSet.sideWidth)
            }
            .alert(isPresented: $canNotGetLocation) {
                Alert(title: Text("位置情報が取得できませんでした。"))
            }

            Spacer()
                .frame(height: 12)
            Divider()
            
            let columns: [GridItem] = Array(repeating: .init(.fixed(decoSet.screenWidth / 3), spacing: 1.5, alignment: .leading), count: 3)
            
            switch filterType {
            case .all, .user:
                LazyVGrid(columns: columns, spacing: 1.5) {
                    ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                        Button(action: {
                            isPostTapped = true
                            selectedPost = post
                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                        }, label: {
                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                    .clipped()
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                            }
                        })
                    }
                }
            case .season:
                VStack {
                    Spacer()
                    if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckSeason(post: $0, season: .Spring)})) != nil) || (myPosts.first(where: { myPostCheckSeason(post: $0, season: .Spring)}) != nil) {
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image("spring")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("春")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckSeason(post: post, season: .Spring) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckSeason(post: $0, season: .Summer)})) != nil) || (myPosts.first(where: { myPostCheckSeason(post: $0, season: .Summer)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image("summer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                    Text("夏")
                                        .font(.caption)
                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckSeason(post: post, season: .Summer) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckSeason(post: $0, season: .Autumn)})) != nil) || (myPosts.first(where: { myPostCheckSeason(post: $0, season: .Autumn)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image("autumn")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("秋")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckSeason(post: post, season: .Autumn) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckSeason(post: $0, season: .Winter)})) != nil) || (myPosts.first(where: { myPostCheckSeason(post: $0, season: .Winter)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image("winter")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("冬")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckSeason(post: post, season: .Winter) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            case .time:
                VStack {
                    Spacer()
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckTime(post: $0, time: .Morning)})) != nil) || (myPosts.first(where: { myPostCheckTime(post: $0, time: .Morning)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName: "sun.and.horizon.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("朝")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckTime(post: post, time: .Morning) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckTime(post: $0, time: .Noon)})) != nil) || (myPosts.first(where: { myPostCheckTime(post: $0, time: .Noon)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName:  "sun.max.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("昼")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckTime(post: post, time: .Noon) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { myPostCheckTime(post: $0, time: .Night)})) != nil) || (myPosts.first(where: { myPostCheckTime(post: $0, time: .Night)}) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName:  "moon.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("夜")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if myPostCheckTime(post: post, time: .Night) {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            case .postStatus:
                VStack {
                    Spacer()
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { $0.isPublic == true })) != nil) || (myPosts.first(where: { $0.isPublic == true }) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName: "globe")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("パブリック")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if post.isPublic {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { $0.isFriendsOnly == true })) != nil) || (myPosts.first(where: { $0.isFriendsOnly == true }) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName: "person.2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("フレンド")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if post.isFriendsOnly {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        if sortedPosts != nil && ((sortedPosts?.first(where: { $0.isPrivate == true })) != nil) || (myPosts.first(where: { $0.isPrivate == true }) != nil) {
                            HStack {
                                Spacer()
                                    .frame(width: decoSet.sideWidth)
                                VStack{
                                    Image(systemName: "lock")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
//                                    Text("プライベート")
//                                        .font(.caption)
//                                        .bold()
                                }
                                Spacer()
                            }
                            LazyVGrid(columns: columns, spacing: 1.5) {
                                ForEach(sortedPosts ?? myPosts, id: \.id) {post in
                                    if post.isPrivate {
                                        Button(action: {
                                            isPostTapped = true
                                            selectedPost = post
                                            selectedImage = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key))
                                        }, label: {
                                            if let image = convertURLToImage(iconURL: documentsURL.appendingPathComponent(post.key)) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: decoSet.screenWidth / 3, height: decoSet.screenWidth / 3)
                                                    .clipped()
                                            } else {
                                                Image(systemName: "photo")
                                                    .resizable()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        })
    }
}
