//
//  GroupElements.swift
//  Carefer
//
//  Created by Muhammad Kamal on 11/12/2022.
//

import Foundation

func groupMatchesByDay(_ matches: [Matches]) -> [Date: [Matches]] {
  let empty: [Date: [Matches]] = [:]
  return matches.reduce(into: empty) { acc, cur in
      let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.utcDate?.convertToDate(format: .FULL_DATE) ?? Date())
      let date = Calendar.current.date(from: components)!
      let existing = acc[date] ?? []
      acc[date] = existing + [cur]
  }
}
