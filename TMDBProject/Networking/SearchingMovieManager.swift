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
    
    func fetchSecondMovieData(startPage: Int, completionHandler: @escaping ([SecondMovieData], [[SimilarMovies]]) -> ()) {
        
        let url = EndPoint.TMDBUrl + "trending/\(MediaType.movie.rawValue)/\(TimeWindow.day.rawValue)?api_key=\(APIKey.TMDB.rawValue)&page=\(startPage)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let movieArr = json["results"].arrayValue.shuffled()[0..<5]
                let title = movieArr.map { $0["title"].stringValue }
                let movieId = movieArr.map { $0["id"].intValue }
               
                var data: [SecondMovieData] = []
                
                for i in 0..<title.count {
                    
                    data.append(SecondMovieData(title: title[i], movieId: movieId[i]))
                }
                
                var similarMoviePosters: [[SimilarMovies]] = []
                
                self.fetchSimilarMovieData(startPage: startPage, movieID: movieId[0]) { movie in
                    similarMoviePosters.append(movie)

                    self.fetchSimilarMovieData(startPage: startPage, movieID: movieId[1]) { movie in
                        similarMoviePosters.append(movie)
                        
                        self.fetchSimilarMovieData(startPage: startPage, movieID: movieId[2]) { movie in
                            similarMoviePosters.append(movie)
                            
                            self.fetchSimilarMovieData(startPage: startPage, movieID: movieId[3]) { movie in
                                similarMoviePosters.append(movie)
                                
                                self.fetchSimilarMovieData(startPage: startPage, movieID: movieId[4]) { movie in
                                    similarMoviePosters.append(movie)
                                    
                                    completionHandler(data, similarMoviePosters)
                                }
                            }
                        }
                    }
                    
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSimilarMovieData(startPage: Int, movieID: Int, completionHandler: @escaping ([SimilarMovies]) -> ()) {
        
        let url = "\(EndPoint.TMDBUrl)movie/\(movieID)/recommendations?api_key=\(APIKey.TMDB.rawValue)&language=en-US&page=\(startPage)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                var data: [SimilarMovies] = []
                
                if json["results"].arrayValue.count < 10 {
                    
                    let moviePoster = json["results"].arrayValue.map { $0["poster_path"].stringValue }
                    
                    for i in 0..<moviePoster.count {
                        
                        data.append(SimilarMovies(poster: moviePoster[i]))
                    }
                    
                } else {
                    
                    let moviePoster = json["results"].arrayValue.shuffled()
                    let posters = moviePoster[0..<10]
                    
                    let movie = posters.map { $0["poster_path"].stringValue }
                        .map { "https://image.tmdb.org/t/p/original" + $0 }
                    
                    for i in 0..<movie.count {
                        
                        data.append(SimilarMovies(poster: movie[i]))
                    }
                }
                
                
                
                completionHandler(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
