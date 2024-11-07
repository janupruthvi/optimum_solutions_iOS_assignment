//
//  MovieModelRootObj.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation

struct MovieModelRootObj: Codable {
    let search: [MovieModel]?
    let response: MovieRespose?
    let error: String?
    let totalResults: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case error = "Error"
        case totalResults = "totalResults"
    }
    
}

enum MovieRespose: String, Codable {
    case TRUE = "True"
    case FALSE = "False"
}
