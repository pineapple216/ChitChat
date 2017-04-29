/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
    var currentUser: FIRUser?
//    var currentUser = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if (emailTextField.text?.isEmpty)! {
            self.displayAlertForError(title: "Error", message: "Please enter a valid email adres", senderTextField: self.emailTextField)
        }
        else if (passwordTextField.text?.isEmpty)! || (passwordTextField.text?.characters.count)! < 6 {
            self.displayAlertForError(title: "Error", message: "Please enter a valid password", senderTextField: self.passwordTextField)
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                
                if error != nil {
                    self.displayAlertForError(title: "Error", message: (error?.localizedDescription)!, senderTextField: nil)
                }
                else {
                    print("You have succesfully logged in!")
                    self.currentUser = FIRAuth.auth()?.currentUser
                    self.performSegue(withIdentifier: "LoginToChat", sender: nil)
                }
            })
        }
    }
    
    // MARK: - Helper Methods
    
    func displayAlertForError(title: String, message: String, senderTextField: UITextField?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if senderTextField != nil {
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alertAction) in
                senderTextField?.becomeFirstResponder()
            }))
            present(alertController, animated: true, completion: nil)
        }
        else {
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "LoginToChat" {
            let tabVC = segue.destination as! UITabBarController
            let navVC = tabVC.viewControllers?.first as! UINavigationController
            let channelVC = storyboard?.instantiateViewController(withIdentifier: "channelListVC") as! ChannelListViewController
            navVC.viewControllers = [channelVC]
            channelVC.senderDisplayName = currentUser?.displayName
        }
    }
  
}

