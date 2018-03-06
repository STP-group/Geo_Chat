//
//  LoginViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.text = ""
    }

    
    
    @IBAction func loginAuthentication(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text,emailTextField.text != "", passwordTextField.text != ""  else {
// alertController
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            if error != nil {
// AlertController
                return
            }
            if user != nil {
// переход в окно чата
                let listViewController = self?.storyboard?.instantiateViewController(withIdentifier: "chatListViewController")
                self?.present(listViewController!, animated: false, completion: nil)
                return
            }
        }
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
