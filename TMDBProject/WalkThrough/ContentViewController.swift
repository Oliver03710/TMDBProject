//
//  FirstViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/16.
//

import UIKit

class ContentViewController: UIViewController {

    // MARK: - Properties
    

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    var index = 0
    var introString: String?
    var imageString: String?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    // MARK: - Helper Functions
    
    func setUI() {
        descriptionLabel.text = introString
        contentImageView.image = UIImage(named: imageString ?? "applelogo")
    }
    
}
