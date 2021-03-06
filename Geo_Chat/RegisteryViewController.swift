//
//  RegisteryViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import Firebase


class RegisteryViewController: UIViewController, UITextFieldDelegate {
    
    
    // Теvarстовые поля для регистрации
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var twoPasswordTextField: UITextField!
    //
    @IBOutlet weak var labelRegisterNewUser: UILabel!
    
    var user: UsersInfo!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowRegistery), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideRegistery), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //
        guard let currentUser = Auth.auth().currentUser else { return }
        // user
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "Geo_chat")
        
        // Появление и скрытие клавы
        
        
        nickNameTextField.delegate = self
        nickNameTextField.returnKeyType = .next
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .next
        twoPasswordTextField.delegate = self
        twoPasswordTextField.returnKeyType = .next
        emailTextField.delegate = self
        }
    
    
    // Ярослав
    //
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.text?.index(of: " ") != nil {
//            print("errore")
//        } else {
//            print("nil")
//        }
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text?.index(of: " ") != nil {
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return false
//        } else {
//            return true
//        }
//    }
    
    //  Следит в реальном времени за текстом
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.text?.index(of: " ") != nil {
//            textField.text?.append("_")
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            print("2")
//        } else {
//            print("1")
//        }
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text?.index(of: " ") != nil {
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            print("3")
//        } else {
//            print("4")
//        }
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text?.index(of: " ") != nil {
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return false
//        } else {
//            return true
//        }
//    }
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        if textField.text?.index(of: " ") != nil {
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            print("5")
//        } else {
//            print("6")
//        }
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.length + range.location > passwordTextField.text?.characters.count
//        if length < 6 {
//            return false
//        }
//
//        return true
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.text?.index(of: " ") != nil, (passwordTextField.text?.count)! <= 5 {
//            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return false
//        }
//    
//        if textField == nickNameTextField {
//            passwordTextField.becomeFirstResponder()
//        } else if textField == passwordTextField {
//            twoPasswordTextField.becomeFirstResponder()
//        } else if textField == twoPasswordTextField {
//            emailTextField.becomeFirstResponder()
//        } else if textField == emailTextField {
//            textField.resignFirstResponder()
//            self.view.endEditing(true)
//            registeryButton()
//        }
//        return false
//    }
    
    func displayNewUserIn() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {

            self.labelRegisterNewUser.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            self.labelRegisterNewUser.frame.origin.y += 35
        }, completion: nil)
    }
 
    
    func displayNewUserOut() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.labelRegisterNewUser.transform = CGAffineTransform(scaleX: 1, y: 1)
          self.labelRegisterNewUser.frame.origin.y -= 35
        }, completion: nil)
    }
    
    // Появление клавы - делает смещение элементов на 50 поитов
    @objc func keyboardWillShowRegistery(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 110
            displayNewUserIn()
        }
        
    }
    
    // Скрытие элементов возвращает все в исходное положение
    @objc func keyboardWillHideRegistery(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 110
            displayNewUserOut()
        }
    }
    
    // Когда клава активна: нажатие на любом участке экрана - скрывает клаву
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Функция для создания на сервере листа списка контактов
    func newContactList(name: String, email: String) {
        let list = Contact(name: name, email: email)
        let listRef = (self.ref.child("Users").child(list.name))
        listRef.setValue(["name": list.name, "email": list.email])
    }
    
    // Кнопка регистрации
//    @IBAction func registeryButton(/*_ sender: UIButton*/) {
//        // Проверяем текстовые поля на наличие текста и совпадения пароля
//        // Если все правила не соблюдены - то выходим из данного метода
//        // { return }
//        guard let email = emailTextField.text, let password = passwordTextField.text, emailTextField.text != "", passwordTextField.text != "", passwordTextField.text == twoPasswordTextField.text else { return }
//        // Регистрация на сервере
//        
//        // Присвоение email и password
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//            if error == nil {
//                if user != nil {
//                    // AlertController c успешной регистрацией
//                    let alertController = UIAlertController(title: "Поздравляем", message: "Регистрация прошла успешно", preferredStyle: .alert)
//                    let cancelButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                        loginViewController.loginText = email
//                        print(email)
//                        self.present(loginViewController, animated: true, completion: nil)
//                    })
//                    alertController.addAction(cancelButton)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    
//                    self.newContactList(name: self.nickNameTextField.text!, email: self.emailTextField.text!)
//                    print("ok")
//                } else {
//                    print("not create")
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//        
//    }
    
    // Вернутся назад
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
