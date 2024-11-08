//
//  APIClient.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation

class APIManager {
    
    static let shared  = APIManager()
    
    private init() {
    }
    
    func request<T: Decodable>(url: URL, 
                               method: APIMethod,
                               dataType: T.Type,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.serverError("Invalid response")))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
}

enum APIMethod: String {
    case POST = "POST"
    case GET = "GET"
}
