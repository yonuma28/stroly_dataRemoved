//
//  FilterButton.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import SwiftUI
import SwiftData

struct FilterButton: View {
    @Binding var filterType: FilterType
    @Binding var sortedPosts: [MyPosts]?
    
    @State private var selectedSeason: Season = .All
    @State private var selectedTime: Time = .All
    
    private let decoSet = DecorationSettings()
    
    @Environment(\.modelContext) private var context
    @Query private var myPosts: [MyPosts]
    
    
    var body: some View {
        VStack {
            Menu {
                Button(action: {
                    filterType = .all
                    sortedPosts = myPosts
                }, label: {
                    if filterType == .all {
                        Image(systemName: "checkmark")
                    }
                    Text("すべて")
                })
                
                // 季節の部分
                Menu {
                    Button(action: {
                        filterType = .season
                        selectedSeason = .All
                        sortedPosts = myPosts
                    }, label: {
                        Text("すべて")
                        if selectedSeason == .All {
                            Image(systemName: "checkmark")
                        } else {
                            //ここを全部っぽいイメージにしてほしい
                            Image("spring")
                        }
                    })
                    Button(action: {
                        filterType = .season
                        selectedSeason = .Spring
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckSeason(post: post, season: .Spring)
                        })
                    }, label: {
                        Text("春")
                        if selectedSeason == .Spring {
                            Image(systemName: "checkmark")
                        } else {
                            Image("spring")
                        }
                    })
                    Button(action: {
                        filterType = .season
                        selectedSeason = .Summer
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckSeason(post: post, season: .Summer)
                        })
                    }, label: {
                        Text("夏")
                        if selectedSeason == .Summer {
                            Image(systemName: "checkmark")
                        } else {
                            Image("summer")
                        }
                    })
                    Button(action: {
                        filterType = .season
                        selectedSeason = .Autumn
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckSeason(post: post, season: .Autumn)
                        })
                    }, label: {
                        Text("秋")
                        if selectedSeason == .Autumn {
                            Image(systemName: "checkmark")
                        } else {
                            Image("autumn")
                        }
                    })
                    Button(action: {
                        filterType = .season
                        selectedSeason = .Winter
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckSeason(post: post, season: .Winter)
                        })
                    }, label: {
                        Text("冬")
                        if selectedSeason == .Winter {
                            Image(systemName: "checkmark")
                        } else {
                            Image("winter")
                        }
                    })
                } label: {
                    Text("季節")
                    Image("checkmark")
                }
                
                // 時間の部分
                Menu {
                    Button(action: {
                        filterType = .time
                        selectedTime = .All
                        sortedPosts = myPosts
                    }, label: {
                        Text("すべて")
                        if selectedTime == .All {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName:  "clock.fill")
                        }
                    })
                    Button(action: {
                        filterType = .time
                        selectedTime = .Morning
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckTime(post: post, time: .Morning)
                        })
                    }, label: {
                        Text("朝")
                        if selectedTime == .Morning {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName:  "sun.and.horizon.fill")
                        }
                    })
                    Button(action: {
                        filterType = .time
                        selectedTime = .Noon
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckTime(post: post, time: .Noon)
                        })
                    }, label: {
                        Text("昼")
                        if selectedTime == .Noon {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName:  "sun.max.fill")
                        }
                    })
                    Button(action: {
                        filterType = .time
                        selectedTime = .Night
                        sortedPosts = myPosts.filter({ (post) -> Bool in
                            return myPostCheckTime(post: post, time: .Night)
                        })
                    }, label: {
                        Text("夜")
                        if selectedTime == .Night {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName:  "moon.fill")
                        }
                    })
                } label: {
                    Text("時間")
                }
                
                Button(action: {
                    filterType = .postStatus
                }, label: {
                    if filterType == .postStatus {
                        Image(systemName: "checkmark")
                    }
                    Text("投稿範囲")
                })
            } label: {
                VStack {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.gray)
                        .opacity(decoSet.opacity)
                    Text("絞り込み")
                        .foregroundColor(.gray)
                        .opacity(decoSet.opacity)
                        .font(.caption)
                }
            }
        }
        .frame(width: 100, height: 100)
    }
}
