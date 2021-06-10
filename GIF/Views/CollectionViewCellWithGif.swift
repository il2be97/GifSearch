//
//  CollectionViewCellWithGif.swift
//  GIF
//
//  Created by admin on 28.05.2021.
//

import UIKit
import SwiftyGif

class CollectionViewCellWithGif: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var gifImageView: UIImageView!
    
    static let identifier: String = "CollectionViewCellWithGif"
    
    // MARK: Conversion .. adding a GIF in the cell
    func runGif(with url: URL){
        gifImageView.clear()
        gifImageView.setGifFromURL(url)
    }
}
