//
//  TMDBCollectionViewCell.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

class TMDBCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var upperVIew: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!

    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var voteLabel: UILabel!
    
}
