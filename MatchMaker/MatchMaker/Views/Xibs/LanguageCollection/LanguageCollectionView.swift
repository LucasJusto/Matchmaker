//
//  LanguageCollectionViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit
//MARK: - LanguageCollectionView Class

@IBDesignable class LanguageCollectionView: UIView, NibLoadable {
    //MARK: LanguageCollectionView - Variables and Outlets Setup
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "LanguageViewCell"

    #warning("After merging master, change structure to Language enum")
    var languages: [String] = ["English", "Portuguese", "Russian"]
    
    //MARK: LanguageCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "LanguageViewCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dynamicTypeChanges), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    //MARK: LanguageCollectionView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    //MARK: LanguageCollectionView - Accessibility Features: Reload CollectionView for DynamicTypes change
    
    @objc func dynamicTypeChanges(_ notification: Notification){
        print(#function)
        //collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
//MARK: - UICollectionView DelegateFlowLayout

extension LanguageCollectionView: UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDelegateFlowLayout - Content Setup: Item Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? LanguageCell,
              let font = cell.titleLabel.font
        else { fatalError("Error while fetching cell or font at @LanguageCollectionView.sizeForItemAt") }
        
        let language = languages[indexPath.row]
        
        let textWidth = ceil(language.widthOfString(usingFont: font))

        return CGSize(width: textWidth, height: collectionView.bounds.height)
    }
}

//MARK: - UICollectionView DataSource

extension LanguageCollectionView: UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource - Content Setup: Number of Items per Section

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LanguageCell
        
        cell.titleLabel.text = languages[indexPath.row]
        
        return cell
    }
}
