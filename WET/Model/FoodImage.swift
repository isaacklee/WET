//
//  FoodImage.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//

import Foundation

//Food image for Unsplash image api query
struct FoodImage: Decodable{
    let id: String?
    let urls: FoodImageUrl?
    let description:String?
}
