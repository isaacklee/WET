//
//  ImageCell.swift
//  WET
//
//  Created by isaac k lee on 2021/05/04.
//

import UIKit

class ImageCell: UICollectionViewCell {
    //CollectionView Cell
    @IBOutlet weak var viewedImage: UIImageView!
    var imageURL:String = ""
    func getImageUrl() -> String {
        return self.imageURL
    }
    func setImageURL(url:String){
        self.imageURL = url
    }
    
}
