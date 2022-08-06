//
//  UIButton+Extension.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/06.
//

import UIKit

extension UIButton {
    
    //MARK:- Animate check mark
    func buttonAnimation(closure: @escaping () -> Void) {
        guard let image = self.imageView else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
//                self.isSelected = !self.isSelected
                
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
    
}
