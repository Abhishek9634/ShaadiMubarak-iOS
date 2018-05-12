//
//  PlaceTableViewCell.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 12/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var item: PlaceItem? {
        didSet {
            self.configure(item: self.item)
        }
    }
    
    func configure(item: PlaceItem?) {
        if let model = item {
            self.titleLabel.text = model.mapItem.name
        }
    }
    
}
