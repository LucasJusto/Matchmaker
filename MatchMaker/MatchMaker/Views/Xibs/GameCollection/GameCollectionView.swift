//
//  GameCollectionView.swift
//  MatchMaker
//
//  Created by Marina De Pazzi on 27/07/21.
//

import UIKit

@IBDesignable class GameCollectionView: UIView, NibLoadable {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let games: [Game] = buildGameArray()
    
    private let cellIdentifier: String = "GameCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "GameCollectionCell", bundle: .main), forCellWithReuseIdentifier: cellIdentifier)
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

//MARK: - UICollectionView Delegate

extension GameCollectionView: UICollectionViewDelegate {
    
    //this function will later on perfom the segue to the info screen of a game
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - UICollectionView DataSource

extension GameCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GameCollectionViewCell
        
        cell.contentImage.image = games[indexPath.row].image
        cell.contentImage.layer.cornerRadius = 10
        
        return cell
    }
}
