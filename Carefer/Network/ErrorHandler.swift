//
//  ErrorHandler.swift
//  Carefer
//
//  Created by Muhammad Kamal on 07/12/2022.
//

import Foundation

class ErrorHandler {
 class func generateError(message: String?, errorCode: Int) -> ApiError {
        var error = ApiError()
        if let message = message {
            error.message = message
            error.code = errorCode
        }
        return error
    }
}
