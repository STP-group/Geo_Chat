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
import Firebase
import CoreLocation
import MapKit

var loginText = ""

class LoginViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // Location
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    
    @IBOutlet var viewLogin: UIView!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.layer.cornerRadius = 25
            mapView.layer.borderWidth = 3
            mapView.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var steckViewLogin: UIStackView!
    // MARK: - Outlets
    
    // Два текстовых поля на экране "Входа"
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            emailTextField.layer.cornerRadius = 10
            emailTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            passwordTextField.layer.cornerRadius = 10
            passwordTextField.layer.masksToBounds = true
        }
    }
    
    // Отображение сообщения об ошибки
    @IBOutlet weak var warningLabel: UILabel!
    
    // Рагистрация
    @IBOutlet weak var nickNameTextFieldRegistery: UITextField!
    @IBOutlet weak var emailTextFieldRegistery: UITextField!
    @IBOutlet weak var passwordTextFieldRegistery: UITextField!
    @IBOutlet weak var twoPasswordTextFieldRegistery: UITextField!
    @IBOutlet weak var labelRegisterNewUserRegistery: UILabel!
    @IBOutlet var registeryView: UIView! {
        didSet {
            registeryView.layer.cornerRadius = 15
            registeryView.layer.shadowOffset = CGSize.init(width: 4, height: 4)
            registeryView.layer.borderWidth = 2
            registeryView.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            registeryView.layer.masksToBounds = true
        }
    }
    // Блюр эффект
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    // Переменные для вызова функций из других классов
    var animationView = AnimationViewRegistery()
    var mapPointView = MapLogo()
    var registeryUser = RegisterFirebase()
    var ref: DatabaseReference!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "Geo_chat")
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true
        mapView.alpha = 0
        
        // Текстовые поля регистрации
        nickNameTextFieldRegistery.delegate = self
        self.nickNameTextFieldRegistery.keyboardType = UIKeyboardType.emailAddress
        nickNameTextFieldRegistery.returnKeyType = .next
        passwordTextFieldRegistery.delegate = self
        passwordTextFieldRegistery.returnKeyType = .next
        twoPasswordTextFieldRegistery.delegate = self
        twoPasswordTextFieldRegistery.returnKeyType = .next
        emailTextFieldRegistery.delegate = self
        emailTextFieldRegistery.keyboardType = .emailAddress
        emailTextFieldRegistery.returnKeyType = .done
        
        
        
        
        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        updateCurrentLocation()
        
        
        
        emailTextField.text = loginText
        
        
        // Появление и скрытие клавы
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Приветствие -> исчезает через 2,5 сек.
        displayHelloLabel()
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
    }
    
    //
    //
    // Переключает поле ввода при нажатии на Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.index(of: " ") != nil, (passwordTextFieldRegistery.text?.count)! <= 5 {
            let alert = UIAlertController(title: "Ошибка", message: "Текст не должен содержать пробелы", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginAuthentication()
        }
        
        if textField == nickNameTextFieldRegistery {
            passwordTextFieldRegistery.becomeFirstResponder()
        } else if textField == passwordTextFieldRegistery {
            twoPasswordTextFieldRegistery.becomeFirstResponder()
        } else if textField == twoPasswordTextFieldRegistery {
            emailTextFieldRegistery.becomeFirstResponder()
        } else if textField == emailTextFieldRegistery {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            registeryButton()
        }
        return false
    }
    
    
    
    
    
    
    
    
    // Кординаты комнаты
    var roomCordinates = CLLocationCoordinate2D(latitude: 55.978827, longitude: 37.158806)
    // Кординаты пользователя - который хачет зайти в комнату 55.985439, 37.179774 ( 55.978497, 37.158463 )
    var guestUserCortinate = CLLocationCoordinate2D(latitude: 55.978497, longitude: 37.158463)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "LAT")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "LON")
        UserDefaults().synchronize()
        
        //createPin()
        userLocationLatitude = userLocation.coordinate.latitude
        userLocationLongitude = userLocation.coordinate.longitude
        mapPointView.pointMarkToMaps(mapView: mapView, guestUserCortinate: guestUserCortinate, userLocationLatitude: userLocationLatitude)
        mapPointView.createPin(mapView: mapView)
        locationManager.stopUpdatingLocation()
    }
    
    // Обновление кординат
    private func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    //    func application(_ app: UIApplication, open url: URL,
    //                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    //        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
    //
    //         if Auth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
    //            return true
    //        }
    //
    //        return false
    //    }
    
    // Скрывает label с приветсвием
    func displayHelloLabel() {
        UIView.animate(withDuration: 0.5, delay: 2.5, options: [], animations: {
            self.helloLabel.alpha = 0
            self.displayMapView()
        }, completion: nil)
    }
    func displayMapView() {
        UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
            self.mapView.alpha = 1
        }, completion: nil)
    }
    
    // Появление клавы - делает смещение элементов на 50 поитов
    @objc func keyboardWillShow(notification: NSNotification) {
        // print("HELLO")
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
    
    // Очищает строку пароля - когда нажимаешь выход ( из списка комнат )
    // viewWillAppear - срабатывает перед тем как отобразить экран
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.text = ""
    }
    
    // Кнопка входа
    @IBAction func loginAuthentication(/*_ sender: UIButton*/) {
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
                self?.displayWarningLabel(withText: "Неверный логин или пароль")
                return
            }
            
            if user != nil {
                userIdNameJSQ = (self?.emailTextField.text!)!
                
                self?.performSegue(withIdentifier: "testSegue", sender: nil)
                return
            } else {
                self?.displayWarningLabel(withText: "Ошибка на сервере")
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
    
    
    
    @IBAction func registeryView(_ sender: UIButton) {
        //animationViewIn()
        animationView.animationViewIn(globalView: viewLogin, showView: registeryView, visualEffect: visualEffectView, effecView: effect)
    }
    
    
    @IBAction func cancelRegistery(_ sender: UIButton) {
        //animationViewOut()
        animationView.animationViewOut(globalView: viewLogin, showView: registeryView, visualEffect: visualEffectView, effecView: effect)
    }
    @IBAction func registeryButton(/*_ sender: UIButton*/) {
        // Проверяем текстовые поля на наличие текста и совпадения пароля
        // Если все правила не соблюдены - то выходим из данного метода
        // { return }
        guard let email = emailTextFieldRegistery.text, let password = passwordTextFieldRegistery.text, emailTextFieldRegistery.text != "", passwordTextFieldRegistery.text != "", passwordTextFieldRegistery.text == twoPasswordTextFieldRegistery.text else { return }
        // Регистрация на сервере
        
        // Присвоение email и password
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if user != nil {
                    // AlertController c успешной регистрацией
                    let alertController = UIAlertController(title: "Поздравляем", message: "Регистрация прошла успешно", preferredStyle: .alert)
                    let cancelButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        loginText = email
                        print(email)
                        self.present(loginViewController, animated: true, completion: nil)
                    })
                    alertController.addAction(cancelButton)
                    self.present(alertController, animated: true, completion: nil)
                    self.registeryUser.newContactList(name: self.nickNameTextFieldRegistery.text!, email: self.emailTextFieldRegistery.text!, ref: self.ref)
                } else {
                    return
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
}

