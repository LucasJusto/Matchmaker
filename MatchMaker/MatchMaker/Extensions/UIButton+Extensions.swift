//
//  UIButton+Extensions.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 23/07/21.
//

import UIKit

class LocalizableButtonLabel: UIButton {

    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }

}
