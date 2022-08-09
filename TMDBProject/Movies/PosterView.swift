//
//  PosterView.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

class PosterView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setUI()
    }
    
    
    // MARK: - Setting UI
    
    func setUI() {
        guard let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self).first as? UIView else { return }
        
        view.backgroundColor = .red
        view.frame = bounds
        self.addSubview(view)
        
    }
    
}
