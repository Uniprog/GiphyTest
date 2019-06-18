//
//  GiphyImageCell.swift
//  GiphyTest
//
//  Created by Alexander on 16/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GiphyImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    
    deinit {
        print("deinit " + String(describing: self))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //! Clear previous image
        imageView.image = nil
        imageView.animatedImage = nil
    }
}
