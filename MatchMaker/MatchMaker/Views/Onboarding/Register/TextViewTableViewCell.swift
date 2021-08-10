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
            
    var placeholder: String = "Placeholder"
    
    let maxLength = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textViewField.text = placeholder
        textViewField.textColor = UIColor.lightGray
    
        textViewField.tintColor = .white
        textViewField.textColor = .white
    }
}
