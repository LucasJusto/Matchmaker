//
//  LanguageCollectionViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

protocol TitleModel {
    var description: String { get }
}

import UIKit
//MARK: - TitleCollectionView Class

class TitleCollectionView: UIView, NibLoadable {
    //MARK: TitleCollectionView - Variables and Outlets Setup
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "TitleViewCell"

    var titleModels: [TitleModel] = []
    
    //MARK: TitleCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "TitleViewCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dynamicTypeChanges), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    //MARK: TitleCollectionView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: TitleCollectionView - Accessibility Features: Reload CollectionView for DynamicTypes change
    
    @objc func dynamicTypeChanges(_ notification: Notification){
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
//MARK: - UICollectionView DelegateFlowLayout

extension TitleCollectionView: UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegateFlowLayout - Content Setup: Item Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let font = TitleCell.titleFont
        let language = titleModels[indexPath.row]
        
        let textWidth = ceil(language.description.widthOfString(usingFont: font))

        return CGSize(width: textWidth, height: collectionView.bounds.height)
    }
}

//MARK: - UICollectionView DataSource

extension TitleCollectionView: UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource - Content Setup: Number of Items per Section

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleModels.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TitleCell
        
        cell.titleLabel.text = titleModels[indexPath.row].description
        
        return cell
    }
}
