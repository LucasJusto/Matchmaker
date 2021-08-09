//
//  PickerTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 04/08/21.
//

import UIKit

protocol PickerCellDelegate: AnyObject {
    
    func didChooseLocation(_ sender: UITableViewCell)
}

class PickerTableViewCell: UITableViewCell {

    @IBOutlet weak var currentSelectionLabel: UILabel!
    
    @IBOutlet weak var buttonView: ButtonView!
    
    weak var delegate: PickerCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.didChooseLocation(self)
    }
}
