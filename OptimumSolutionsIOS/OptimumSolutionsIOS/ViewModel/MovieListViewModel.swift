//
//  MovieListViewModel.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import Foundation
import Combine

class MovieListViewModel {
    
    var movieList = CurrentValueSubject<[MovieModel], Never>([MovieModel]())
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var isError = CurrentValueSubject<(isError: Bool, errorMsg: String?), Never>((false, nil))
    
    var movieListService: MovieListService
    
    init(movieListService: MovieListService = MovieListService()) {
        self.movieListService = movieListService
    }
    
    func getMovieListFromSearch(searchTxt: String) {
        self.movieListService.getMovieData(with: searchTxt) {[weak self] result in
            switch result {
            case .success(let movieList):
                self?.movieList.send(movieList)
            case .failure(let error):
                //self?.isError.send((true, error))
                break
            }
        }
    }
    
}
