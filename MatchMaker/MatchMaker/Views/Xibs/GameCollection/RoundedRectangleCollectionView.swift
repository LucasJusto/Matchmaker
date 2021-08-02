//
//  RoundedRectangleCollectionView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

protocol RoundedRectangleModel {
    var image: UIImage { get }
}

//MARK: - RoundedRectangleCollectionView Class

@IBDesignable class RoundedRectangleCollectionView: UIView, NibLoadable {
    
    //MARK: RoundedRectangleCollectionView - Variables and Outlets Setup
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "RoundedRectangleCell"
    
    var RoundedRectangleImageModels: [RoundedRectangleModel] = []
    
    //MARK: RoundedRectangleCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "RoundedRectangleCollectionCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    //MARK: RoundedRectangleCollectionView - Nib Setup
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

}

//MARK: - UICollectionView Delegate

extension RoundedRectangleCollectionView: UICollectionViewDelegate {
    
    //MARK: UICollectionViewDelegate - Interaction Setup
    
    //this function will later on perfom the segue to the info screen of a game
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - UICollectionView DataSource

extension RoundedRectangleCollectionView: UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource - Content Setup

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RoundedRectangleImageModels.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! RoundedRectangleViewCell
        
        cell.contentImage.image = RoundedRectangleImageModels[indexPath.row].image
        cell.contentImage.layer.cornerRadius = 10
        
        return cell
    }
}
