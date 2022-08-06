//
//  SearchingCastManager.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class SearchingCastManager {
    
    private init() { }
    
    static let shared = SearchingCastManager()
    
    typealias completionHandler = (ActorData) -> Void
    
    func fetchingActorData(movieID: Int, completionHandler: @escaping completionHandler) {
        
        let url = EndPoint.TMDBUrl + "\(MediaType.movie.rawValue)/\(movieID)/credits?api_key=\(APIKey.TMDB.rawValue)&language=en-US"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")

                let name = json["cast"].arrayValue.map { $0["name"].stringValue }
                let character = json["cast"].arrayValue.map { $0["character"].stringValue }
                let profile = json["cast"].arrayValue.map { $0["profile_path"].stringValue }
                    .map { "https://image.tmdb.org/t/p/original" + $0 }
                
                let data = ActorData(name: name, character: character, profile: profile)
                print(data)
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}





