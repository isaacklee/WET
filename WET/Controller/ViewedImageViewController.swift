//
//  ViewedImageViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/05/04.
//

import Kingfisher
import UIKit
import FirebaseDatabase
import FirebaseAuth


class ViewedImageViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mainView: UIView!
    //singleton for firebase database
    private let database = Database.database().reference()
    //set current user
    private let user = FirebaseAuth.Auth.auth().currentUser
    var selectedimageUrl = [String]()
    var selectedCell:ImageCell? = nil
    
    //Set background and initial setting
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectedimageurl = {""}
        self.mainView.backgroundColor = UIColor(patternImage: UIImage(named: "2bg")!)
    
        self.collectionView.reloadData()
    }
    //Reload data
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    //Number of Section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //Number of Items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RestaurantViewController.viewedImages.count
    }
    
    //Upload image for cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        let url = URL(string: RestaurantViewController.viewedImages[indexPath.row])
        let resource = ImageResource(downloadURL: url!)
        cell.viewedImage.kf.setImage(with: resource)
        selectedCell = cell
        return cell
    }
    
    //Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/1.5
        return CGSize(width: width, height: width)
    }
    //Set linespacing to 30
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    //Set interitem spacing to 30
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    //when Item tapped save to photo library also to Firebase
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myImage = RestaurantViewController.viewedImages[indexPath.row]
        selectedimageUrl.append(myImage)
        let url = URL(string:myImage)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            let alert = UIAlertController(title: "Saved", message: "Image Saved!!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        //Save to firebase
        if let uid = user?.uid{
            database.child(uid).setValue(selectedimageUrl)
          
        }
    }
    //Load button loads the saved images
    @IBAction func loadButtonDidTapped(_ sender: UIButton) {
        if let uid = user?.uid{
            database.child(uid).observe(.value) { (snapshot) in
                if snapshot.value != nil{
                    print(snapshot.value!)
                    RestaurantViewController.viewedImages.append(contentsOf: snapshot.value as! [String])
                        
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
