//
//  ChatVCViewController.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 16.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatVCViewController: JSQMessagesViewController {
    
    var userIdName = ""
    // Id пользователя ( сейчас используется email)
    //
    var nameVC = ""
    // название комнаты для базы данных
    //
    var titleNameRoom = ""
    
    
    var user: UsersInfo!
    // структура пользователей для списка пользователе в данном чате ( в разработке )
    //
    var ref: DatabaseReference!
    // для Firebase
    //
    var messages = [JSQMessage]()
    // массив сообщений хранит все что связано с сообщениями
    //
    var userId = Array<Contact>()
    // массив для списка пользователе в данном чате ( в разработке )
    //
    var messageTest = Array<Messages>()
    // структура сообщений для сохранения/чтения Firebase
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleNameRoom

        fireBaseDataChat()
        // Функция для адресса комнаты
        //
        print(nameVC)
        // Получаем в консоли информацию о имени комнаты
        //
        print(userIdName)
        // Получаем в консоли информацию о имени пользователя
        //
        self.senderId = userIdName
        // Id отправителя сообщений ( обязательно для JSQMessage )
        //
        self.senderDisplayName = userIdName
        // имя отправителя сообщений ( обязательно для JSQMessage )
        //
    }
    
    //
    // Функция для даты сообщений
    func date() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let miliSeconds = calendar.component(.nanosecond, from: date)
        let time = "\(hour):\(minutes):\(seconds):\(miliSeconds)"
        return time
    }
    
    func dateMessage() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let miliSeconds = calendar.component(.nanosecond, from: date)
        let timeMessages = "\(hour):\(minutes):\(seconds):\(miliSeconds)"
        return timeMessages
    }
    
    
    //
    // Адрес для firebase
    func fireBaseDataChat() {
        guard let currentUser = Auth.auth().currentUser else { return }
        // user получаем имя пользователя ( в разработке )
        user = UsersInfo(user: currentUser)
        // Адрес пути в Database
        ref = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(nameVC)
    }
    
   
    //
    // Функция для сообщений
    func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }

    //
    // Метод сробатывает перед показа экрана

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        // Считываем все содержимое по адресу ( смотреть fireBaseDataChat -> ref )
        ref.observe(.value) { [weak self] (snapshot) in
            var _list = Array<Messages>()
            // создаем массив - который имеет туже стректуру что и messageTest
            //
            //
            // Цикл считываем все из snapshot ( снимок ) и помещаем в item
            for item in snapshot.children {
                print(item)
                let task = Messages(snapshot: item as! DataSnapshot)
                // Создаем стректуру - которая будет иметь все ключи из snapshot
                //
                //
                // Добавляем все содержимое в массив ( смотреть строку 104 )
                _list.append(task)
            }
            
             // Переносим вне цикла все содержимое из _list в массив сообщений
            self?.messageTest = _list
            
            // Схожая процедура ( смотреть выше ) только помещаем все в массив ( JSQMessage )
            var _ListItem = Array<JSQMessage>()
            for i in 0..<Int(snapshot.childrenCount) {
                print(i)
                let task = self?.messageTest[i].email
                let taskMessage = self?.messageTest[i].message
                let time = self?.messageTest[i].date
                let dateTime = self?.getDateFrom(string: time!)
                
                _ListItem.append(JSQMessage(senderId: task, senderDisplayName: task, date: dateTime, text: taskMessage))
            }
            self?.messages = _ListItem
            
            //
            // обновляем collectionView
            self?.collectionView.reloadData()
            
        }
    }
    
    // Функция нужна, чтобы переводить свойство date в Message из String в Date, которая используется в JSQMessage
    func getDateFrom (string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZZZZZ"
        formatter.timeZone = .current
        guard let itIsADate = formatter.date(from: string) else { return Date() }
        return itIsADate
    }
    
    let dateF: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    // Смотрит на день отправки сообщения и сравнивает к сегодняшним днём (в разработке)
    func differenceBetweenTwoDates (date: Date) -> String {
        let calendar = Calendar.current
        let oldDay = calendar.component(.day, from: date)
        let todayDay = calendar.component(.day, from: Date())
        var result = ""
        let dif = todayDay - oldDay
        
        switch dif {
        case 0: result = ""
        case 1: result = "Вчера"
        case 2: result = "Позавчера"
        default:
            let month = calendar.component(.month, from: date)
            result = "\(oldDay).0\(month)"
        }
        return result
        
    }
    // Заголовок по середине экрана
    // Ярослав
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        if indexPath.row == 0 {
            return NSAttributedString(string: "\(differenceBetweenTwoDates(date: message.date)) \(dateF.string(from: message.date))")
        }
        
        if message.date.timeIntervalSince(messages[indexPath.row - 1].date) > 300 {
            return NSAttributedString(string: "\(differenceBetweenTwoDates(date: message.date)) \(dateF.string(from: message.date))")
        }
        return nil
        
    }
    // размер шрифта для топ лабел
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }

    // Текст над полем сообщения
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        return NSAttributedString(string: message.senderDisplayName)
        //        }
    }
    
    //Размер текста над полем сообщения
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 10.0
    }
    
    

    //
    // Цвет входящих и исходящих сообщений
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if messages[indexPath.row].senderId == userIdName {
            // Цвет исходящих сообщений
            return bubbleFactory?.outgoingMessagesBubbleImage(with: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        } else {
            // Цвет входящих сообщений
        return bubbleFactory?.incomingMessagesBubbleImage(with: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
            
    }
    }
    //
    // Аватарка пользователя возле сообщений
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "user"), diameter: 30) // Закругляем углы
    }
    
    

    //
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {

        return messages[indexPath.item]
    }


    // Количество сообщений == количеству элементов в массиве
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //
    // Ячейка сообщений ( по умолчанию )
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        cell.messageBubbleTopLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return cell
    }
    
    // Кнопка отправки сообщений
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        // Помещаем все в массив
        let text = Messages(message: text, email: userIdName, date: dateMessage(), indexMessage: senderId)

        // сохраняем в Firebase
        let refMessage = self.ref.child(String(messageTest.count))
        refMessage.setValue(["message": text.message, "email": userIdName, "date": date.description, "indexMessage": userIdName])

        // Добавляем в массив
        messages.append(JSQMessage(senderId: text.email, senderDisplayName: text.email, date: date, text: text.message))
        
        // Обновление экрана
        collectionView.reloadData()
        
        // Остоновка отправки сообщений
        // После отправки возвращает текстовое поле в исходное состояние
        finishSendingMessage()
       
    }
   

}
