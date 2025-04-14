//
//  SeasonAndTime.swift
//  stroly
//
//  Created by 大沼優希人 on 2024/01/06.
//

import SwiftUI
import Foundation
import CoreLocation

struct SeasonAndTime: View {
    @State private var season = Season.Spring
    @State private var time = Time.Morning
    @State private var isShowing = false
    @State private var showingAlert = false
    @State private var imageColor: UIColor? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sharedLocationManager: SharedLocationManager
    
    var locationManager = CLLocationManager()
    
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    var sharedData: SharedAnnotationData
    
    var body: some View {
        NavigationView {
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
                HStack {
                    Button(action: {
                        withAnimation {
                            season = .Spring
                        }
                    }, label: {
                        VStack {
                            SVGImage(name:"spring")
                                .imageColor(Color(season == .Spring ? 0xB6CC77 : 0x000000))
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("春")
                                .bold()
                                .foregroundColor(Color(season == .Spring ? 0xB6CC77 : 0x000000))
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                    Button(action: {
                        withAnimation {
                            season = .Summer
                        }
                    }, label: {
                        VStack {
                            SVGImage(name:"summer")
                                .imageColor(Color(season == .Summer ? 0xB6CC77 : 0x000000))
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("夏")
                                .bold()
                                .foregroundColor(Color(season == .Summer ? 0xB6CC77 : 0x000000))
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                    Button(action: {
                        withAnimation {
                            season = .Autumn
                        }
                    }, label: {
                        VStack {
                            SVGImage(name:"autumn")
                                .imageColor(Color(season == .Autumn ? 0xB6CC77 : 0x000000))
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("秋")
                                .bold()
                                .foregroundColor(Color(season == .Autumn ? 0xB6CC77 : 0x000000))
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                    Button(action: {
                        withAnimation {
                            season = .Winter
                        }
                    }, label: {
                        VStack {
                            SVGImage(name:"winter")
                                .imageColor(Color(season == .Winter ? 0xB6CC77 : 0x000000))
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("冬")
                                .bold()
                                .foregroundColor(Color(season == .Winter ? 0xB6CC77 : 0x000000))
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                }
                Spacer()
                HStack {
                    // 朝ボタン
                    Button(action: {
                        withAnimation {
                            time = .Morning
                        }
                    }, label: {
                        VStack {
                            Image(systemName:  "sun.and.horizon.fill")
                                .foregroundColor(time == .Morning ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 25))
                            Text("朝")
                                .bold()
                                .foregroundColor(time == .Morning ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                    Button(action: {
                        withAnimation {
                            time = .Noon
                        }
                    }, label: {
                        VStack {
                            Image(systemName:  "sun.max.fill")
                                .foregroundColor(time == .Noon ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 25))
                            Text("昼")
                                .bold()
                                .foregroundColor(time == .Noon ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                    Button(action: {
                        withAnimation {
                            time = .Night
                        }
                    }, label: {
                        VStack {
                            Image(systemName:  "moon.fill")
                                .foregroundColor(time == .Night ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 25))
                            Text("夜")
                                .bold()
                                .foregroundColor(time == .Night ? Color(0xB6CC77, alpha: 1.0) : Color.black)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal)
                    })
                }
                
                Divider()
                
                ScrollView {
                    VStack {
                        if sharedData.clusterAnnotations.isEmpty {
                            Text("写真が撮られていません")
                                .font(.system(size: 15))
                                .foregroundColor(Color.gray)
                        }
                        ForEach(sharedData.clusterAnnotations, id: \.self) { annotation in
                            
                            if checkSeason(annotation: annotation) {
                                if checkTime(annotation: annotation) {
                                    MapPostCard(annotation: annotation)
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }

    // アノテーションを表示するかどうかを判断する関数
    func checkSeason(annotation: CustomPointAnnotation) -> Bool {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: annotation.createdAt)
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
    func checkTime(annotation: CustomPointAnnotation) -> Bool {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        let date = dateFormatter.date(from: annotation.createdAt)
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
    // ISO8601の日付文字列から月、日、時間を抽出する関数
    func formattedDate(from isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime] // 時間も含めるためのオプション
        if let date = isoFormatter.date(from: isoDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM月dd日HH時mm分" // 日付と時間のフォーマット
            return dateFormatter.string(from: date)
        } else {
            return "日付不明"
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
