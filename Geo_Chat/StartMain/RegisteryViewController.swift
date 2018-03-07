//
//  RegisteryViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase


class RegisteryViewController: UIViewController {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var twoPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func registeryButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, emailTextField.text != "", passwordTextField.text != "", passwordTextField.text == twoPasswordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if user != nil {
                    let alertController = UIAlertController(title: "Поздравляем", message: "Регистрация прошла успешно", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                        self.present(loginViewController!, animated: true, completion: nil)
                    })
                    alertController.addAction(cancelButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                    print("ok")
                } else {
                    print("not create")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
