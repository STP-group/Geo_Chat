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
    
    
    // Теvarстовые поля для регистрации
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var twoPasswordTextField: UITextField!
    
    
    var user: UsersInfo!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "Geo_chat")
       

       
    }
    // Функция для создания на сервере листа списка контактов
    func newContactList(name: String, email: String) {
        let list = Contact(name: name, email: email)
        let listRef = self.ref.child("Users").child(list.name)
        listRef.setValue(["name": list.name, "email": list.email])
    }
    
    // Кнопка регистрации
    @IBAction func registeryButton(_ sender: UIButton) {
        // Проверяем текстовые поля на наличие текста и совпадения пароля
        // Если все правила не соблюдены - то выходим из данного метода
        // { return }
        guard let email = emailTextField.text, let password = passwordTextField.text, emailTextField.text != "", passwordTextField.text != "", passwordTextField.text == twoPasswordTextField.text else { return }
        // Регистрация на сервере
        
        // Присвоение email и password
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if user != nil {
                    // AlertController c успешной регистрацией
                    let alertController = UIAlertController(title: "Поздравляем", message: "Регистрация прошла успешно", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        loginViewController.loginText = email
                        print(email)
                        self.present(loginViewController, animated: true, completion: nil)
                    })
                    alertController.addAction(cancelButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    self.newContactList(name: self.nickNameTextField.text!, email: self.emailTextField.text!)
                    print("ok")
                } else {
                    print("not create")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    // Вернутся назад
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
