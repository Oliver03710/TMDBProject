//
//  UIViewController+Extension.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

extension UIViewController {
    
    func setCells(collectionView: UICollectionView) {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width * 0.8, height: 400)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: spacing, right: 0)
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
    }

}
