//
//  ImageViewCell.swift
//  ImageGalleryDemo
//
//  Created by Jadhav, V. A. on 20/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.imageView.contentMode = .scaleToFill
    }
    
    func setCellImage(image: UIImage?) {
        imageView.image = image

    }
}
