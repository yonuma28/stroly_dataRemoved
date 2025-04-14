//
//  AddFriends.swift
//  stroly
//
//  Created by 長濱聖英 on 2024/01/09.
//

import Foundation
import Alamofire
import UIKit
import SwiftData

struct friendResponse: Decodable {
    var friendId: String
    var userName: String
    var iconKey: String
}

struct Friend {
    var friendId: String
    var userName: String
    var icon: UIImage?
}

func addFrineds (frinedId: String)
{
    let userId = UserDefaults.standard.string(forKey: "userId")!
    print(frinedId)
    print(userId)
    let url = URL(string: "https://backend.2xseitest.workers.dev/api/friends/add")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let json: [String: Any] = ["userId": userId, "friendId": frinedId]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.httpBody = jsonData
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }
    }.resume()
    
}

func saveFriendsData(context: ModelContext)  {
    print("Saving Friends Data")
    let userId = UserDefaults.standard.string(forKey: "userId")!
    let url = "https://backend.2xseitest.workers.dev/api/friends?userId=" + userId
    AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<[friendResponse], AFError>) in
        switch response.result {
        case .success(let friend):
            for friend in friend {
                let friendItem = Friends(friendId: friend.friendId, userName: friend.userName, iconKey: friend.iconKey)
                context.insert(friendItem)
            }
            print("fetchFriendData: \(friend)")
            do {
                try context.save()
                let fetchDescriptor = FetchDescriptor<Friends>()
                let count = try context.fetchCount(fetchDescriptor)
                print("Saved \(count) Friends")
            } catch {
                print("Failed to save Friends: \(error)")
            }
        case .failure(let error):
            print(error)
        }
    })
    return 
}
