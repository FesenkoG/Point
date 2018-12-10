//
//  DateHelper.swift
//  Point
//
//  Created by Георгий Фесенко on 09/12/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation


final class DateHelper {
    
    static func convertTimestampToAge(_ timestamp: Int) -> String {
        let now = Date()
        let birthday: Date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        guard let age = ageComponents.year else { return "" }
        
        return "\(age)"
    }
    
    static func convertTimestampToHoursAndMinutes(_ timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }
}

extension DateHelper {
    static func convertTimestampToHoursAndMinutes(_ timestamp: String) -> String {
        guard let timestamp = Int(timestamp) else { return "" }
        return convertTimestampToHoursAndMinutes(timestamp)
    }
}
