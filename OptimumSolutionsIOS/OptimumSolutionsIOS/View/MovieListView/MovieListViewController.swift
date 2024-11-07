//
//  ViewController.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import UIKit
import Combine

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var movieListTableView: UITableView! {
        didSet {
            movieListTableView.delegate = self
            movieListTableView.dataSource = self
        }
    }
    
    var subscription = Set<AnyCancellable>()
    
    var searchTimer: Timer?
    
    let viewModel: MovieListViewModel = MovieListViewModel()
    
    let movieListCellIdentifier: String = "MovieListTableViewCell"
    
    var searchController: UISearchController = UISearchController()
    
    let spinner = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        registerTableViewCell()
        setUpSubscription()
    }
    
    func setUpSubscription() {
        
        viewModel.movieList.sink{_ in
            DispatchQueue.main.async {
                self.movieListTableView.reloadData()
            }
        }.store(in: &subscription)
        
        viewModel.isLoading.sink(receiveValue: { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.handleSpinner(isLoading: isLoading)
            }
        }).store(in: &subscription)
        
        viewModel.isError.sink(receiveValue: { [weak self] (isError, error) in
            DispatchQueue.main.async {
                self?.handleError(errorTuple: (isError, error))
            }
        }).store(in: &subscription)
        
    }
    
    func registerTableViewCell() {
        movieListTableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
    }
    
    func setUpSearchBar() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies here"
        navigationItem.searchController = searchController
        navigationItem.title = "Find Movies"
    }
    
    func handleSpinner(isLoading: Bool) {
        
        if isLoading {
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        } else {
            spinner.willMove(toParent: nil)
            spinner.view.removeFromSuperview()
            spinner.removeFromParent()
        }
    }
    
    func handleError(errorTuple: (Bool, APIError?)) {
        if errorTuple.0 {
            var errorMsg: String = ""
            switch errorTuple.1 {
            case .serverError(let error):
                errorMsg = "Server error: \(error ?? "")"
            case .invalidData:
                errorMsg = "Retrived data is invalid"
            case .noData:
                errorMsg = "No Data found to display"
            case .URLError:
                errorMsg = "URL is invalid"
            case .decodingError(let error):
                errorMsg = "Error while decodig: \(error)"
            default:
                errorMsg = "Internal error occured"
            }
            searchController.searchBar.text = nil
            AlertController.displayAlert(message: errorMsg, parentView: self)
        }
    }
    
    


}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.movieListCellIdentifier) as? MovieListTableViewCell {
            let data = viewModel.movieList.value[indexPath.row]
            cell.configureMovieList(movieObject: data)
            return cell
        }
        return UITableViewCell()
    }

}


extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.searchTimer?.invalidate()
        
        guard let searchTxt = searchController.searchBar.text, !searchTxt.isEmpty else { return }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.getMovieListFromSearch(searchTxt: searchTxt)
                }
            }
        })

    }
    
}

