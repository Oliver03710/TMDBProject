//
//  TMDBData.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import Foundation

struct MovieData {
    
    let title: String
    let mainImage: String
    let backImage: String
    let releaseDate: String
    let vote: Double
    let movieId: Int
    let genre: Int
    let overView: String
    
}

struct ActorData {
    
    let name: [String]
    let character: [String]
    let profile: [String]
    
}

struct CrewData {
    
    let name: [String]
    let department: [String]
    let profile: [String]
    
}


