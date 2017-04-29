//
//  SignUpViewController.swift
//  ChitChat
//
//  Created by Koen Hendriks on 10/03/2017.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    
    
    // MARK: - Actions
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        if(usernameTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Invalid Username", message: "Please enter a valid username", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                self.usernameTextField.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else if (emailTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Invalid Emailadres", message: "Please enter a valid emailadres", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                self.emailTextField.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else if (passwordTextField.text?.isEmpty)! || (passwordTextField.text?.characters.count)! < 6 {
            let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password of at least 6 characters", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                self.passwordTextField.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else if passwordTextField.text != verifyPasswordTextField.text {
            let alertController = UIAlertController(title: "Passwords don't match", message: "The entered passwords don't match", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                self.verifyPasswordTextField.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                if error != nil {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    print("You have succesfully signed up!")
                    self.addUsername()
                }
            })
        }
    }
    
    // MARK: - Helper Methods
    
    func addUsername() {
        // Update the users display name
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = self.usernameTextField.text
        changeRequest?.commitChanges(completion: { (error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        })
        self.performSegue(withIdentifier: "SignUpToChat", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SignUpToChat" {
            let tabVc = segue.destination as! UITabBarController
            let navVc = tabVc.viewControllers?.first as! UINavigationController
            
            let channelVc = storyboard?.instantiateViewController(withIdentifier: "channelListVC") as! ChannelListViewController
            navVc.viewControllers = [channelVc]
            
            channelVc.senderDisplayName = self.usernameTextField.text
        }
    }

}
