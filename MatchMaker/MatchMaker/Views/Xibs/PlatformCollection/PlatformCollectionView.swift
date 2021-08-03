//
//  PlatformCollectionVIew.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

//MARK: - PlatformCollectionView Class

@IBDesignable class PlatformCollectionView: UIView, NibLoadable {
    
    //MARK: PlatformCollectionView - Variables and Outlets Setup

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "PlatformCollectionCell"
    
    #warning("After merging master, change structure to Platforms enum")
    typealias GamingPlatforms = (name: String, image: UIImage)
    var platforms: [GamingPlatforms] {
        var platforms: [GamingPlatforms] = []
        
        let playstation = GamingPlatforms(name: "Playstation", image: UIImage(named: "Play_selected")!)
        let xbox        = GamingPlatforms(name: "Xbox", image: UIImage(named: "Xbox")!)
        let PC          = GamingPlatforms(name: "PC", image: UIImage(named: "PC_selected")!)
        let mobile      = GamingPlatforms(name: "Mobile", image: UIImage(named: "Mobile")!)
        
        platforms = [playstation, xbox, PC, mobile]
        
        return platforms
    }
    
    //MARK: PlatformCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "PlatformCollectionCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dynamicTypeChanges), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    //MARK: PlatformCollectionView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: PlatformCollectionView - Accessibility Features: Reload CollectionView for DynamicTypes change
    
    @objc func dynamicTypeChanges(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

//MARK: - UICollectionView DelegateFlowLayout

extension PlatformCollectionView: UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegateFlowLayout - Content Setup: Item Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PlatformCollectionViewCell,
              let font = cell.titleLabel.font
        else { fatalError("Error while fetching cell or font at @PlatformCollectionView.sizeForItemAt") }
        
        let platform = platforms[indexPath.row]
        
        let textWidth = ceil(platform.name.widthOfString(usingFont: font))

        return CGSize(width: textWidth > 30 ? textWidth : 30, height: collectionView.bounds.height)
    }
}


//MARK: - UICollectionView DataSource

extension PlatformCollectionView: UICollectionViewDataSource {

    //MARK: UICollectionViewDataSource - Content Setup: Number of Items per Section
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlatformCollectionViewCell
        
        cell.contentImage.image = platforms[indexPath.row].image
        cell.titleLabel.text = platforms[indexPath.row].name
        
        return cell
    }
}
