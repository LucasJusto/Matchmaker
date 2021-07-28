//
//  SelectorTableViewCell.swift
//  MatchMaker
//
//  Created by Thaís Fernandes on 27/07/21.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var selectedTags: [String] = [];
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String, items: [String]) {
        titleLabel.text = title
                
        var lastWidth: CGFloat = 0.0
        
        items.forEach { item in
            let width = item.widthOfString(usingFont: UIFont.systemFont(ofSize: 15, weight: .medium))+20;
                        
            let tagView = UIButton(frame: CGRect(x: lastWidth, y: 0.0, width: width, height: 36))
            
            lastWidth += width+20
                        
            tagView.setTitle(item, for: .normal)
            tagView.backgroundColor = selectedTags.contains(item) ? UIColor(named: "Primary") : .clear
            tagView.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            tagView.cornerRadius = 8
            tagView.addTarget(self, action: #selector(selectTag), for: .touchUpInside)
            
            containerView.addSubview(tagView)
        }
        
    }
    
    @objc func selectTag(sender: UIButton!) {
        
        if let item = sender.title(for: .normal) {
            print("clicou ", sender.title(for: .normal) ?? " ")

            selectedTags.append(item)
        }

    }

}
