//
//  MapPostCard.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/25.
//

import SwiftUI
import CoreLocation

struct MapPostCard: View {
    
    var annotation: CustomPointAnnotation
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    var locationManager = CLLocationManager()
    
    @ObservedObject var stampModel = StampModel()
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                VStack(alignment: .leading, spacing: 0) {
                    if let iconImage = loadImageIfNeeded(imageUrl: iconUrlPrefix + annotation.userId) {
                        Image(uiImage: iconImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
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
                            .frame(width: 60, height: 60)
                    }
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("\(annotation.userName)")
                        .font(.headline)
                }
                Spacer()
                let season = judgeSeason(annotation: annotation)
                switch season {
                case .Spring:
                    Image("spring")
                        .resizable()
                        .frame(width: 30, height: 30)
                case .Summer:
                    Image("summer")
                        .resizable()
                        .frame(width: 30, height: 30)
                case .Autumn:
                    Image("autumn")
                        .resizable()
                        .frame(width: 30, height: 30)
                case .Winter:
                    Image("winter")
                        .resizable()
                        .frame(width: 30, height: 30)
                case .All:
                    Image("spring")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text("/")
                    .font(.system(size: 30))
                
                let time = judgeTime(annotation: annotation)
                switch time {
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
            // 画像を表示
            CustomImageView(imageUrl: annotation.imageUrl)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(annotation.title ?? "タイトルなし")")
                        .font(.headline)
                    if let location = locationManager.location {
                        let distance = location.distance(from: CLLocation(latitude: annotation.latitude, longitude: annotation.longitude))
                        if distance < 1000 {
                            Text("約\(String(format: "%.0f", distance))m先")
                                .font(.caption)
                        } else {
                            Text("約\(String(format: "%.2f", Double(distance / 1000)))km先")
                                .font(.caption)
                        }
                    } else {
                        Text("位置情報を取得できません")
                            .font(.caption)
                    }
                }
                Spacer()
                Text("\(formattedDate(from: annotation.createdAt))")
                    .font(.caption)
            }
            PostCardStampButton(stampModel: stampModel, postId:annotation.postId)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 30)
            .stroke(Color.black, lineWidth: 0.5))
        .padding(.horizontal)
        .padding(.bottom, 11)
        .padding(.top, 5)
        .onAppear() {
            stampModel.fetchStamps(postId: annotation.postId)
        }
    }
    
    func judgeSeason(annotation: CustomPointAnnotation) -> Season {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: annotation.createdAt)
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
    
    func judgeTime(annotation: CustomPointAnnotation) -> Time {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: annotation.createdAt)
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
}
