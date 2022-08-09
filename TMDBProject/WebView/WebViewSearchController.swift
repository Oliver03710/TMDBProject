//
//  WebViewSearchController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/07.
//

import UIKit
import WebKit

//class ResultsVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBlue
//    }
//}

class WebViewSearchController: UIViewController {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        guard let url = destinationURL else { return }
        openWebPage(url: url)
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        configureNavi()
    }
    
    
    func configureNavi() {
        title = "Trailer"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
}


// MARK: - Extension: UISearchResultsUpdating

extension WebViewSearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text else { return }
//        let vc = searchController.searchResultsController as? ResultsVC
//        vc?.view.backgroundColor = .yellow
        openWebPage(url: text)
    }

}


// MARK: - Extension: UISearchBarDelegate

extension WebViewSearchController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        openWebPage(url: text)
    }

}
