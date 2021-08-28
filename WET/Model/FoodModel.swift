//
//  FoodModel.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//

import Foundation

class FoodModel{
    private let BASE_URL = "https://api.unsplash.com"
    private let ACCESS_TOKEN = "Yp6hS_JuS35-OJwxAGPMAynIbh4Od-N0xUZH5as7oto"
    private let PHOTO_COUNT = 10
    
    //Singleton
    static let shared = FoodModel()
    static var images = [FoodImage]()
    
    //unsplash api query
    //get random images related to lunch
    func getImage(onSuccess: @escaping ([FoodImage]) -> Void){
        if let url = URL(string: "\(BASE_URL)/photos/random?client_id=\(ACCESS_TOKEN)&count=10&query=lunch"){
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                    if let data = data{
                        do{
                            let images = try JSONDecoder().decode([FoodImage].self, from: data)
                            FoodModel.images = images
                            onSuccess(FoodModel.images)
                        
                        } catch let actual_error{
                            print(actual_error.localizedDescription)
                            exit(1)
                        }
                    }
                
            }.resume()
        }
    }
    
}
