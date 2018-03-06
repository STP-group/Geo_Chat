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
    
    
    // Два текстовых поля на экране "Входа"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var worningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
// Задание
// alertController
// Добавить окно с предупреждением - "не все поля заполнены"
            return
        }
        
        // Авторизация на сервере Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            if error != nil {
// Задание
// Изменить worningLabel на "error server"
                return
            }
            
            if user != nil {
                // переход в окно чата ( переход без segue! )
                let listViewController = self?.storyboard?.instantiateViewController(withIdentifier: "chatListViewController")
                self?.present(listViewController!, animated: false, completion: nil)
                
            } else {
// Задание
// Изменить worningLabel на "неверные данные"
                
                return
            }
        }
        
    }
    
    
}
