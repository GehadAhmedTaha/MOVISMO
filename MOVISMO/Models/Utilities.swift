//
//  Utilities.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/30/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import Foundation
class Utilities{
    static func getFormattedDate (_ releaseDate : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: releaseDate)
    }
    
    static func getFormattedDateForUI(_ date: Date?) -> String {
        if let release_date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: release_date)
        }
        return ""
    }
}
