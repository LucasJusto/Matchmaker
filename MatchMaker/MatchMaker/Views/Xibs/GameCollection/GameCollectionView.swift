//
//  GameCollectionView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

//MARK: - GameCollectionView Class

@IBDesignable class GameCollectionView: UIView, NibLoadable {
    
    //MARK: GameCollectionView - Variables and Outlets Setup
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIdentifier: String = "GameCollectionCell"
    private let games: [Game] = buildGameArray()
    
    //MARK: GameCollectionView - View Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "GameCollectionCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    //MARK: GameCollectionView - Nib Setup
    
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

extension GameCollectionView: UICollectionViewDelegate {
    
    //MARK: UICollectionViewDelegate - Interaction Setup
    
    //this function will later on perfom the segue to the info screen of a game
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - UICollectionView DataSource

extension GameCollectionView: UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource - Content Setup

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    //MARK: UICollectionViewDataSource - Cell Setup

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GameCollectionViewCell
        
        cell.contentImage.image = games[indexPath.row].image
        cell.contentImage.layer.cornerRadius = 10
        
        return cell
    }
}
