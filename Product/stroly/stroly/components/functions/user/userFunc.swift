//
//  userFunc.swift
//  stroly
//
//  Created by 長濱聖英 on 2024/01/18.
//

import Foundation
import Alamofire
import UIKit

struct userResponse: Decodable {
    let name:  String
    let userId:    String
    let email:    String
    let iconKey:   String
    let numOfPosts: Int
    let numOfFriends: Int
    
}

// ユーザー情報をバックグランドで保存する関数
func saveUserData()  {
    print("Saving User Data")
    let baseURL = "https://backend.2xseitest.workers.dev/api/user?userId="
    let userId = UserDefaults.standard.string(forKey: "userId")!
    let url = baseURL + userId
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let pictureURL = documentsURL.appendingPathComponent("userIcon.jpeg")
    // ユーザー情報を取得
    AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<userResponse, AFError>) in
        switch response.result {
        case .success(let user):
            // ユーザー情報を保存
            UserDefaults.standard.set(user.name, forKey: "name")
            UserDefaults.standard.set(user.userId, forKey: "userId")
            UserDefaults.standard.set(user.email, forKey: "email")
            UserDefaults.standard.set(user.iconKey, forKey: "iconKey")
            UserDefaults.standard.set(user.numOfPosts, forKey: "numOfPosts")
            UserDefaults.standard.set(user.numOfFriends, forKey: "numOfFriends")
            let baseURL = "https://backend.2xseitest.workers.dev/api/"
            let imageUrl = baseURL + user.iconKey
            let url = URL(string: imageUrl)!
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                try! data.write(to: pictureURL)
            }.resume()
            print("User Data Saved")
        case .failure(let error):
            print("Failed to download user data: \(error)")
        }
    })
    
}
