//
//  HomeViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 11/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellItems: [HomeCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.cellItems = [
            HomeCellModel(title: "Wedding Hall", image: ""), HomeCellModel(title: "Catering", image: ""),
            HomeCellModel(title: "Photographer", image: ""), HomeCellModel(title: "Liquor Shop", image: ""),
            HomeCellModel(title: "Band", image: ""), HomeCellModel(title: "Beauty Parlour/Saloon", image: ""),
            HomeCellModel(title: "Mehndi", image: ""), HomeCellModel(title: "Flowers", image: ""),
            HomeCellModel(title: "Vegetables", image: ""), HomeCellModel(title: "Grocery", image: "")
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell",
                                                      for: indexPath) as! HomeCollectionCell
        cell.item = self.cellItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 60)/3
        let height = width + 50
        return CGSize(width: width, height: height)
    }
    
}
