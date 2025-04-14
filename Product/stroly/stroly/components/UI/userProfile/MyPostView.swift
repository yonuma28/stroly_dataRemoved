//
//  MyPostView.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/17.
//

import SwiftUI
import SwiftData
import Alamofire
import CoreLocation

struct MyPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @Binding var post: MyPosts?
    @Binding var postImage: UIImage?
    
    @ObservedObject var stampModel = StampModel()
    
    @Environment(\.modelContext) var context
    @Query var myPosts: [MyPosts]
    
    var locationManager = CLLocationManager()
    
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    struct deleteResponse: Decodable {
        let deleted: Bool
        let id: Int
    }
    
    var body: some View {
        if let post = post {
            ScrollView {
                // VStackを以下の書き方すると左揃えできる便利！
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 0) {
                            if let iconImage = loadImageIfNeeded(imageUrl: iconUrlPrefix + post.userId) {
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
                        Spacer()
                            .frame(width: 20)
                        VStack (alignment: .leading, spacing: 0){
                            Text("\(post.userName)")
                                .font(.headline)
                        }
                        Spacer()
                        MyPostSeason_TimeIconView(post: post)
                        Menu {
                            Button(action: {
                                showingAlert = true
                                print("Deleteボタンが押されました")
                            }) {
                                Text("削除する")
                                    .font(.headline)
                                    .background(Color.pink)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } label: {
                            Image(systemName:"ellipsis")
                                .padding()
                                .foregroundColor(.gray)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("確認"),
                                message: Text("本当に削除しますか？"),
                                primaryButton: .destructive(Text("削除")) {
                                    deletePost(post: post)
                                    dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .imageScale(.small)
                                .foregroundColor(.white)
                        }
                        .frame(width: 30, height: 30)  // ボタンのサイズを設定
                        .background(Color.gray)  // ボタンの背景色
                        .clipShape(Circle())  // ボタンを丸形にする
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)  // ボタンの枠線
                        )
                    }
                    if let image = postImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            if post.title == "" {
                                Text("タイトルなし")
                                    .font(.headline)
                            } else {
                                Text("\(post.title )")
                                    .font(.headline)
                            }
                            if let location = locationManager.location {
                                let distance = location.distance(from: CLLocation(latitude: post.latitude, longitude: post.longitude))
                                if distance < 1000 {
                                    Text("約\(String(format: "%.0f", distance))m先")
                                        .font(.caption)
                                } else {
                                    Text("約\(String(format: "%.2f", Double(distance / 1000)))km先")
                                        .font(.caption)
                                }
                            } else {
                                Text("位置情報が取得できませんでした")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        Text("\(formattedDate(from: post.createdAt))")
                            .font(.caption)
                    }
                    StampButton(stampModel: stampModel, postId: post.id)
                }
                .background(Color.white)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .onAppear() {
                    stampModel.fetchStamps(postId: post.id)
                }
            }
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
    
    func deletePost(post: MyPosts) {
        let serverUrl = "https://backend.2xseitest.workers.dev/api/post?postId=\(post.id)"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pictureURL = documentsURL.appendingPathComponent(post.key)
        
        AF.request(serverUrl, method: .delete, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<deleteResponse, AFError>) in
            switch response.result {
            case .success(let post):
                print("deletePost: \(post)")
                context.delete(myPosts.first(where: { $0.id == post.id })!)
                do {
                    try context.save()
                } catch {
                    print("swiftData削除失敗しとるやん")
                }
                do {
                    try FileManager.default.removeItem(at: pictureURL)
                } catch {
                    print("ドキュディレ削除失敗しとるやん")
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
