//
//  FoodImageUrl.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//

import Foundation

//Food image for unsplash api query
struct FoodImageUrl:Decodable{
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
