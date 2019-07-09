//
//  loginViewController.swift
//  FoodTracker
//
//  Created by Cameron Mcleod on 2019-07-08.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userState: UISegmentedControl!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    
    var cloudTrackerAPI = CloudTrackerAPI()
    var pleaseWaitAlert: UIAlertController?
    var newUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        imageTapRecognizer.addTarget(self, action: #selector(handleTap(gestureRecognizer:)))
        
        let hasSavedCredentials = UserDefaults.standard.bool(forKey: "user_has_credentials")
        
        if !hasSavedCredentials {
            newUser = true
            userState.selectedSegmentIndex = 1
        } else {
            usernameTextField.text = UserDefaults.standard.string(forKey: "current_user_name")
            passwordTextField.text = UserDefaults.standard.string(forKey: "current_user_password")
            loginButton.isEnabled = true
            newUser = false
            userState.selectedSegmentIndex = 0
        }
        
        // Enable the login button only if there is a username and password
        updateLoginButtonState()
    }

    // MARK: - Navigation
    
    @IBAction func signUpOrLogin(_ sender: UIButton) {
        
        cloudTrackerAPI.userLogin(username: usernameTextField.text, password: passwordTextField.text, newUser: newUser) { userReturned in
            
            self.pleaseWaitAlert?.dismiss(animated: false, completion: {
                if let user = userReturned {
                    UserDefaults.standard.set(true, forKey: "user_has_credentials")
                    UserDefaults.standard.set(user.username, forKey: "current_user_name")
                    UserDefaults.standard.set(user.token, forKey: "current_user_token")
                    UserDefaults.standard.set(user.id, forKey: "current_user_id")
                    UserDefaults.standard.set(user.password, forKey: "current_user_password")
                    self.performSegue(withIdentifier: "UserLogin", sender: self)
                    
                    
                } else {
                    UserDefaults.standard.set(false, forKey: "user_has_credentials")
                    self.errorSigningUpAlert(errorTitle: "Error Signing Up")
                    
                }
                
            })
            
        }
        
        pleaseWaitAlert = UIAlertController(title: nil, message: "Accessing Server, Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        pleaseWaitAlert!.view.addSubview(loadingIndicator)
        
        present(pleaseWaitAlert!, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButton.becomeFirstResponder()
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing username
        if textField == usernameTextField {
            loginButton.isEnabled = false
        } else {
            if usernameTextField.text == ""  {
                loginButton.isEnabled = false
            } else {
            loginButton.isEnabled = true
            }
        }

    }
    
    @IBAction func userStateChanged(_ sender: UISegmentedControl) {
        newUser = sender.selectedSegmentIndex == 1 ? true : false
    }
    
    //MARK: Animations
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        
//        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
//            self.foodImageView.alpha = 0.8
//            self.foodImageView.transform = self.foodImageView.transform.rotated(by: .pi/32)
//        }, completion: { (true) in
//            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
//                self.foodImageView.transform = self.foodImageView.transform.rotated(by: -.pi/16)
//            }, completion: { (true) in
//                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
//                    self.foodImageView.alpha = 1
//                    self.foodImageView.transform = self.foodImageView.transform.rotated(by: .pi/32)
//                })
//            })
//        })
        
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.foodImageView.alpha = 0.8
                self.foodImageView.transform = self.foodImageView.transform.rotated(by: .pi/32)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.foodImageView.transform = self.foodImageView.transform.rotated(by: -.pi/16)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: {
                self.foodImageView.alpha = 1
                self.foodImageView.transform = self.foodImageView.transform.rotated(by: .pi/32)
            })
            
        })
        
    }
    
    //MARK: Private Methods
    private func updateLoginButtonState() {
        // Disable the Save button if the username or password fields are empty
        let passwordText = passwordTextField.text ?? ""
        let usernameText = passwordTextField.text ?? ""
        loginButton.isEnabled = !passwordText.isEmpty && !usernameText.isEmpty
    }

    private func errorSigningUpAlert (errorTitle : String) {
        
        let alertController = UIAlertController(title: errorTitle, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil )
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
        
    }

}


