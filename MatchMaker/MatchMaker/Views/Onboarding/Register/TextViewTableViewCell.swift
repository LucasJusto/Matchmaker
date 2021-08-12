//
//  TextViewTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 02/08/21.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var textViewField: TextViewField!
    
    @IBOutlet weak var counterLabelView: UILabel!
            
    @IBOutlet weak var placeholder: LocalizableLabel!
    
    let maxLength = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textViewField.tintColor = .white
        textViewField.textColor = .white
    }
}
