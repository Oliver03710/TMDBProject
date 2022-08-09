//
//  Identifier+Protocol.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

protocol ReusableIdentifierProtocol {
    static var reusableIdentifier: String { get }
}

extension UIViewController: ReusableIdentifierProtocol {
   
    static var reusableIdentifier: String {
            return String(describing: self)
    }
    
}

extension UICollectionViewCell: ReusableIdentifierProtocol {
   
    static var reusableIdentifier: String {
            return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableIdentifierProtocol {
    
    static var reusableIdentifier: String {
            return String(describing: self)
    }
    
}
