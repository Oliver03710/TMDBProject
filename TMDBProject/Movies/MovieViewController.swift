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
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](120...130),
        [Int](1...5),
        [Int](21...32),
        [Int](45...50)
    ]
    
    
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
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reusableIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .green
        cell.movieCollectionView.tag = indexPath.section
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.register(UINib(nibName: PosterCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.reusableIdentifier)
        cell.movieCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberList[collectionView.tag].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.reusableIdentifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.posterView.testLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
        print(indexPath.item)
        
        return cell
    }
    
}
