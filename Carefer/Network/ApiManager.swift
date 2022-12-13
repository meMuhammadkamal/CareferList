//
//  ApiManager.swift
//  Carefer
//
//  Created by Muhammad Kamal on 06/12/2022.
//

import Foundation
import Moya
class ApiManager {
    static let sharedInstance = ApiManager()
    var provider: MoyaProvider<ApiService>?
    init() {
         provider = MoyaProvider<ApiService>()
    }
    func fetchData<T: Decodable>(session: Session, responseClass: T.Type, service: ApiService ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider?.request(service) { result in
                switch result {
                case let .success(moyaResponse):
                    do {
                        let data = moyaResponse.data
                        let response  = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(with: .success(response))
                    } catch  let error {
                        continuation.resume(with: .failure(ErrorHandler.generateError(message: error.localizedDescription, errorCode: GENERIC_ERROR_CODE)))
                    }
                case let .failure(error):
                    continuation.resume(with: .failure(ErrorHandler.generateError(message: error.errorDescription, errorCode: GENERIC_ERROR_CODE)))
                    break
                }
            }
        }
    }
}
