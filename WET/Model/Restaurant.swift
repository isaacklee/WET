//
//  Restaurant.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//

import Foundation


//Struct used to decode json from Yelp Api query
struct RestaurantResults:Codable{
    var businesses:[Restaurant]
}

struct Restaurant:Codable{
    let name:String
    let image_url: String
    let review_count: Int
    let url:String
    let rating: Double
    let price: String?
    let display_phone: String
    let distance:Double
    let isClosed:Bool?
    var coordinates : Location
}

struct Location:Codable{
    let latitude:Double
    let longitude:Double
}

struct Address:Codable{
    let city:String
    let zip_code:String
    let address1:String
    let address2:String
    let address3:String
}

