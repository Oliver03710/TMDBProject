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
        
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = .blue
        titleLabel.backgroundColor = .systemYellow
        
        movieCollectionView.backgroundColor = .systemGray2
        movieCollectionView.collectionViewLayout = collectionViewLayout()
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: PosterCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.reusableIdentifier)
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


extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.reusableIdentifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        
        return cell
    }
    
    
}
 
