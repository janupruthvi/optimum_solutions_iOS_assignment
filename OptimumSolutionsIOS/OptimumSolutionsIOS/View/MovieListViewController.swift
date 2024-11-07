//
//  ViewController.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-06.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var movieListTableView: UITableView!
    
    let viewModel: MovieListViewModel = MovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
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

extension MovieListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
            print(text)
            self.viewModel.searchText.send(text)
    }
    
}

