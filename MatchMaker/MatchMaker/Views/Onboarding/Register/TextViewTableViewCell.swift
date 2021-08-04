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
            
    let maxLength = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        textViewField.delegate = self
    }

}

//extension TextViewTableViewCell: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        counterLabelView.text = "\(textView.text.count)/\(maxLength)"
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        return textView.text.count + (text.count - range.length) <= maxLength
//    }
//}
