//
//  String+Date.swift
//  Carefer
//
//  Created by Muhammad Kamal on 11/12/2022.
//

import Foundation
extension String {
    func convertToDate(format: DateFomat) -> Date {
      let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        guard let date = dateFormatter.date(from: self) else { return Date() }
      return date
  }
    func formatDate(fromFormat: DateFomat, toFromat: DateFomat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = toFromat.rawValue
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
  }

}
