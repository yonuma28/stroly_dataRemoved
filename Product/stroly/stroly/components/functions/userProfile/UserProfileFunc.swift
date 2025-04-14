//
//  UserProfileFunc.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/19.
//

import Foundation

func myPostCheckTime(post: MyPosts, time: Time) -> Bool {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    let date = dateFormatter.date(from: post.createdAt)
        let calendar = Calendar.current
        
    let hour = calendar.component(.hour, from: date!)
    
    switch time {
    case .Morning:
        return (5...11).contains(hour)
    case .Noon:
        return (12...17).contains(hour)
    case .Night:
        return (18...23).contains(hour) || (0...4).contains(hour)
    case .All:
        return true
    }
}

func myPostCheckSeason(post: MyPosts, season: Season) -> Bool {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    let date = dateFormatter.date(from: post.createdAt)
        let calendar = Calendar.current
    
    let month = calendar.component(.month, from: date!)
    
    switch season {
    case .Spring:
        return (3...5).contains(month)
    case .Summer:
        return (6...8).contains(month)
    case .Autumn:
        return (9...11).contains(month)
    case .Winter:
        return [1, 2, 12].contains(month)
    case .All:
        return true
    }
}
