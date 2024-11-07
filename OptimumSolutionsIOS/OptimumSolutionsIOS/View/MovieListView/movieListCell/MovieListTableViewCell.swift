//
//  MovieListTableViewCell.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-07.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContainerView: UIView!
    
    @IBOutlet weak var yearContainerView: UIView!
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    @IBOutlet weak var movieTitleLbl: UILabel!
    
    @IBOutlet weak var movieYearLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        cellContainerView.backgroundColor = .white
        cellContainerView.layer.cornerRadius = 10
        cellContainerView.layer.shadowRadius = 0.3
        cellContainerView.layer.borderWidth = 0.5
        cellContainerView.layer.borderColor = UIColor.gray.cgColor
        
        yearContainerView.layer.cornerRadius = 15
    }
    
    func configureMovieList(movieObject: MovieModel) {
        self.movieTitleLbl.text = movieObject.title
        self.movieYearLbl.text = movieObject.year
        
        if let posterUrl = movieObject.poster {
            AsyncImageService.shared.loadImageFromURL(imageUrl: posterUrl,
                                                      completion: { [weak self] image in
                self?.moviePosterImage.image = image
            })
        }
    }
    

    
}
