//
//  Identifier+Protocol.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension UIViewController: IdentifierProtocol {
   
    static var identifier: String {
            return String(describing: self)
    }
    
}

extension UICollectionViewCell: IdentifierProtocol {
   
    static var identifier: String {
            return String(describing: self)
    }
    
}
