//
//  DateAndTime.swift
//  Geo_Chat
//
//  Created by Артем Валерьевич on 24.03.2018.
//  Copyright © 2018 Артем Валерьевич. All rights reserved.
//

import Foundation
public class DateAndTimes {
    
   public func getDateFrom2(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZZZZZ"
        formatter.timeZone = .current
        guard let itIsADate = formatter.date(from: string) else { return Date() }
        return itIsADate
    }
    
    let dateFormatterWeekDay: DateFormatter = {
        let weekDay = DateFormatter()
        weekDay.shortWeekdaySymbols = ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
        return weekDay
    }()


public func getTextInMidLabel2(date: Date) -> String {
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
}
