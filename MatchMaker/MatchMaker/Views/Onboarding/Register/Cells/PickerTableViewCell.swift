//
//  PickerTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 04/08/21.
//

import UIKit

//MARK: - PickerCellDelegate Protocol

protocol PickerCellDelegate: AnyObject {
    
    /**
    didChooseLocation is used to perform a segue
     
    Since is not possible to perform a segue outside a viewController because @buttonView belongs to PickerTableViewCell, *didChooseLocation* is the **PickerCellDelegate**'s function to implement the segue inside an UIViewController who signs this delegate.
     
    - Parameters:
        - sender: the UITableViewCell in question. Just in case there is some additional formatting to be done
     
    - Returns: Void
     */
    func didChooseLocation(_ sender: UITableViewCell)
}

//MARK: - PickerTableViewCell Class

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
