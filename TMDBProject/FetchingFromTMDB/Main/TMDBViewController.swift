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
    
    var movieList: [MovieData] = []
    
    var actorName: [Int: [String]] = [:]
    var characterName: [Int: [String]] = [:]
    var actorProfile: [Int: [String]] = [:]
    var movieLink: String = ""
    
    var pages = 1
    var totalPages = 0
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        configureCollectionView()
        setCells(collectionView: tmdbCollectionView)
        fetchingMovieData(num: pages)
    }
    
    
    // MARK: - Selectors
    
    @objc func moveToYouTube(sender: UIButton) {
        
        fetchingMovieLinkData(num: movieList[sender.tag].movieId)
        
    }
    
    
    @objc func doNothing() {
        
    }
    
    
    // MARK: - Helper Functions
    
    func configureNavi() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        navigationItem.scrollEdgeAppearance = barAppearance
        
        navigationItem.title = "MY MEDIA"
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(doNothing))

    }
    
    
    func configureCollectionView() {
        tmdbCollectionView.prefetchDataSource = self
        tmdbCollectionView.delegate = self
        tmdbCollectionView.dataSource = self
        tmdbCollectionView.register(UINib(nibName: TMDBCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TMDBCollectionViewCell.identifier)
        tmdbCollectionView.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderReusableView")
    }
    
    
    // MARK: - Networking

    func fetchingMovieData(num: Int) {
        
        SearchingMovieManager.shared.fetchMovieData(startPage: num) { totalPages, movieData in
            
            self.totalPages = totalPages
            self.movieList.append(contentsOf: movieData)
            
            self.fetchingActorData()
            
            DispatchQueue.main.async {
                self.tmdbCollectionView.reloadData()
            }
            
        }
    }

    
    func fetchingActorData() {
        
        for item in 0..<self.movieList.count {
            
            SearchingCastManager.shared.fetchingActorData(movieID: self.movieList[item].movieId) { actorData in
                
                self.actorName.updateValue(actorData.name, forKey: self.movieList[item].movieId)
                self.characterName.updateValue(actorData.character, forKey: self.movieList[item].movieId)
                self.actorProfile.updateValue(actorData.profile, forKey: self.movieList[item].movieId)
                
                DispatchQueue.main.async {
                    self.tmdbCollectionView.reloadData()
                }
            }
        }
        
    }
    
    
    func fetchingMovieLinkData(num : Int) {
            
            SearchingYouTubeManager.shared.fetchingMovieLinkData(movieID: num) { link in
                
                self.movieLink = link
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                
                guard let vc = sb.instantiateViewController(withIdentifier: WebViewSearchController.identifier) as? WebViewSearchController else { return }
                
                vc.destinationURL = self.movieLink
                
                DispatchQueue.main.async {
                    self.tmdbCollectionView.reloadData()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
    }
}


// MARK: - Extension: UICollectionViewDataSourcePrefetching

extension TMDBViewController: UICollectionViewDataSourcePrefetching {
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if movieList.count - 1 == indexPath.section, movieList.count < totalPages {
                pages += 1
                fetchingMovieData(num: pages)
            }
            
        }
        
        // 작업 취소시
        func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
            
        }
        
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource

extension TMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        cell.movieImageView.kf.setImage(with: URL(string: movieList[indexPath.section].mainImage))
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
        
        cell.titleLabel.text = movieList[indexPath.section].title
        cell.titleLabel.textAlignment = .left
        cell.titleLabel.font = .systemFont(ofSize: 20)
        

        cell.actorLabel.text = actorName[movieList[indexPath.section].movieId]?.joined(separator: ", ")
        cell.actorLabel.textAlignment = .left
        cell.actorLabel.font = .systemFont(ofSize: 16)
        cell.actorLabel.textColor = .darkGray
        
        cell.voteLabel.text = "\(Double(round(movieList[indexPath.section].vote * 10)) / 10)"
        
        cell.linkButton.clipsToBounds = true
        cell.linkButton.layer.cornerRadius = cell.linkButton.layer.bounds.height / 2
        cell.linkButton.addTarget(self, action: #selector(moveToYouTube(sender:)), for: .touchUpInside)
        cell.linkButton.tag = indexPath.section

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderReusableView", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            
            headerView.releaseDate.text = DateHelper.changeDateFormat(dateString: movieList[indexPath.section].releaseDate, fromFormat: "yyyy-MM-dd", toFormat: "yyyy년 MM월 dd일")
            
            headerView.genreLabel.text = "#\(GenreHelper.shared.checkingGenre(genreNum: movieList[indexPath.section].genre))"
            
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
        
        tmdbCollectionView.deselectItem(at: indexPath, animated: true)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        
        vc.movieData = movieList[indexPath.section]
    
        guard let name = actorName[movieList[indexPath.section].movieId], let character = characterName[movieList[indexPath.section].movieId], let profile = actorProfile[movieList[indexPath.section].movieId] else { return }
        vc.actorName = name
        vc.characterName = character
        vc.actorProfile = profile
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}
