//
//  Posts.swift
//  stroly
//
//  Created by 長濱聖英 on 2023/12/01.
//

import SwiftData

@Model
final class MyPosts {
    @Attribute(.unique) var id: Int
    let userName: String
    let userId: String
    var title: String
    var key: String
    var createdAt: String
    var latitude: Double
    var longitude: Double
    var isPublic: Bool
    var isFriendsOnly: Bool
    var isPrivate: Bool = false
    init(id: Int, userId: String, title: String, key: String, createdAt: String, latitude: Double, longitude: Double, isPublic: Bool, isFriendsOnly: Bool, userName: String, isPrivate: Bool) {
        self.id = id
        self.userName = userName
        self.userId = userId
        self.title = title
        self.key = key
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
        self.isPublic = isPublic
        self.isFriendsOnly = isFriendsOnly
        self.isPrivate = isPrivate
    }
    
    init(postResponse: postResponse) {
        self.id = postResponse.id
        self.userName = postResponse.userName
        self.userId = postResponse.userId
        self.title = postResponse.title
        self.key = postResponse.key
        self.createdAt = postResponse.createdAt
        self.latitude = postResponse.latitude
        self.longitude = postResponse.longitude
        self.isPublic = postResponse.isPublic
        self.isFriendsOnly = postResponse.isFriendsOnly
        self.isPrivate = postResponse.isPrivate
    }
}
