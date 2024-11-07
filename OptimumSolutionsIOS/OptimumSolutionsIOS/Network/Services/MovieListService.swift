//
//  MovieListService.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-07.
//

import Foundation
import Combine

class MovieListService {
    
    let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func getMovieData(with searchQuery: String) -> AnyPublisher<[MovieModel], Error> {
        Future {[weak self] promise in
            
            var components = URLComponents(string: AppConstants.BaseURL)!

            components.queryItems = [
                URLQueryItem(name: "s", value: searchQuery),
                URLQueryItem(name: "apikey", value: AppConstants.ApiKey)
            ]

            guard let url = components.url else {
                promise(.failure(APIError.URLError))
                return
            }
            
            print("URL - ", url)
            
            self?.apiManager.request(url: url, method: .GET, dataType: MovieModelRootObj.self) { response in
                switch response {
                case .success(let res):
                    
                    guard let data =  res.search, res.response ?? false else {
                        promise(.failure(APIError.noData))
                        return
                    }
                    
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
                
            }
        }
        .compactMap({$0})
        .eraseToAnyPublisher()
    }
    
}
