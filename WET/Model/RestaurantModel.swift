//
//  RestaurantModel.swift
//  WET
//
//  Created by isaac k lee on 2021/04/27.
//
import Foundation
import CoreLocation

class RestaurantModel{
    private let BASE_URL = "https://api.yelp.com/v3/businesses/search"
    private let ACCESS_TOKEN = "0nmBFsYUgDTAGsjqtkKQpWdWTJ2xyukwGlF6_Fq_El_YvY5GDFmB449VJx-dSUCjMdeVUQgLtZtYtiWRm5tXB9beHOnQN4vqERQCJdDQV4A9pIn17A5BwnolTO9-XnYx"
    private let Client_ID = "YwgQs4T763kGCw7DtgIAoA"

    //Singleton
    static let shared = RestaurantModel()
    static var images = [Restaurant]()
    
    
    
    //Yelp Api Query based on my location
    func getImage(onSuccess: @escaping ([Restaurant]) -> Void){
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
              CLLocationManager.authorizationStatus() == .authorizedAlways) {
                 currentLoc = locationManager.location
        }
        //Get Request to Yelp
        //50 images with offset from 0 to 150 by 30
        //Gaurantee wide range of restaurants and left the possibility to encounter already seen restaurants.
        //This is because people don't always want to see new restaurants.
        if let url = URL(string: "\(BASE_URL)?latitude=\(currentLoc.coordinate.latitude)&longitude=\(currentLoc.coordinate.longitude)&limit=50&offset=\(Int.random(in: 0 ... 5)*30)"){
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Bearer \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                    if let data = data{
                        do{
                            let restaurantresults = try JSONDecoder().decode(RestaurantResults.self, from: data)
                            RestaurantModel.images = restaurantresults.businesses
                            print(RestaurantModel.images.count)
                            onSuccess(RestaurantModel.images)
                            }catch let actual_error{
                                print(actual_error.localizedDescription)
                                exit(1)
                            }
                    }

            }.resume()
        }
    }
    
}
