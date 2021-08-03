//
//  SmallLabeledImageCollectionView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

protocol SmallLabeledImageModel {
    var description: String { get }
    var imageSelected: String { get }
    var imageNotSelected: String { get }
}

//MARK: - SmallLabeledImageCollectionView Class

class SmallLabeledImageCollectionView: UIView, NibLoadable {
    
    //MARK: SmallLabeledImageCollectionView - Variables and Outlets Setup

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "SmallLabeledImageCollectionCell"
    
    var smallLabeledImageModels: [SmallLabeledImageModel] = []
    
    //MARK: SmallLabeledImageCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SmallLabeledImageCollectionCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dynamicTypeChanges), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    //MARK: SmallLabeledImageCollectionView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: SmallLabeledImageCollectionView - Accessibility Features: Reload CollectionView for DynamicTypes change
    
    @objc func dynamicTypeChanges(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

//MARK: - UICollectionView DelegateFlowLayout

extension SmallLabeledImageCollectionView: UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegateFlowLayout - Content Setup: Item Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let font = SmallLabeledImageCollectionViewCell.titleFont

        let platform = smallLabeledImageModels[indexPath.row]
        
        let textWidth = ceil(platform.description.widthOfString(usingFont: font))

        return CGSize(width: textWidth > 30 ? textWidth : 30, height: collectionView.bounds.height)
    }
}


//MARK: - UICollectionView DataSource

extension SmallLabeledImageCollectionView: UICollectionViewDataSource {

    //MARK: UICollectionViewDataSource - Content Setup: Number of Items per Section
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallLabeledImageModels.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SmallLabeledImageCollectionViewCell
        
        let platform = smallLabeledImageModels[indexPath.row]
        
        cell.contentImage.image = UIImage(named: platform.imageSelected)
        cell.titleLabel.text = smallLabeledImageModels[indexPath.row].description
        
        return cell
    }
}
