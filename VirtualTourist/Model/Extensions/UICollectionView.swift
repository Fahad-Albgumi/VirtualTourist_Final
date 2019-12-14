//
//  UICollectionView.swift
//  VirtualTourist
//
//  Created by fahad on 11/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import Foundation
import UIKit
extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func deleteEmptyMessage() {
        self.backgroundView = nil
    }
}
