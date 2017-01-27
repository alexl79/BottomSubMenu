//
//  SubMenuCollectionViewCell.swift
//  BottomSubMenu
//
//  Created by Alexander Lobanov on 25.01.17.
//  Copyright © 2017 iosnik. All rights reserved.
//

import Foundation
import UIKit

class SubMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(idx: Int) {
        
        imageView.image = UIImage(named: "image-social-\(idx + 1)")
    }
}
