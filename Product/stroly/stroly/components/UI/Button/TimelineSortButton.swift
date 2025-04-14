//
//  SortButton.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import SwiftUI
import SwiftData
import CoreLocation

struct TimelineSortButton: View {
    @Binding var sortType: SortType
    @Binding var sortedPosts: [postResponse]?
    @Binding var timelinePosts: [postResponse]?
    
    private let decoSet = DecorationSettings()
    @State var canNotGetLocation: Bool = false
    
    private let locationManager = CLLocationManager()
    @State private var currentLocation: CLLocation? = nil
    
    
    var body: some View {
        if let posts = timelinePosts {
            var allPosts = posts
            VStack {
                Menu {
                    Button(action: {
                        sortType = .dateAscending
                        sortedPosts = allPosts
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
                        sortedPosts = allPosts
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
                        sortedPosts = allPosts
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
                            sortedPosts = allPosts
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
                        sortedPosts = allPosts
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
                            sortedPosts = allPosts
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
            }
            .alert(isPresented: $canNotGetLocation) {
                Alert(title: Text("位置情報が取得できませんでした。"))
            }
        }
    }
}
