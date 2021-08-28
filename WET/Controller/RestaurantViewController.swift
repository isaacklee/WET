//
//  RestaurantViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/28.
//

import Foundation
import Kingfisher
import UIKit
import JGProgressHUD


class RestaurantViewController:UIViewController {
    //HUD initialize
    let hud:JGProgressHUD = {
        let hud = JGProgressHUD(style:.dark)
        hud.style = .dark
        hud.interactionType = .blockAllTouches
        return hud
    }()
    var i = 1
    var Image:Restaurant? = nil
    var images = [Restaurant]()
    static var viewedImages = [String]()
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    //New image load when refresh tapped
    @IBAction func refreshDidTapped(_ sender: UIBarButtonItem) {
        hud.textLabel.text = "New Restaurant Getting Ready"
        hud.show(in: view, animated: true)
        self.Image = images[randomize()]
        let url = URL(string: Image?.image_url ?? "")
        self.restaurantImage.kf.setImage(with: url)
        self.restaurantName.text = self.Image?.name.uppercased()
        self.hud.dismiss(animated: true)
        
    }
    //Set gesture recognizers and initial setting
    override func viewDidLoad() {
        hud.textLabel.text = "Get Ready for a New Restaurant"
        hud.show(in: view, animated: true)
        super.viewDidLoad()
        self.mainView.backgroundColor = UIColor(patternImage: UIImage(named: "2bg")!)
        loadImages()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipped))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipped))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(singleTap)
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        self.hud.dismiss(animated: true)

    }
    //load image function asynchronous call
    func loadImages(){
        RestaurantModel.shared.getImage{ (images) in
            DispatchQueue.main.async{
                self.images = images
                self.Image = images[self.randomize()]
                let url = URL(string: (self.Image?.image_url)!)
                self.restaurantImage.kf.setImage(with: url)
                self.restaurantName.text = self.Image?.name.uppercased()
            }
        }
        
    }
    //function to ensure randomization of appearing images
    func randomize()->Int{
        let count = images.count
        return Int.random(in: 0 ... count-1)
    }
    //move to DetailRestaurantViewController when single tapped
    @objc func singleTapped(){
        if (Image?.image_url) != nil{
            RestaurantViewController.viewedImages.append(Image!.image_url)
        }
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    //animation for leftswipe and random image appear
    @objc func leftSwipped(){
        animationView.transform = CGAffineTransform(translationX: 0, y: 0)
        let animateLeft = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0) })

        animateLeft.addCompletion{ (position) in
            print("\(#function)")
            if(self.i>9){
                self.i=1
                self.loadImages()
            }else{
                let url = URL(string: self.images[self.i].image_url )
                self.Image = self.images[self.i]
                self.restaurantImage.kf.setImage(with: url)
                self.restaurantName.text = self.Image?.name.uppercased()
                self.i = self.i+1
            }
            self.animationView.transform = CGAffineTransform(translationX: self.view.frame.size.width , y: 0)
            let animateLeft1 = UIViewPropertyAnimator(duration: 0.7, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: 0, y: 0) })
            animateLeft1.startAnimation()
            
        }
        animateLeft.startAnimation()
        
    }
    //animation for leftswipe and random image appear
    @objc func rightSwipped(){
        animationView.transform = CGAffineTransform(translationX: 0, y: 0)
        let animateRight = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0) })
        animateRight.addCompletion{ (position) in
            if(self.i>9){
                self.i=1
                self.loadImages()
            }else{
                let url = URL(string: self.images[self.i].image_url )
                self.Image = self.images[self.i]
                self.restaurantImage.kf.setImage(with: url)
                self.restaurantName.text = self.Image?.name.uppercased()
                self.i = self.i+1
            }
            self.animationView.transform = CGAffineTransform(translationX: -self.view.frame.size.width , y: 0)
            let animateRight1 = UIViewPropertyAnimator(duration: 0.7, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: 0, y: 0) })
            animateRight1.startAnimation()
            }
        animateRight.startAnimation()
    }
    
    //Pass data from RestaurantViewController to DetailRestaurantViewController
    //Selected Restaurant is passed down
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? DetailRestaurantViewController
        destination?.image = Image
        
        let mapDestiantion = segue.destination as? MapViewController
        mapDestiantion?.image = Image
    }
    
    
}

