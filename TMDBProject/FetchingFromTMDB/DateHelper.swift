//
//  DateHelper.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/06.
//

import Foundation

class DateHelper {
    
    static func changeDateFormat(dateString: String, fromFormat: String, toFormat: String) -> String {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = fromFormat
        let date = inputDateFormatter.date(from: dateString)
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = toFormat
        return outputDateFormatter.string(from: date!)
        
    }
    
}
