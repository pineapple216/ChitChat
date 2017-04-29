//
//  ResetPasswordViewController.swift
//  ChitChat
//
//  Created by Koen Hendriks on 10/03/2017.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    // MARK: - outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        if (self.emailTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid emailadres", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                self.emailTextField.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error resetting password"
                    message = (error?.localizedDescription)!
                }
                else {
                    title = "Success"
                    message = "Succesfully reset password, please check your email."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                    if error != nil {
                        self.emailTextField.becomeFirstResponder()
                    }
                    else {
                        self.performSegue(withIdentifier: "ResetToLogin", sender: nil)
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
