//
//  Date+Extension.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/06.
//

import UIKit

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
