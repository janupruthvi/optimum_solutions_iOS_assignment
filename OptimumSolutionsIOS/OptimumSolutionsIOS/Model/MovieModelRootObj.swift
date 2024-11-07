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
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case error = "Error"
    }
    
}

enum MovieRespose: String, Codable {
    case TRUE = "True"
    case FALSE = "False"
}
