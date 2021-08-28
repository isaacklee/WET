//
//  FoodViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/28.
//

import Foundation
import Kingfisher
import UIKit
import FirebaseAuth
import JGProgressHUD



private let reuseIdentifier = "Cell"

class FoodViewController:UIViewController {
    //Initialized hud
    let hud:JGProgressHUD = {
        let hud = JGProgressHUD(style:.dark)
        hud.style = .dark
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    var Image:FoodImage? = nil
    var images = [FoodImage]()
    var i = 1
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodDescription: UILabel!
    
   //Signout Button and relevant alert
    @IBAction func signOutButtonDidTapped(_ sender: UIBarButtonItem) {
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are You Sure?", preferredStyle: .alert)

        signOutAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
                do {
                    try Auth.auth().signOut()

                } catch let err {
                    print(err)
                }
        }))
        signOutAlert.addAction(UIAlertAction(title: "NO", style: .cancel,handler: nil))

        present(signOutAlert, animated: true,completion: nil)
    }
    
    //Reload random image of food
    @IBAction func refreshDidTapped(_ sender: UIBarButtonItem) {
        hud.textLabel.text = "Get Ready for New Food Pic"
        hud.show(in: view, animated: true)
        
        foodDescription.text = ""
        foodDescription.isHidden = true
        
        if(i>9){
            i=1
            loadImages()
        }else{
            let url = URL(string: images[i].urls?.regular ?? "")
            self.Image = images[i]
            self.foodImageView.kf.setImage(with: url)
            i = i+1
        }
        self.hud.dismiss(animated: true)
    }
    override func viewDidLoad() {
        foodDescription.isHidden = true
        hud.textLabel.text = "Get Ready for New Food Pic"
        hud.show(in: view, animated: true)
        super.viewDidLoad()
        self.mainView.backgroundColor = UIColor(patternImage: UIImage(named: "2bg")!)
        loadImages()
        //Gesture Recognizer for left, right swipe and single tap
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidLoad()
    }
    //Load food image
    func loadImages(){
        FoodModel.shared.getImage{ (images) in
            DispatchQueue.main.async{
                self.images = images
                self.Image = images[0]
                let url = URL(string: (self.Image?.urls?.regular)!)
                self.foodImageView.kf.setImage(with: url)
                self.foodDescription.isHidden = true
            }
        }
    }
    //Text appear and disappear when single tapped
    @objc func singleTapped(){
        if let text = Image?.description{
            foodDescription.text = text
            foodDescription.isHidden = !foodDescription.isHidden
        }
    }
    //Left swipe animation and random image appear
    @objc func leftSwipped(){
        animationView.transform = CGAffineTransform(translationX: 0, y: 0)
        let animateLeft = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0) })

        animateLeft.addCompletion{ (position) in
            print("\(#function)")
            self.foodDescription.isHidden = true
            self.foodDescription.text = ""
            if(self.i>9){
                self.i=1
                self.loadImages()
            }else{
                let url = URL(string: self.images[self.i].urls?.regular ?? "")
                self.Image = self.images[self.i]
                self.foodImageView.kf.setImage(with: url)
                self.i = self.i+1
            }
            self.animationView.transform = CGAffineTransform(translationX: self.view.frame.size.width , y: 0)
            let animateLeft1 = UIViewPropertyAnimator(duration: 0.7, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: 0, y: 0) })
            animateLeft1.startAnimation()
            
        }
        animateLeft.startAnimation()
        
    }
    //Right swipe animation and random image appear
    @objc func rightSwipped(){
        animationView.transform = CGAffineTransform(translationX: 0, y: 0)
        let animateRight = UIViewPropertyAnimator(duration: 0.4, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0) })
        animateRight.addCompletion{ (position) in
            self.foodDescription.isHidden = true
            self.foodDescription.text = ""
            if(self.i>9){
                self.i=1
                self.loadImages()
            }else{
                let url = URL(string: self.images[self.i].urls?.regular ?? "")
                self.Image = self.images[self.i]
                self.foodImageView.kf.setImage(with: url)
                self.i = self.i+1
            }
            self.animationView.transform = CGAffineTransform(translationX: -self.view.frame.size.width , y: 0)
            let animateRight1 = UIViewPropertyAnimator(duration: 0.7, curve: .linear, animations: {() in self.animationView.transform = CGAffineTransform(translationX: 0, y: 0) })
            animateRight1.startAnimation()
            }
        animateRight.startAnimation()
    }
}



