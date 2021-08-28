//
//  IndexViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/28.
//

import Foundation
import Kingfisher
import UIKit
import FirebaseAuth
import JGProgressHUD


class IndexViewController:UIViewController, UITextFieldDelegate, UITextViewDelegate {
    //Set up for HUD
    let hud:JGProgressHUD = {
        let hud = JGProgressHUD(style:.dark)
        hud.style = .dark
        hud.interactionType = .blockAllTouches
        return hud
    }()
    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var MainImage: UIImageView!
    var email :String = ""
    var password:String = ""
    
    //Set delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        
    }
    //Using delegate, FirstResponder Changes when return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            emailTextField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        }
        if textField == passwordTextfield {
            emailTextField.resignFirstResponder()
            passwordTextfield.resignFirstResponder()
        }
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    //Condition check before Signin
    @IBAction func signInDidTapped(_ sender: UIButton) {
        print("button tapped")
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextfield.text, !password.isEmpty else{
            // Create new Alert
            let fieldMissing = UIAlertController(title: "Field Missing!", message: "Email or Password Missing!!", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            fieldMissing.addAction(ok)
            // Present Alert 
            self.present(fieldMissing, animated: true, completion: nil)
            emailTextField.text = ""
            passwordTextfield.text = ""
            
            return
        }
        guard let _ = passwordTextfield.text,password.count>=6 else{
            let passwordCount = UIAlertController(title: "Password Too Short", message: "Password Must Be Longer Than 6 Characters", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            //Add OK button to a dialog message
            passwordCount.addAction(ok)
            // Present Alert to
            self.present(passwordCount, animated: true, completion: nil)
            passwordTextfield.text = ""
            return
        }
        //Using Firebase Auth Signin
        hud.textLabel.text = "Welcome to WET"
        hud.show(in: view, animated: true)
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                self?.hud.dismiss(animated: true)
                strongSelf.showCreatedAccount(email: email, password: password)
                return
            }
            self?.hud.dismiss(animated: true)
            print("Signed In!!")
            strongSelf.signIn.isHidden = true
            strongSelf.emailTextField.isHidden = true
            strongSelf.passwordTextfield.isHidden = true
            strongSelf.signInButton.isHidden = true
           
            //When Signin successfull move to Restaurant ViewController
            self?.performSegue(withIdentifier: "signInSegue", sender: nil)
            
        })
    }
    //Create user and related alerts
    func showCreatedAccount(email:String, password:String){
        let alert = UIAlertController(title: "Create WET Account", message: "Would You Like To Create WET Account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            self.hud.textLabel.text = "Welcome to WET"
            self.hud.show(in: self.view, animated: true)
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] (result, error) in
                guard let strongSelf = self else{
                    return
                }
                guard error == nil else{
                    print("account creation failed")
                    return
                }
                print("Signed In!!")

                strongSelf.signIn.isHidden = true
                strongSelf.emailTextField.isHidden = true
                strongSelf.passwordTextfield.isHidden = true
                strongSelf.signInButton.isHidden = true
                self?.performSegue(withIdentifier: "signInSegue", sender: nil)
                self?.hud.dismiss(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        present(alert, animated: true)
    }

}

