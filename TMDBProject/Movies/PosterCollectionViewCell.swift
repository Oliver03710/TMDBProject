//
//  PosterCollectionViewCell.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var posterView: PosterView!
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        
    }
    
    
    // MARK: - setting UI
    
    func setUI() {
        posterView.posterImageView.image = UIImage(systemName: "applelogo")
        posterView.backgroundColor = .clear
        posterView.posterImageView.backgroundColor = .clear
        posterView.posterImageView.layer.cornerRadius = 10
        
    }

}
