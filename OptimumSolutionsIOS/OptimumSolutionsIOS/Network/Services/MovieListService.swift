//
//  MovieListService.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-07.
//

import Foundation

class MovieListService {
    
    let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func getMovieData(with searchQuery: String,
                      completion: @escaping (Result<[MovieModel], APIError>) -> Void) -> Void {
        var components = URLComponents(string: AppConstants.BaseURL)!

        components.queryItems = [
            URLQueryItem(name: "s", value: searchQuery),
            URLQueryItem(name: "apikey", value: AppConstants.ApiKey)
        ]

        guard let url = components.url else {
            completion(.failure(APIError.URLError))
            return
        }
        
        self.apiManager.request(url: url, method: .GET, dataType: MovieModelRootObj.self) { response in
            switch response {
            case .success(let res):
                
                /// Handle data fetch when the response is only TRUE
                /// or passing an error
                guard let data =  res.search,
                      let response = res.response,
                      response == .TRUE
                else {
                    completion(.failure(APIError.serverError(res.error)))
                    return
                }
                
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
