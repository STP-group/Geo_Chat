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

var nameVC = ""
var userDataContact: [Contact] = []
// название комнаты для базы данных
//
var titleNameRoom = ""

var userIdNameJSQ = ""
class ChatVCViewController: JSQMessagesViewController {
    
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
    var messageFirebaseStruct = Array<Messages>()
    // структура сообщений для сохранения/чтения Firebase
    //
    var nameUserSender = ""
    //var automaticallyScrollsToMostRecentMessage: Bool = true
    var funcS = ReallyGoodViewControllerList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_: Bool = true
        
        for name in userDataContact {
            print(name)
            if name.email == userIdNameJSQ {
                nameUserSender = name.name
                print("имя отправителя\(name.name)")
            } else {
                print("имя получателя\(name.name)")
            }
        }
        
        
        title = titleNameRoom
        fireBaseDataChat()
        
        self.senderId = userIdNameJSQ

        // Id отправителя сообщений ( обязательно для JSQMessage )
        //
        self.senderDisplayName = nameUserSender

        if senderDisplayName == nil {
            senderDisplayName = "no name"
        } else {
            senderDisplayName = nameUserSender
        }
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
        ref = Database.database().reference(withPath: "Geo_chat").child("ROOM").child(nameVC).child("messages")
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
            let countMessage = snapshot.childrenCount
            if countMessage <= 0 {
                print("error")
            } else {
                for item in snapshot.children {
                    let task = Messages(snapshot: item as! DataSnapshot)
                    _list.append(task)
                }
                self?.messageFirebaseStruct = _list
                
                // Схожая процедура ( смотреть выше ) только помещаем все в массив ( JSQMessage )
                var _ListItem = Array<JSQMessage>()
                for i in 0..<Int(snapshot.childrenCount) {
                    let task = self?.messageFirebaseStruct[i].email
                    let userName = self?.messageFirebaseStruct[i].nameUser
                    let taskMessage = self?.messageFirebaseStruct[i].message
                    let time = self?.messageFirebaseStruct[i].date
                    //let dateTime = DateAndTimes().getDateFrom(string: time)
                    let dateTime = self?.getDateFrom(string: time!)
                    
                    _ListItem.append(JSQMessage(senderId: task, senderDisplayName: userName, date: dateTime, text: taskMessage))
                }
                self?.messages = _ListItem
                
                //
                // обновляем collectionView
                self?.finishReceivingMessage()
                self?.scrollToBottom(animated: true)
                self?.collectionView.reloadData()
            }
        }
    }
    
    // Ярослав
    // Функция нужна, чтобы переводить свойство date в Message из String в Date, которая используется в JSQMessage
    func getDateFrom (string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZZZZZ"
        formatter.timeZone = .current
        guard let itIsADate = formatter.date(from: string) else { return Date() }
        return itIsADate
    }
    // Ярослав
    //
    let dateFormatterWeekDay: DateFormatter = {
        let weekDay = DateFormatter()
        weekDay.shortWeekdaySymbols = ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
        return weekDay
    }()
    
    // Ярослав
    //
    // Возвращает нужный формат времени для лэйбла посередине окна чата
    func getTextInMidLabel (date: Date) -> String {
        let calendar = Calendar.current
        guard !calendar.isDateInToday(date) else {
            dateFormatterWeekDay.dateFormat = "HH:mm"
            return dateFormatterWeekDay.string(from: date) }
        guard !calendar.isDateInYesterday(date) else {
            dateFormatterWeekDay.dateFormat = "Вчера, HH:mm"
            return dateFormatterWeekDay.string(from: date) }
        
        let components = calendar.dateComponents([.day, .weekOfYear], from: Date(), to: date)
        
        switch (components.day!,components.weekOfYear!) {
        case (...(-1),0):
            dateFormatterWeekDay.dateFormat = "E, HH:mm"
        default:
            dateFormatterWeekDay.dateFormat = "dd.MM, HH:mm"
        }
        return dateFormatterWeekDay.string(from: date)
    }
    // Заголовок по середине экрана
    // Ярослав
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        if indexPath.row == 0 {
            return NSAttributedString(string: getTextInMidLabel(date: message.date))
        }
        
        if message.date.timeIntervalSince(messages[indexPath.row - 1].date) > 300 {
            return NSAttributedString(string: getTextInMidLabel(date: message.date))
        }
        return nil
        
    }
    // размер шрифта для топ лабел
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13
    }
    
    // Текст над полем сообщения
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        
        return NSAttributedString(string: messages[indexPath.row].senderDisplayName)
    }
    
    //Размер текста над полем сообщения
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 10.0
    }
    
    
    
    
    //
    // Цвет входящих и исходящих сообщений
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if messages[indexPath.row].senderId == userIdNameJSQ {
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
        let text = Messages(message: text, email: senderId , date: dateMessage(), nameUser: senderDisplayName)
        
        // сохраняем в Firebase
        let refMessage = self.ref.child(String(messageFirebaseStruct.count))
        refMessage.setValue(["message": text.message, "email": text.email, "date": date.description, "nameUser": text.nameUser])
        
        // Добавляем в массив
        messages.append(JSQMessage(senderId: text.email, senderDisplayName: text.nameUser, date: date, text: text.message))
        
        // Обновление экрана
        collectionView.reloadData()
        
        
        // Остоновка отправки сообщений
        // После отправки возвращает текстовое поле в исходное состояние
        finishSendingMessage()
        //funcRoomVC.reload()
        
    }
    @IBAction func cancelPenGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func cancelToRoomVC(_ sender: UIBarButtonItem) {
        dismiss(animated: false) {
            //self.funcS.start()
            //_ = self.funcRoomVC.tableView.reloadData()
            
        }
    }
    
    
}
