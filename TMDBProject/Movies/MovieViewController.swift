//
//  MovieViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
    }
    
    
    
    
}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}
