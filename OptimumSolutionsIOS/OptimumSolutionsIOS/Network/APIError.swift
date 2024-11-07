//
//  APIError.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation

enum APIError: Error {
    case serverError(String?)
    case invalidData
    case noData
    case URLError
    case decodingError(Error)
}
