//
//  SubMenuView.swift
//  BottomSubMenu
//
//  Created by Alexander Lobanov on 25.01.17.
//  Copyright © 2017 iosnik. All rights reserved.
//

import Foundation
import UIKit

class SubMenuView: UIView {
    
    let itemsCnt = 3
    let cellIdentifier = String(describing: SubMenuCollectionViewCell.self)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var csCollectionViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepare()
    }
    
    private func prepare() {
        
        let nib = UINib(nibName: cellIdentifier, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setup() {
        
        csCollectionViewWidth.constant = bounds.width
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width
        let space = (bounds.width - itemWidth * CGFloat(itemsCnt)) / CGFloat(itemsCnt + 1)
        
        layout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        layout.minimumLineSpacing = space
    }
}

extension SubMenuView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SubMenuCollectionViewCell
        cell.setup(idx: indexPath.row)
        
        return cell
    }
}

extension SubMenuView: UICollectionViewDelegate {
    
    
}
