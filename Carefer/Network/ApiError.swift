//
//  ApiError.swift
//  Carefer
//
//  Created by Muhammad Kamal on 06/12/2022.
//

import Foundation
struct ApiError: Error {
    var message = GENERIC_ERROR_MESSAGE
    var code: Int = GENERIC_ERROR_CODE
}
