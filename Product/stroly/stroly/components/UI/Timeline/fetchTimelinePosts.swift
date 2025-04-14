//
//  getPostForTimeline.swift
//
//  fetchFriendsPostsData.swift
//  stroly
//
//  Created by 大坪雄也 on 2024/01/20.
//

import Foundation
import Alamofire
import CoreLocation

func fetchTimelinePostsData(completion: @escaping ([postResponse]) -> Void, location: CLLocationCoordinate2D) {
    let latitude: Double = location.latitude
    let longitude: Double = location.longitude
    let url = "https://backend.2xseitest.workers.dev/api/posts/location?latitude=\(latitude)&longitude=\(longitude)"
    AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(completionHandler: { (response: DataResponse<[postResponse], AFError>) in
        switch response.result {
        case .success(let posts):
            completion(posts)
        case .failure(let error):
            print(error)
        }
    })
}
