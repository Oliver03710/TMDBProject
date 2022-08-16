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
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNextButton()
        configureSkipButton()
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
        
        if let index = walkThroughPageViewController?.currentPageIndex {
            switch index {
            case 0...1:
                walkThroughPageViewController?.nextPages()
            case 2:
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: "TMDBViewController") as? TMDBViewController else { return }
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
                
            default:
                break
            }
            
            pageControl.currentPage = index + 1
        }
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



