//
//  AppConstants.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation

enum Environment {
    case development
}

class AppConstants {
    
    static let environment: Environment = .development
    
    static var BaseURL: String {
        switch environment {
        case .development:
            return "https://www.omdbapi.com/"
        }
    }
    
    static var ApiKey: String {
        switch environment {
        case .development:
            return "8d6aa4ca"
        }
    }
}
