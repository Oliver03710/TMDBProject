//
//  MainTableViewCell.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    
    // MARK: - Setting UI
    
    func setUI() {
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .clear
        
        movieCollectionView.backgroundColor = .black
        movieCollectionView.collectionViewLayout = collectionViewLayout()
        
        self.backgroundColor = .black

    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: titleLabel.frame.width / 3, height: movieCollectionView.frame.height)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return layout
    }

}



 
