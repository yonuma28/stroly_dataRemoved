//
//  fetchFriendsPostsData.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import Foundation
import Alamofire

func fetchFriendsPostsData(completion: @escaping ([postResponse]) -> Void, friendId: String) {
    let userId = UserDefaults.standard.string(forKey: "userId")!
    let url = "https://backend.2xseitest.workers.dev/api/posts/friends?userId=\(userId)&friendId=\(friendId)"
    AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<[postResponse], AFError>) in
        switch response.result {
        case .success(let posts):
            print(posts)
            completion(posts)
        case .failure(let error):
            print(error)
        }
    })
}
