//
//  MovieViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

import Kingfisher

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
    
    var movieList: [SecondMovieData] = []
    var similarMovieList: [[SimilarMovies]] = []
    var pages = 1
    var totalPageNum = 0

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        fetchingMovieData(num: pages)
    }
    
    
    // MARK: - Networking

    func fetchingMovieData(num: Int) {
        
        SearchingMovieManager.shared.fetchSecondMovieData(startPage: num) { data, similarMovies in
            
            self.movieList = data
            self.similarMovieList = similarMovies
            
            dump(self.movieList)
            dump(self.similarMovieList)
            
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
                
            }
        }
    }
    
}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reusableIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .black
        cell.movieCollectionView.tag = indexPath.section
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.register(UINib(nibName: PosterCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.reusableIdentifier)
        cell.movieCollectionView.reloadData()
        cell.titleLabel.text = "\(movieList[indexPath.section].title), 이 영화와 비슷한 컨텐츠"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource

// UICollectionViewDelegateFlowLayout: sizeForItemAt - 개별 아이템을 역동적으로 높이 변경
extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return similarMovieList[collectionView.tag].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.reusableIdentifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: similarMovieList[collectionView.tag][indexPath.item].poster)
        cell.posterView.posterImageView.kf.setImage(with: url)
        collectionView.reloadData()
        
        return cell
    }
    
}
