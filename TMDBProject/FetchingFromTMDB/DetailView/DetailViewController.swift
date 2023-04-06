//
//  DetailViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/04.
// 셀의 바운스 기능 해제 / 리로드 데이터를 해서 괜찮은지

import UIKit

import OLFramework

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var movieData: MovieData?

    var actorName: [String]?
    var characterName: [String] = []
    var actorProfile: [String] = []
    
    var crewName: [String]?
    var crewDepartment: [String] = []
    var crewProfile: [String] = []
    
    var shouldCellBeExpanded: Bool = false
    var indexOfExpendedCell: Int = 0
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        configureTableView()
//        detailTableView.scrollToRow(at: <#T##IndexPath#>, at: <#T##UITableView.ScrollPosition#>, animated: <#T##Bool#>)
    }
    
    
    // MARK: - Selectors
    
    @objc func expandButtonAction(button: UIButton) {

        button.isSelected = !button.isSelected
        
        if button.isSelected {
            
            indexOfExpendedCell = button.tag
            shouldCellBeExpanded = true

            self.detailTableView.reloadRows(at: [IndexPath(item: indexOfExpendedCell + 1, section: 1)], with: .fade)

            UIView.animate(withDuration: 0.25, animations: {
                button.setImage(UIImage(systemName: "chevron.up"), for: .selected)
//                button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            
        } else if !button.isSelected {

            indexOfExpendedCell = button.tag
            shouldCellBeExpanded = false

            self.detailTableView.reloadRows(at: [IndexPath(item: indexOfExpendedCell + 1, section: 1)], with: .fade)
            
            UIView.animate(withDuration: 0.25, animations: {
                button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//                button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            
        }
    }
    
    
    // MARK: - Helper Functions
    
    func refineOptional() -> [String] {
        guard let actorName = actorName else { return [""] }
        return actorName
    }
    
    func refineCrewOptional() -> [String] {
        guard let crewName = actorName else { return [""] }
        return crewName
    }
    
    func configureTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: DetailMovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailMovieTableViewCell.reuseIdentifier)
        detailTableView.register(UINib(nibName: OverViewTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
    }
    
    
    func configureNavi() {
        
//        let barAppearance = UINavigationBarAppearance()
//        barAppearance.backgroundColor = .white
//        navigationItem.scrollEdgeAppearance = barAppearance
        
        navigationItem.title = "출연 / 제작"
    }

}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1: return 1
        case 2: return refineOptional().count
        case 3: return refineCrewOptional().count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            
            cell.overviewLabel.text = movieData?.overView
            cell.overviewLabel.numberOfLines = 0
            
            cell.downButton.tag = indexPath.row
            cell.downButton.addTarget(self, action: #selector(expandButtonAction(button:)), for: .touchUpInside)
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMovieTableViewCell.reuseIdentifier, for: indexPath) as? DetailMovieTableViewCell else { return UITableViewCell() }
            
            cell.realNameLabel.text = refineOptional()[indexPath.row]
            
            cell.characterLabel.text = characterName[indexPath.row]
            cell.characterLabel.textColor = .systemGray2
            
            if let profile = URL(string: actorProfile[indexPath.row]) {

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: profile)
                    DispatchQueue.main.async {
                        guard let data = data else { return }
                        cell.profileImageView.image = UIImage(data: data)
                    }
                }
                
            }
            
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailMovieTableViewCell.reuseIdentifier, for: indexPath) as? DetailMovieTableViewCell else { return UITableViewCell() }

            cell.realNameLabel.text = refineOptional()[indexPath.row]
            
            cell.characterLabel.text = characterName[indexPath.row]
            cell.characterLabel.textColor = .systemGray2
            
            if let profile = URL(string: actorProfile[indexPath.row]) {

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: profile)
                    DispatchQueue.main.async {
                        guard let data = data else { return }
                        cell.profileImageView.image = UIImage(data: data)
                    }
                }
                
            }
            
            return cell
            
        default:
            break
        }
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 1:
            if shouldCellBeExpanded && indexPath.row == indexOfExpendedCell {
                    return 200
                } else { return 120 }
        default:
            return 130
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailTableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - Extension: UIScrollViewDelegate

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
