//
//  DetailViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/04.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var movieData: MovieData?

    var actorName: [String]?
    var characterName: [String] = []
    var actorProfile: [String] = []
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: DetailMovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailMovieTableViewCell.identifier)
        detailTableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    // MARK: - Helper Functions
    
    func refineOptional() -> [String] {
        guard let actorName = actorName else { return [""] }
        return actorName
    }

}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 0
        case 1: return 1
        default:
            return refineOptional().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMovieTableViewCell.identifier, for: indexPath) as? DetailMovieTableViewCell else { return UITableViewCell() }
        
        cell.mainLabel.text = refineOptional()[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 300))
            
            let imageView = UIImageView()
            imageView.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
            
            let mainImage = UIImageView()
            mainImage.frame = CGRect.init(x: headerView.frame.width / 10, y: headerView.frame.height / 4, width: headerView.frame.width / 3, height: headerView.frame.height / 1.5)
            
            let movieTitle = UILabel()
            movieTitle.frame = CGRect.init(x: headerView.frame.width / 13, y: headerView.frame.height / 40, width: headerView.frame.width - headerView.frame.width / 13, height: headerView.frame.height / 4)
            
            guard let image = movieData?.backImage, let poster = movieData?.mainImage, let label = movieData?.title else { return UIView() }

            if let url = URL(string: image), let mainUrl = URL(string: poster) {
                let data = try! Data(contentsOf: url)
                imageView.image = UIImage(data: data)
                
                let data2 = try! Data(contentsOf: mainUrl)
                mainImage.image = UIImage(data: data2)
                
                movieTitle.text = label
                movieTitle.font = .boldSystemFont(ofSize: 32)
                movieTitle.textColor = .systemBackground
            }
            
            imageView.addSubview(mainImage)
            headerView.addSubview(imageView)
            headerView.addSubview(movieTitle)
            
            return headerView
            
        case 1:
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: -10, width: headerView.frame.width, height: headerView.frame.height)
            label.text = "OverView"
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .systemGray

            headerView.addSubview(label)
            
            return headerView
            
        default:
            
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: -10, width: headerView.frame.width, height: headerView.frame.height)
            label.text = "Cast"
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .systemGray

            headerView.addSubview(label)
            
            return headerView
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0: return 300
        default: return 32
        }

    }

    
}


extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let sectionHeaderHeight: CGFloat = 310
        
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 {
            
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            
        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
}

//extension DetailViewController: CustomHeaderDelegate {
//    func customHeader(_ customHeader: HeaderTableView, didTapButtonInSection section: Int) {
//        print("did tap button", section)
//    }
//}
