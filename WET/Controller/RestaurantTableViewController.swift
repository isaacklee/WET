//
//  RestaurantTableViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/28.
//

import Foundation
import UIKit
import Kingfisher

class RestaurantTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static var index=0
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //number of rows is same as number of images
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RestaurantModel.images.count
    }
    //Set Cell - image and text
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.mainView.backgroundColor = UIColor(patternImage: UIImage(named: "2bg")!)
        RestaurantTableViewController.index=indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "RI", for : indexPath) as! RestaurantCell
        
        let url = URL(string: RestaurantModel.images[indexPath.row].image_url)
        if RestaurantModel.images[indexPath.row].image_url == ""{
            cell.CellImage.image = UIImage(named: "nfi")
            cell.Name.text = RestaurantModel.images[indexPath.row].name
        }else{
            cell.CellImage.kf.setImage(with: url)
            cell.Name.text = RestaurantModel.images[indexPath.row].name
        }
        return cell
    }
    
    //Pass image info to DetailRestaurantViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" ,let destination = segue.destination as? DetailRestaurantViewController , let indexPath = self.tableView.indexPathForSelectedRow?.row{
            let image = RestaurantModel.images[indexPath]
            destination.image = image
            RestaurantViewController.viewedImages.append(image.image_url)
        }
    }
    
    
    
    
}
