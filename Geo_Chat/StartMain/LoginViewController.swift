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
    
    // MARK: - Outlets
    // Два текстовых поля на экране "Входа"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Очищает строку пароля - когда нажимаешь выход ( из списка комнат )
    // viewWillAppear - срабатывает перед тем как отобразить экран
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.text = ""
    }

    func saveDataCoreData() {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let dataUsers = UserData(context: context!)
        dataUsers.email = emailTextField.text
        
        do {
            try context?.save()
            print("save complete")
        } catch let error as NSError {
            print("Не удалось сохранить данные \(error), \(error.userInfo)")
        }
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
                self?.displayWarningLabel(withText: "Server error")
                return
            }
            
            if user != nil {
                 self?.saveDataCoreData()
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
