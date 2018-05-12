//
//  HomeCollectionCell.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 12/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

struct HomeCellModel {
    var title: String
    var image: String
}

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var item: HomeCellModel? {
        didSet {
            self.configure(item: self.item)
        }
    }
    
    func configure(item: HomeCellModel?) {
        if let model = item {
            self.imgView.image = UIImage(named: "user.png")
            self.titleLabel.text = model.title
        }
    }
    
}
