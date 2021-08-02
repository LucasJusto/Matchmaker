//
//  OnboardingViewController.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 22/07/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var onboardingScreens: [OnboardingScreen] = []
    
    var currentPage = 0 {
        didSet {
            if currentPage == 1 || currentPage == 3 {
                collectionView.layer.backgroundColor = UIColor.black.cgColor
            } else {
                collectionView.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img1 = UIImage(named: "game"),
              let img2 = UIImage(named: "chat") {
            
            onboardingScreens = [
                OnboardingScreen(title: NSLocalizedString("onboarding2Title", comment: ""), description: NSLocalizedString("onboarding2Description", comment: ""), image: img1, imageWidth: 186, imageHeight: 254),
                OnboardingScreen(title: NSLocalizedString("onboarding3Title", comment: ""), description: NSLocalizedString("onboarding3Description", comment: ""), image: img2, imageWidth: 293, imageHeight: 254),
            ]
            
        }
        
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func getIdentifier(page: Int) -> String {
        return "FirstOnboardingCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstOnboardingCollectionViewCell", for: indexPath)
                
                return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell

        cell.setup(onboardingScreens[indexPath.row-1])

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        return self.size.width / self.size.height
    }
}
