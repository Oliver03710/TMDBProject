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
    
    typealias completionHandler = (ActorData, CrewData) -> Void
    
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
                
                let crewName = json["crew"].arrayValue.map { $0["name"].stringValue }
                let crewDepartment = json["crew"].arrayValue.map { $0["department"].stringValue }
                let crewProfile = json["crew"].arrayValue.map { $0["profile_path"].stringValue }
                    .map { "https://image.tmdb.org/t/p/original" + $0 }
                
                let data = ActorData(name: name, character: character, profile: profile)
                let crewData = CrewData(name: crewName, department: crewDepartment, profile: crewProfile)
//                print(data)
                completionHandler(data, crewData)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}





