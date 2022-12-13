//
//  DateUtils.swift
//  Carefer
//
//  Created by Muhammad Kamal on 11/12/2022.
//

import Foundation

func convertDateToString(date: Date, format: DateFomat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: date)
}
