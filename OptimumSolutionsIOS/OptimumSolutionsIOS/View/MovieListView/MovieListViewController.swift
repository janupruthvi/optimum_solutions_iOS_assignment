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
        
        viewModel.isLoading.sink{ isLoading in
            //self.tableView.reloadData()
        }.store(in: &subscription)
        
        viewModel.isError.sink{ errorRes in
            //self.tableView.reloadData()
        }.store(in: &subscription)
        
    }
    
    func registerTableViewCell() {
        movieListTableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
    }
    
    func setUpSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Movies here"
        search.searchBar.backgroundColor = .white
        navigationItem.searchController = search
        navigationItem.title = "Find Movies"
    }


}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                DispatchQueue.main.async {
                    self?.viewModel.getMovieListFromSearch(searchTxt: searchTxt)
                }
            }
        })

    }
    
}

