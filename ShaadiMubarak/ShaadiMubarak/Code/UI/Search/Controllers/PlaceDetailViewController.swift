//
//  PlaceDetailViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 12/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imgView: ImageView!
    
    var viewModel: PlaceItem!

    private var mapFrame: CGRect {
        return self.imgView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PlaceDetailViewController {
    
    func populateData() {
        self.nameLabel.text = self.viewModel.mapItem.name
        self.addressLabel.text = self.viewModel.address
        let urlString = "http://maps.googleapis.com/maps/api/staticmap?zoom=13&size=\(Int(self.mapFrame.size.width))x\(Int(self.mapFrame.size.height))&markers=\(self.viewModel.mapItem.placemark.coordinate.latitude),\(self.viewModel.mapItem.placemark.coordinate.longitude)&sensor=false"
        print("IMAGE URL : \(urlString)")
        self.imgView.setImageFromUrl(urlString: urlString)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        default:
            return UITableViewAutomaticDimension
        }
    }
}
