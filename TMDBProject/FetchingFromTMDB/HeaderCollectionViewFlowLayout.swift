//
//  HeaderCollectionViewFlowLayout.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

class HeaderCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            
            let layoutAttributes = super.layoutAttributesForElements(in: rect)
            
            guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
                return layoutAttributes
            }
            if offset.y < 0 {
                
                for attributes in stLayoutAttributes {
                    
                    if let elmKind = attributes.representedElementKind, elmKind == UICollectionView.elementKindSectionHeader {
                        
                        let diffValue = abs(offset.y)
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + diffValue)
                        frame.origin.y = frame.minY - diffValue
                        attributes.frame = frame
                    }
                }
            }
            return layoutAttributes
        }
    
}
