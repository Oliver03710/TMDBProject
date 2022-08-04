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
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchingData()
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

    func fetchingData() {
        
        let url = EndPoint.TMDBUrl + "trending/\(MediaType.movie.rawValue)/\(TimeWindow.day.rawValue)?api_key=\(APIKey.TMDB.rawValue)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["results"].arrayValue {
                    
                    let name = item["title"].stringValue
                    let image = item["poster_path"].stringValue
                    let vote = item["vote_average"].doubleValue
                    let date = item["release_date"].stringValue
                    let genre = item["genre_ids"][0].intValue
                    let movieId = item["id"].intValue
                    
                    fetchingActorData(movieID: movieId)
                    guard let url = URL(string: "https://image.tmdb.org/t/p/original" + image) else { return }
                    
                    let data = TMDB(name: name, image: url, vote: vote, releaseDate: date, movieID: movieId, genre: genre)
                    
                    self.movieList.append(data)
                    
                    
                }
                
                tmdbCollectionView.reloadData()
                
                print(self.movieList)
                print(self.movieList.count)

            case .failure(let error):
                print(error)
            }
        }
        

    }
    
    
    func fetchingActorData(movieID: Int) {
     
        let url2 = EndPoint.TMDBUrl + "\(MediaType.movie.rawValue)/\(movieID)/credits?api_key=\(APIKey.TMDB.rawValue)&language=en-US"
        
        AF.request(url2, method: .get).validate(statusCode: 200...400).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["cast"].arrayValue {
                    
                    let actor = item["name"].stringValue
                    
                    var arrays: [String] = []
                    arrays.append(actor)
                    
                    self.actorList.updateValue(arrays, forKey: movieID)

                }
                
                tmdbCollectionView.reloadData()
                
                print(self.actorList)
                print(self.actorList.count)

            case .failure(let error):
                print(error)
            }
        }
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
        
        for i in 0...indexPath.section {
            
            cell.movieImageView.kf.setImage(with: movieList[i].image)
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
            
            cell.titleLabel.text = movieList[i].name
            cell.titleLabel.textAlignment = .left
            cell.titleLabel.font = .systemFont(ofSize: 20)
            
            if let actors = actorList[movieList[i].movieID] {
                actors.forEach {
                    cell.actorLabel.text! = $0
                }
            }

            cell.actorLabel.textAlignment = .left
            cell.actorLabel.font = .systemFont(ofSize: 16)
            cell.actorLabel.textColor = .darkGray
        }
 
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
    
    }
  
    
}


