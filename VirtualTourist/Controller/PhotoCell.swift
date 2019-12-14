//
//  cell.swift
//  VirtualTourist
//
//  Created by fahad on 11/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.kf.indicatorType = .activity
    }
}
