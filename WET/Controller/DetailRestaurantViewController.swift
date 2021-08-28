//
//  DetailRestaurantViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/28.
//


import Foundation
import Kingfisher
import UIKit
import StoreKit
import ContactsUI
import Contacts
import MessageUI

class DetailRestaurantViewController:UIViewController,CNContactPickerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Rating: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var PhoneNumber: UILabel!
    @IBOutlet weak var IsColsed: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    var image:Restaurant? = nil
    var restName:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor(patternImage: UIImage(named: "DetailBackGround")!)
        load()
        
    }
    //Load data of selected Restaurant
    func load(){
        //Set Name of Restaurant
        title = self.image?.name
        //Set Image
        //When image not available
        if self.image?.image_url == ""{
            self.Image.image = UIImage(named:"nfi")
        }else{
            //Force unwrap because we know for sure there is image_url
            let url = Foundation.URL(string: self.image!.image_url)
            self.Image.kf.setImage(with: url)
        }
        
        //Set Rating
        if let rating = self.image?.rating{
            Rating.text = "  \(String(rating)) / 5.0"
        }else{
            Rating.text = "No Rating Be the First to Rate!"
        }
        
        //Set Price
        if let price = self.image?.price{
            Price.text = "  \(price)"
            Price.font = UIFont.boldSystemFont(ofSize: 22)
        }else{
            Price.text = "  Visit the Website to Check Price!"
        }
        //Set Closed Status
        if let status = self.image?.isClosed{
            if(status == true){
                IsColsed.text = "The Restaurant is Closed!"
            }else{
                IsColsed.text = "The Restaurant is Open!"
            }
        }else{
            IsColsed.text = "Visit Website to Check If Open!"
        }
        //Set Phone Number
        if self.image?.display_phone == ""{
            PhoneNumber.text = "Can not Find Phone Number"
        }else{
            PhoneNumber.text = self.image?.display_phone
        }
        
        //Set Hypertext
        if (self.image?.url) != nil{
            let urlString = "Visit \(self.image?.name ?? "Restaurant")"
            urlButton.setTitle(urlString, for: .normal)
            urlButton.titleLabel!.font =  UIFont(name: "Marker Felt", size: 17)
            urlButton.setTitleColor(.blue
                                    , for: .normal)
        }

    }
    
    
    //When visit url button clicked
    @IBAction func urlDidTapped(_ sender: UIButton) {
        //When returned, review popup is shown
        reviewPopUp()
        UIApplication.shared.open(URL(string: self.image?.url ?? "https://www.yelp.com/")! as URL, options: [:],completionHandler: nil)
    }
    var contact = CNContactStore()
    
    //ACCESS CONTACTS
    @IBAction func phoneDidTapped(_ sender: UIButton) {
        contact.requestAccess(for: .contacts) { (success, error) in
            if success{

                let vc = CNContactPickerViewController()
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
    //Feature for sending email but commented b/c NOT USED
//        guard MFMailComposeViewController.canSendMail() else{
//            return
//        }
//        let composer = MFMailComposeViewController()
//        composer.mailComposeDelegate = self
//        composer.setToRecipients([self.image!.display_phone])
//        composer.setSubject("Question")
//        composer.setMessageBody("Hi, \(self.image?.name ?? "") I have a question!!", isHTML: false)
//        
//        present(composer, animated: true)
//        }
    
    //Pop up feedback collector after coming back from the website
    func reviewPopUp(){
        let alert = UIAlertController(title: "REVIEW", message: "Do You Like WET?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Not Sure", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Love It!", style: .default, handler: {[weak self]_ in
            guard let scene = self?.view.window?.windowScene else{
                return
            }
            SKStoreReviewController.requestReview(in: scene)
        }))
        alert.addAction(UIAlertAction(title: "Hate It!", style: .default, handler: {[weak self]_ in
            guard let scene = self?.view.window?.windowScene else{
                return
            }
            SKStoreReviewController.requestReview(in: scene)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
}

