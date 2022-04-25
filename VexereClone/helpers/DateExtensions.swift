//
//  DateExtensions.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 16/04/2022.
//

import Firebase

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func getWeekday() -> String {
        let f = DateFormatter()
        let weekday = f.weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
        switch weekday {
        case "Monday":
            return "Thứ 2"
        case "Tuesday":
            return "Thứ 3"
        case "Wednesday":
            return "Thứ 4"
        case "Thursday":
            return "Thứ 5"
        case "Friday":
            return "Thứ 6"
        case "Saturday":
            return "Thứ 7"
        case "Sunday":
            return "Chủ nhật"
        default:
            return ""
        }
    }
    
    func formatDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        return f.string(from: self)
    }
    
    func formatDateAndTime() -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm dd-MM-yyyy"
        return f.string(from: self)
    }
}

extension TimeInterval {
    func getTime() -> (Int, Int, Int) {
        let ti = NSInteger(self)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return (hours: hours, minutes: minutes, seconds: seconds)
    }
}

extension Timestamp {
    func parseToDate() -> Date {
        return self.dateValue()
    }
}
