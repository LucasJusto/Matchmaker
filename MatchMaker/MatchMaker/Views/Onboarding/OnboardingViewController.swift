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
        
    enum OnboardingPages: Int, CaseIterable {
        case welcome
        case games
        case chat
        case icloud
    }
    
    let onboardingPages = OnboardingPages.allCases

    var currentPage = OnboardingPages.welcome {
        didSet {
            if currentPage == .games || currentPage == .icloud {
                collectionView.layer.backgroundColor = UIColor.black.cgColor
            } else {
                collectionView.layer.backgroundColor = UIColor(named: "Primary")?.cgColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - onboarding collection view configs

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let onboardingPage = onboardingPages[indexPath.row]
        
        switch onboardingPage {
            case .welcome: return setUpBasicCell(indexPath: indexPath, identifier: "FirstOnboardingCollectionViewCell")
                
            case .games: return setUpCustomCell(indexPath: indexPath, tag: OnboardingPages.games.rawValue)
                
            case .chat: return setUpCustomCell(indexPath: indexPath, tag: OnboardingPages.chat.rawValue)
                
            case .icloud: return setUpBasicCell(indexPath: indexPath, identifier: "PermissionOnboardingCollectionViewCell")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = OnboardingPages(rawValue: Int(scrollView.contentOffset.x / width)) ?? .welcome
        pageControl.currentPage = currentPage.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - cells setup
    
    func setUpBasicCell(indexPath: IndexPath, identifier: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
       
        return cell
    }
    
    func setUpCustomCell(indexPath: IndexPath, tag: Int) -> OnboardingCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        guard let onboardingPage = OnboardingPages(rawValue: tag) else {
            return cell
        }
        
        switch onboardingPage {
            case .chat:
                
                if let img = UIImage(named: "chat"){

                    let chatScreen = OnboardingScreen(title: NSLocalizedString("onboarding2Title", comment: "title onboarding 2"), description: NSLocalizedString("onboarding2Description", comment: "description onboarding 2"), image: img, imageWidth: 293, imageHeight: 254, color: UIColor(named: "Primary") ?? .black)
                    
                    cell.setup(chatScreen)
                }
                
            case .games:
                
                if let img = UIImage(named: "game") {

                    let gameScreen = OnboardingScreen(title: NSLocalizedString("onboarding2Title", comment: "title onboarding 2"), description: NSLocalizedString("onboarding2Description", comment: "description onboarding 2"), image: img, imageWidth: 186, imageHeight: 254, color: .black)
                    
                    cell.setup(gameScreen)
                }
                
            default: return cell
        }
        
        return cell
    }
    
    
}
