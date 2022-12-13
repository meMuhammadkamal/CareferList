//
//  Const.swift
//  Carefer
//
//  Created by Muhammad Kamal on 09/12/2022.
//

import Foundation

// ---------------Font Names---------------------
enum Fonts: String {
   case  BOLD_FONT = "Rubik-Bold"
    case SEMIBOLD_FONT = "Rubik-SemiBold"
    case REGULAR_FONT = "Rubik-Regular"
    case MEDIUM_FONT = "Rubik-Medium"
}
// ---------------UI ---------------------
class UI {
    static let CORNER_RADIUS  =  CGFloat(3)
}
// ---------------DateFormats ---------------------
enum DateFomat: String {
    case YEAR =  "yyyy-MM-dd"
    case FULL_DATE =  "yyyy-MM-dd'T'HH:mm:ssZ"
    case TIME =  "hh:mm a"
}

// ---------------StorageKeys ---------------------
let FAVORITE_FIXTURE = "favFixture"
