//
//  LoginViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var steckViewLogin: UIStackView!
    // MARK: - Outlets
    // Два текстовых поля на экране "Входа"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        displayHelloLabel()
        
    }
    func displayHelloLabel() {
        UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
            self.helloLabel.alpha = 0
        }, completion: nil)
    }
    
   
    @objc func keyboardWillShow(notification: NSNotification) {
        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            if self.view.frame.origin.y == 0{
                self.helloLabel.frame.size = CGSize(width: self.view.bounds.size.width - 30, height: self.view.bounds.size.height - 300)
                self.view.frame.origin.y -= 50
//            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.helloLabel.frame.size = CGSize(width: 30, height: 300)
                self.view.frame.origin.y += 50
            //}
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldEdit(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }

    // Очищает строку пароля - когда нажимаешь выход ( из списка комнат )
    // viewWillAppear - срабатывает перед тем как отобразить экран
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.text = ""
    }

    
    
    // Кнопка входа
    @IBAction func loginAuthentication(_ sender: UIButton) {
        // Две константы для авторизации
        // Проверяем - логин и пароль не должны быть пустыми
        // Используем guard для проверки, если пусто - то просто выходим из метода ( return )
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
                  emailTextField.text != "",
                  passwordTextField.text != ""  else {
                    let alertController = UIAlertController(title: "Ошибка", message: "Не все поля заполнены", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(cancelButton)
                    present(alertController, animated: true, completion: nil)
                    return
                    }
        
        // Авторизация на сервере Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Неверные данные2")
                return
            }
            
            if user != nil {
                 
                // переход в окно чата ( переход без segue! )
                let listViewController = self?.storyboard?.instantiateViewController(withIdentifier: "chatListViewController")
                self?.present(listViewController!, animated: false, completion: nil)
                
            } else {
                self?.displayWarningLabel(withText: "Неверные данные")
                return
            }
        }
    }
    
    func displayWarningLabel (withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.warningLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 5.0, options: [], animations: {
                self.warningLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    
}
