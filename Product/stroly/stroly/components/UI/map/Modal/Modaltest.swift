//
//  Modaltest.swift
//  stroly
//
//  Created by 大沼優希人 on 2023/12/21.
//

import SwiftUI
import Foundation
import CoreLocation

class SharedLocationManager: ObservableObject {
    @Published var selectedLocation: CLLocationCoordinate2D?
}
extension Notification.Name {
    static let coordinateUpdated = Notification.Name("coordinateUpdated")
}


enum Season {
    case Spring
    case Summer
    case Autumn
    case Winter
    case All
}

enum Time {
    case Morning
    case Noon
    case Night
    case All
}

// １つのピンがタップされた時のモーダル
struct AnnotationModalView: View {
    @ObservedObject var sharedData: SharedAnnotationData
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    let imageUrlPrefix = "https://backend.2xseitest.workers.dev/api/"
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    var locationManager = CLLocationManager()
    
    @ObservedObject var stampModel = StampModel()

    var body: some View {
        ScrollView {
            if let annotation = sharedData.selectedAnnotation {
                // VStackを以下の書き方すると左揃えできる便利！
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
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
                        Spacer()
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 0){
                            Text("\(annotation.userName )")
                                .font(.headline)
                        }
                        Spacer()
                        let season = checkSeason(annotation: annotation)
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
                        
                        let time = checkTime(annotation: annotation)
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
                        Spacer()
                            .frame(width: 10)
                            
                    }
                    
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
                    StampButton(stampModel: stampModel, postId: annotation.postId)
                }
                .background(Color.white)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .onAppear(){
                    print("userId: \(annotation.userId)")
                    print("icon: \(iconUrlPrefix + annotation.userId)")
                    stampModel.fetchStamps(postId: annotation.postId)
                }
            }
        }
    }
    
    func checkSeason(annotation: CustomPointAnnotation) -> Season {
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
    
    func checkTime(annotation: CustomPointAnnotation) -> Time {
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

// クラスタリングされたピンがタップされた時のモーダル
struct ClusterAnnotationModalView: View {
    @ObservedObject var sharedData: SharedAnnotationData
    @EnvironmentObject var sharedLocationManager: SharedLocationManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var isNavigating = false
    let iconUrlPrefix = "https://backend.2xseitest.workers.dev/api/user/icon?userId="
    
    var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                ZStack{
                    NavigationLink(destination: SeasonAndTime(sharedData: sharedData), isActive: $isNavigating) {
                        EmptyView()
                    }
                    .hidden()
                    // ページ遷移ボタン
                    Spacer()
                    Button {
                        isNavigating = true
                    } label: {
                        Text("季節・時間帯別で見る")
                            .font(.headline)
                            .padding()
                            .background(Color(hue: 80 / 360, saturation: 1.0, brightness: 0.596))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    HStack{
                        Spacer()
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
                        .padding(.horizontal, 10)
                    }
                }
                Spacer()
                Divider()
                Spacer()
                ScrollView {
                    if sharedData.clusterAnnotations.isEmpty {
                        Text("表示できる画像がありません")
                    } else {
                        VStack {
                            ForEach(sharedData.clusterAnnotations, id: \.id) { annotation in
                                MapPostCard(annotation: annotation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkSeason(annotation: CustomPointAnnotation) -> Season {
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
    
    func checkTime(annotation: CustomPointAnnotation) -> Time {
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

struct CustomImageView: View {
    @StateObject private var imageLoader: ImageLoader
    
    init(imageUrl: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(imageUrl: imageUrl))
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if imageLoader.isLoading {
            ProgressView()
                .frame(width: 50, height: 50)
        } else {
            Text("Image not available")
                .frame(width: 50, height: 50)
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
        @Published var isLoading = false
        var imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        loadImage()
    }
    
    func loadImage() {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let hashValue = imageUrl.hash
        let fileURL = cacheDirectory.appendingPathComponent("\(hashValue)")
        
        // ディスクキャッシュから画像を読み込む
        if let diskCachedImage = UIImage(contentsOfFile: fileURL.path) {
            print("キャッシュから読み込みました")
            DispatchQueue.main.async {
                self.image = diskCachedImage
            }
        } else {
            // キャッシュにない場合はダウンロード
            print("ダウンロードしました")
            guard let url = URL(string: imageUrl) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                        self.isLoading = false
                    }
                    try? data.write(to: fileURL, options: [.atomicWrite])
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
            task.resume()
        }
    }
}
