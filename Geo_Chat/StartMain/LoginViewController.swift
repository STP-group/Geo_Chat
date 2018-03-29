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
import CoreLocation
import MapKit

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    var loginText = ""
    
    // Location
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    
    
    @IBOutlet weak var mapView: MKMapView!
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
        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        updateCurrentLocation()
        
        // выполнение функций для загрузки последних сообщений
        dowloadsListRoomPartTwo()
        dowloadsListRoomPartOne()
        
        
        
        emailTextField.text = loginText
        // Появление и скрытие клавы
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        displayHelloLabel()
    }
    
    // Кординаты комнаты
    var roomCordinates = CLLocationCoordinate2D(latitude: 55.978827, longitude: 37.158806)
    // Кординаты пользователя - который хачет зайти в комнату 55.985439, 37.179774
    var guestUserCortinate = CLLocationCoordinate2D(latitude: 55.985439, longitude: 37.179774)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "LAT")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "LON")
        UserDefaults().synchronize()
        createPin()
        
        print(userLocation.coordinate.latitude)
        print(userLocation.coordinate.longitude)
        userLocationLatitude = userLocation.coordinate.latitude
        userLocationLongitude = userLocation.coordinate.longitude
        
        pointMarkToMaps()
    }
    func pointMarkToMaps() {
        
        // Присвоение кординат комнаты для расчета растояния
        let locationRoom = CLLocation(latitude: userLocationLatitude, longitude: userLocationLongitude)
        // Присвоение кординат пользователя для расчета растояния
        let locationGuest = CLLocation(latitude: guestUserCortinate.latitude, longitude: guestUserCortinate.longitude)
        // Вычисляем расстояние между комнатой и пользователем
        let distanceInMeters = locationRoom.distance(from: locationGuest)
        
        // переводим в целое число ( пример: из 513.212405045983 в 513 )
        let subTitleText = "\(distanceInMeters)".components(separatedBy: ".")
        
        // Тип расстояния - если расстояние больше 1000метров - то отображается в км, если меньше то в м
        // Нужно доработать  - если расстояние в километрах - то показывает Пример: 3.26км !
        var typyDistantion = ""
        if distanceInMeters >= 1000 {
            typyDistantion = "км"
        } else {
            typyDistantion = "м"
        }
        
        // Ставим точку на карте ( для тестирования )
        let placeMarkPointAnotation = MKPointAnnotation()
        // Имя точки
        placeMarkPointAnotation.title = "Я тут"
        // Растояние отображается на точке ( смотреть чуть выше )
        placeMarkPointAnotation.subtitle = "\(subTitleText[0])m"
        
        // Точка на карте - используется кординаты комнаты
        placeMarkPointAnotation.coordinate.latitude = userLocationLatitude
        placeMarkPointAnotation.coordinate.longitude = userLocationLongitude
        //roomCordinates
        // принт расстояния
        print("растояние \(distanceInMeters)")
        if distanceInMeters >= 500.0 {
            print(">500")
        } else {
            print("<500")
        }
        
        // отображение на карте
        self.mapView.showAnnotations([placeMarkPointAnotation], animated: true)
        self.mapView.selectAnnotation(placeMarkPointAnotation, animated: true)
    }
    
    // Обновление кординат
    private func updateCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Получаем наши кординаты
    
    
    func createPin(){
        
        //Access user Location LAT & LON from User Defaults
        let coordinate =  CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        region.center = coordinate
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
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
                userIdNameJSQ = (self?.emailTextField.text!)!
                
                self?.performSegue(withIdentifier: "testSegue", sender: nil)
                return
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
    var lastRoomDate = [String]()
    //
    // Имена комнат в базе ( временно )
    let roomSend = ["numberOne", "numberTwo", "numberThree", "numberFour", "numberFive"]
    
    //
    
    var ref: DatabaseReference!
    var task: [Contact] = []
    
    
    
    func dowloadsListRoomPartThree(text: String) {
        refMessagesCount = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(text)
    }
    func dowloadsListRoomPartTwo() {
        refMessages = Database.database().reference(withPath: "Geo_chat").child("ROOM")
    }
    func dowloadsListRoomPartOne() {
        refMessages.observe(.value) { [weak self] (snapshot) in
            for int in 0..<5 {
                self?.dowloadsListRoomPartThree(text: (self?.roomSend[int])!)
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
                        self?.lastRoomDate.append(":(")
                    } else {
                        let deleteMessage = self?.messageCount.removeLast()
                        self?.lastRoomEmail.append((deleteMessage?.nameUser)!)
                        self?.lastRoomMessage.append((deleteMessage?.message)!)
                        self?.lastRoomMessageCount.append("\((self?.messageCount.count)! + 1)")
                        self?.lastRoomDate.append((deleteMessage?.date)!)
                        
                    }
                    
                    lastRoomMessageSend = (self?.lastRoomMessage)!
                    lastRoomMessageEmail = (self?.lastRoomEmail)!
                    messageCountCell = (self?.lastRoomMessageCount)!
                    lastRoomMessageDate = (self?.lastRoomDate)!
                })
            }
        }
    }
    
}
