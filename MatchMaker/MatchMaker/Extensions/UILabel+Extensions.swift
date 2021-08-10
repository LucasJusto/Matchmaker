//
//  UILabel+Extensions.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 23/07/21.
//

import UIKit

class LocalizableLabel: UILabel {

    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }

}
