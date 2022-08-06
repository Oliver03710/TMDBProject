//
//  SearchingMovieManager.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class SearchingMovieManager {
    
    private init() { }
    
    static let shared = SearchingMovieManager()
    
    typealias completionHandler = (Int, [MovieData]) -> Void
    
    func fetchMovieData(startPage: Int, completionHandler: @escaping completionHandler) {
        
        let url = EndPoint.TMDBUrl + "trending/\(MediaType.movie.rawValue)/\(TimeWindow.day.rawValue)?api_key=\(APIKey.TMDB.rawValue)&page=\(startPage)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let counts = json["total_results"].intValue
                let title = json["results"].arrayValue.map { $0["title"].stringValue }
                let mainImage = json["results"].arrayValue.map { $0["poster_path"].stringValue }
                    .map { "https://image.tmdb.org/t/p/original" + $0 }
                let backImage = json["results"].arrayValue.map { $0["backdrop_path"].stringValue }
                    .map { "https://image.tmdb.org/t/p/original" + $0 }
                let releaseDate = json["results"].arrayValue.map { $0["release_date"].stringValue }
                let vote = json["results"].arrayValue.map { $0["vote_average"].doubleValue }
                let genre = json["results"].arrayValue.map { $0["genre_ids"][0].intValue }
                let movieId = json["results"].arrayValue.map { $0["id"].intValue }
                let overView = json["results"].arrayValue.map { $0["overview"].stringValue }
                
                var data: [MovieData] = []
                
                for i in 0..<title.count {
                    data.append(MovieData(title: title[i], mainImage: mainImage[i], backImage: backImage[i], releaseDate: releaseDate[i], vote: vote[i], movieId: movieId[i], genre: genre[i], overView: overView[i]))
                }
                
                completionHandler(counts, data)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
