//
//  MyPostSeason_TimeIconView.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/25.
//

import SwiftUI

struct MyPostSeason_TimeIconView: View {
    var post: MyPosts
    
    var body: some View {
        HStack {
            switch checkSeason(post: post) {
            case .Spring:
                Image("spring")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            case .Summer:
                Image("summer")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            case .Autumn:
                Image("autumn")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            case .Winter:
                Image("winter")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            case .All:
                Image("spring")
                    .resizable()
                    .frame(width: 30, height: 30)
                
            }
            
            Image(systemName: "line.diagonal")
                .resizable()
                .frame(width: 15, height: 30)
            
            switch checkTime(post: post) {
            case .Morning:
                Image(systemName:  "sun.and.horizon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            case .Noon:
                Image(systemName:  "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            case .Night:
                Image(systemName:  "moon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            case .All:
                Image(systemName: "clock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    func checkTime(post: MyPosts) -> Time {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: post.createdAt)
            let calendar = Calendar.current
            
        let hour = calendar.component(.hour, from: date!)
        
        if (5...11).contains(hour) {
            return .Morning
        } else if (12...17).contains(hour) {
            return .Noon
        } else {
            return .Night
        }
    }
    
    func checkSeason(post: MyPosts) -> Season {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: post.createdAt)
            let calendar = Calendar.current
        
        let month = calendar.component(.month, from: date!)
        
        if (3...5).contains(month) {
            return .Spring
        } else if (6...8).contains(month) {
            return .Summer
        } else if (9...11).contains(month) {
            return .Autumn
        } else {
            return .Winter
        }
    }
}

