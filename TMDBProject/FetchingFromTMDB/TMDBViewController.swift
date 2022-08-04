//
//  TMDBViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class TMDBViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tmdbCollectionView: UICollectionView!
    
    var movieList: [TMDB] = []
    var actorList: [Int: [String]] = [:]
    var pages = 1
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchingData(num: pages)
        setCells(collectionView: tmdbCollectionView)
    }
    
    
    // MARK: - Helper Functions
    
    func configureCollectionView() {
        tmdbCollectionView.delegate = self
        tmdbCollectionView.dataSource = self
        tmdbCollectionView.register(UINib(nibName: TMDBCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TMDBCollectionViewCell.identifier)
        tmdbCollectionView.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderReusableView")
    }
    
    
    // MARK: - Networking

    func fetchingData(num: Int) {
        
        let url = EndPoint.TMDBUrl + "trending/\(MediaType.movie.rawValue)/\(TimeWindow.day.rawValue)?api_key=\(APIKey.TMDB.rawValue)&page=\(num)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for item in json["results"].arrayValue {
                    
                    let name = item["title"].stringValue
                    let image = item["poster_path"].stringValue
                    let vote = item["vote_average"].doubleValue
                    let date = item["release_date"].stringValue
                    let genre = item["genre_ids"][0].intValue
                    let movieId = item["id"].intValue
                    
                    guard let url = URL(string: "https://image.tmdb.org/t/p/original" + image) else { return }
                    
                    let data = TMDB(name: name, image: url, vote: vote, releaseDate: date, movieID: movieId, genre: genre)
                    
                    self.movieList.append(data)
                    fetchingActorData(movieID: movieList[movieList.count - 1].movieID)
                }
                
                tmdbCollectionView.reloadData()

            case .failure(let error):
                print(error)
            }
        }
    
    }
    

    func fetchingActorData(movieID: Int) {
        
        var arr: [String] = []
     
        let url2 = EndPoint.TMDBUrl + "\(MediaType.movie.rawValue)/\(movieID)/credits?api_key=\(APIKey.TMDB.rawValue)&language=en-US"
        
        AF.request(url2, method: .get).validate(statusCode: 200...400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for item in json["cast"].arrayValue {
                    
                    let actor = item["name"].stringValue
                    
                    arr.append(actor)
                    
                    self.actorList.updateValue(arr, forKey: movieID)
                }

                tmdbCollectionView.reloadData()

            case .failure(let error):
                print(error)
            }
        }
    }

}


extension TMDBViewController: UICollectionViewDataSourcePrefetching {
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
//        for indexPath in indexPaths {
//            if imageArr.count - 1 == indexPath.row, imageArr.count < totalCount {
                pages += 1
//
//                guard let text = searchBar.text else { return }
                fetchingActorData(movieID: pages)
//        }
        print("=============\(indexPaths)==============")
        
    }
    
    // 작업 취소시
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("====취소======\(indexPaths)======취소=====")
    }
    
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource

extension TMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        for i in 0...movieList.count {
            if section == i {
                return 1
            }
        }
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        cell.movieImageView.kf.setImage(with: movieList[indexPath.section].image)
        cell.movieImageView.contentMode = .scaleAspectFill
        cell.movieImageView.clipsToBounds = true
        cell.movieImageView.layer.cornerRadius = 10
        
        cell.baseView.backgroundColor = .clear
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowOffset = CGSize(width: -2, height: 2)
        cell.layer.shadowRadius = 6
        
        cell.upperVIew.clipsToBounds = true
        cell.upperVIew.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 10)
        
        cell.buttonView.backgroundColor = .clear
        
        cell.titleLabel.text = movieList[indexPath.section].name
        cell.titleLabel.textAlignment = .left
        cell.titleLabel.font = .systemFont(ofSize: 20)
        
        if let actors = actorList[movieList[indexPath.section].movieID] {
            cell.actorLabel.text = actors.joined(separator: ", ")
        }
        
        cell.actorLabel.textAlignment = .left
        cell.actorLabel.font = .systemFont(ofSize: 16)
        cell.actorLabel.textColor = .darkGray

 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderReusableView", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }

            return headerView
        default:
            assert(false, "Invalid element type")
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = self.tmdbCollectionView.frame.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(actorList)
    }
  
    
}


