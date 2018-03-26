//
//  LoginViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 06.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseFacebookAuthUI
import CoreData
import Firebase

class LoginViewController: UIViewController {
    
    var loginText = ""
    let funcRoomVC = ReallyGoodViewController()
    //let authViewController = authUI(LoginViewController).authViewController()
    
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var steckViewLogin: UIStackView!
    // MARK: - Outlets
    // Два текстовых поля на экране "Входа"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Отображение сообщения об ошибки
    @IBOutlet weak var warningLabel: UILabel!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fireBaseDataChat2()
        dowloadsListRoom()
        observeMessageStruct()
        print(loginText)
        emailTextField.text = loginText
        // Появление и скрытие клавы
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        displayHelloLabel()
        
        
    }
    
    
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    // Скрывает label с приветсвием
    func displayHelloLabel() {
        UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
            self.helloLabel.alpha = 0
        }, completion: nil)
    }
    
    
    // Появление клавы - делает смещение элементов на 50 поитов
    @objc func keyboardWillShow(notification: NSNotification) {
        print("HELLO")
        if self.view.frame.origin.y == 0{
            self.helloLabel.frame.size = CGSize(width: self.view.bounds.size.width - 30, height: self.view.bounds.size.height - 300)
            self.view.frame.origin.y -= 50
            
        }
        
    }
    // Скрытие элементов возвращает все в исходное положение
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.helloLabel.frame.size = CGSize(width: 30, height: 300)
            self.view.frame.origin.y += 50
            
        }
    }
    // Когда клава активна: нажатие на любом участке экрана - скрывает клаву
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
                //nameUser = email
                print(nameUser)
                userIdNameJSQ = (self?.emailTextField.text!)!
                // переход в окно чата ( переход без segue! )
                let listViewController = self?.storyboard?.instantiateViewController(withIdentifier: "chatListViewController")
                let sendData = self?.storyboard?.instantiateViewController(withIdentifier: "roomVC") as! ReallyGoodViewController
                // sendData.nameUser = email
                listViewController?.addChildViewController(sendData)
                
                //sendData.nameUser = email
                //sendData.nameUser =
                
                self?.present(listViewController!, animated: false, completion: nil)
                
            } else {
                self?.displayWarningLabel(withText: "Неверные данные")
                return
            }
        }
    }
    
    // Ярослав
    // Label: выводит информацию с ошибкой
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
    
    
    
    
    
    var refMessages: DatabaseReference!
    var messageToVC: [Messages] = []
    var arrayListRoom: [Messages] = []
    var refMessagesCount: DatabaseReference!
    var messageCount: [Messages] = []
    // для Firebase
    //
    // Название для комнат
    let room = ["Курилка", "18+", "Все рядом", "no name", "desk"]
    var lastRoomMessage = [String]()
    var lastRoomEmail = [String]()
    var lastRoomMessageCount = [String]()
    //
    // Имена комнат в базе ( временно )
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    
    // Имя пользователя под которым мы зашли
    
    var ref: DatabaseReference!
    var task: [Contact] = []
    
    //
    // Ярослав
    
    
    
    func fireBaseDataChat3(text: String) {
        
        refMessagesCount = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(text)
    }
    func fireBaseDataChat2() {
        
        refMessages = Database.database().reference(withPath: "Geo_chat").child("ROOM")
    }
    func dowloadsListRoom() {
        refMessages.observe(.value) { [weak self] (snapshot) in
            let index = Int(snapshot.childrenCount)
            print("index = \(index)")
            
            
            for int in 0..<5 {
                
                print("первый цикл - выполняется \(int + 1)ый раз")
                self?.fireBaseDataChat3(text: (self?.roomSend[int])!)
                self?.refMessagesCount.observe(.value, with: { (snapshot) in
                    var _listMessages = Array<Messages>()
                    
                    for i in snapshot.children {
                        let task = Messages(snapshot: i as! DataSnapshot)
                        
                        _listMessages.append(task)
                    }
                    self?.messageCount = _listMessages
                    
                    if (self?.messageCount.count)! <= 0 {
                        self?.lastRoomEmail.append("no user")
                        self?.lastRoomMessage.append("no message")
                        self?.lastRoomMessageCount.append("0")
                    } else {
                        let deleteMessage = self?.messageCount.removeLast()
                        print((deleteMessage?.message)!)
                        self?.lastRoomEmail.append((deleteMessage?.nameUser)!)
                        self?.lastRoomMessage.append((deleteMessage?.message)!)
                        self?.lastRoomMessageCount.append("\((self?.messageCount.count)! + 1)")
                        print((deleteMessage?.date)!)
                        
                        
                    }
                    
                    
                    lastRoomMessageSend = (self?.lastRoomMessage)!
                    lastRoomMessageEmail = (self?.lastRoomEmail)!
                    messageCountCell = (self?.lastRoomMessageCount)!
                    
                })
                
            }
            
            
            
        }
        
        
        
        observeMessageStruct()
    }
    
    func observeMessageStruct() {
        print("4")
        for i in 0..<messageCount.count {
            
            print(">>>>>message \(messageCount[i].message)")
        }
    }
    
    
    
}
