//
//  WalkThroughViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/16.
//

import UIKit

class WalkThroughViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var walkThroughPageViewController: WalkThroughPageViewController?
    var currentPageIndex: Int?
    var handler: (() -> ())?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNextButton()
        configureSkipButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "contentView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function, "contentView")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function, "contentView")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(#function, "contentView")
    }
    
    
    // MARK: - Helper Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if let pageVC = destination as? WalkThroughPageViewController {
            walkThroughPageViewController = pageVC
        }
    }
    
    func configureNextButton() {
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Next"
        configuration.buttonSize = .large
        
        nextButton.configuration = configuration
        
    }
    
    func configureSkipButton() {
        
        var configuration = UIButton.Configuration.borderless()
        configuration.title = "Skip"
        configuration.baseBackgroundColor = .systemGreen
        configuration.buttonSize = .mini
        
        skipButton.configuration = configuration
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.nextButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.nextButton.transform = .identity
            }
        }
        
        switch pageControl.currentPage {
        case 0...1:
            walkThroughPageViewController?.nextPages()
            pageControl.currentPage += 1
        case 2:
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "TMDBViewController") as? TMDBViewController else { return }
            let nav = UINavigationController(rootViewController: vc)
            
            sceneDelegate?.window?.rootViewController = nav
            sceneDelegate?.window?.makeKeyAndVisible()
        default: break
        }
//        if let index = walkThroughPageViewController?.currentPageIndex {
//            switch index {
//            case 0...1:
//                walkThroughPageViewController?.nextPages()
//            case 2:
//
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//
//                let sb = UIStoryboard(name: "Main", bundle: nil)
//                guard let vc = sb.instantiateViewController(withIdentifier: "TMDBViewController") as? TMDBViewController else { return }
//                let nav = UINavigationController(rootViewController: vc)
//
//                sceneDelegate?.window?.rootViewController = nav
//                sceneDelegate?.window?.makeKeyAndVisible()
//
//            default:
//                break
//            }
//
//            pageControl.currentPage = index + 1
//        }
    }
    
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "TMDBViewController") as? TMDBViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
        
    }

}



