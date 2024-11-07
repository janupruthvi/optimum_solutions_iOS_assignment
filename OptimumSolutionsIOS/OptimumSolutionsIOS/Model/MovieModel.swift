//
//  MovieModel.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation

struct MovieModel: Codable {
    
    let title : String?
    let year : String?
    let imdbID : String?
    let type : String?
    let poster : String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
}
