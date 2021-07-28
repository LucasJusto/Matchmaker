//
//  LanguageCollectionViewController.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 28/07/21.
//

import UIKit

@IBDesignable class LanguageCollectionView: UIView, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView!
    
    #warning("After merging master, change structure to Language enum")
    var languages: [String] = ["English", "Portuguese", "Russian"]
    
    private let cellIdentifier: String = "LanguageViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "LanguageViewCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
}

extension LanguageCollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 200)
//    }
    
}

//MARK: - CollectionView DataSource

extension LanguageCollectionView: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! LanguageCell
        
        cell.titleLabel.text = languages[indexPath.row]
        
        return cell
    }
}
