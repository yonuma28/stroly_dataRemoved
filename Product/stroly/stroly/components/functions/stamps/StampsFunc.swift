//
//  StampsFunc.swift
//  stroly
//
//  Created by 長濱聖英 on 2024/01/25.
//

import Foundation
import Alamofire

struct stampsData : Codable {
    let stampId: Int
    let numOfStamps: Int
}

struct PostsDataWithStamps : Codable {
    let postId: Int
    var stamps: [stampsData]
    let stampedId: Int
}

func addStamps (userId: String, postId: Int, stampId: Int, completion: @escaping (PostsDataWithStamps) -> Void) {
    let url = "https://backend.2xseitest.workers.dev/api/stamps?userId=\(userId)&postId=\(postId)&stampId=\(stampId)"
    AF.request(url, method: .post, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<PostsDataWithStamps, AFError>) in
        switch response.result {
        case .success(let result):
            completion(result)
            print(result)
        case .failure(let error):
            print(response)
            print(error)
        }
    })
}
func deleteStamps (userId: String, postId: Int, stampId: Int, completion: @escaping (PostsDataWithStamps) -> Void) {
    let url = "https://backend.2xseitest.workers.dev/api/stamps?userId=\(userId)&postId=\(postId)&stampId=\(stampId)"
    AF.request(url, method: .delete, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<PostsDataWithStamps, AFError>) in
        switch response.result {
        case .success(let result):
            completion(result)
            print(result)
        case .failure(let error):
            print(response)
            print(error)
        }
    })
}

func fetchStamps (userId: String, postId: Int, completion: @escaping (PostsDataWithStamps) -> Void) {
    let url = "https://backend.2xseitest.workers.dev/api/stamps?userId=\(userId)&postId=\(postId)"
    AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<PostsDataWithStamps, AFError>) in
        switch response.result {
        case .success(let result):
            completion(result)
            print(result)
        case .failure(let error):
            print(response)
            print(error)
        }
    })
}


class StampModel: ObservableObject {
    @Published var tappedStamp: Int = 0
    @Published var numberOfGood: Int = 0
    @Published var numberOfFire: Int = 0
    @Published var numberOfHeart: Int = 0
    @Published var numberOfCracker: Int = 0
    
    let userId = UserDefaults.standard.string(forKey: "userId")!
    
    func fetchStamps(postId: Int) {
        stroly.fetchStamps(userId: userId, postId: postId, completion: { result in
            self.numberOfGood = result.stamps[0].numOfStamps
            self.numberOfFire = result.stamps[1].numOfStamps
            self.numberOfHeart = result.stamps[2].numOfStamps
            self.numberOfCracker = result.stamps[3].numOfStamps
            self.tappedStamp = result.stampedId
        })
    }
    
    func addStamps(postId: Int, stampId: Int) {
        stroly.addStamps(userId: userId, postId: postId, stampId: stampId, completion: { result in
            self.numberOfGood = result.stamps[0].numOfStamps
            self.numberOfFire = result.stamps[1].numOfStamps
            self.numberOfHeart = result.stamps[2].numOfStamps
            self.numberOfCracker = result.stamps[3].numOfStamps
            self.tappedStamp = result.stampedId
        })
    }
    
    func deleteStamps(postId: Int, stampId: Int) {
        stroly.deleteStamps(userId: userId, postId: postId, stampId: stampId, completion: { result in
            self.numberOfGood = result.stamps[0].numOfStamps
            self.numberOfFire = result.stamps[1].numOfStamps
            self.numberOfHeart = result.stamps[2].numOfStamps
            self.numberOfCracker = result.stamps[3].numOfStamps
            self.tappedStamp = result.stampedId
        })
    }
    
}
