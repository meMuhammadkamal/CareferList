//
//  ApiService.swift
//  Carefer
//
//  Created by Muhammad Kamal on 06/12/2022.
//

import Foundation
import Moya
enum ApiService {
    case showMatches(year: String)
}
extension ApiService: TargetType {
    var baseURL: URL { URL(string: BASE_URL)! }
    var path: String {
        switch self {
        case .showMatches(let year):
            return "\(year)/matches"
        }
    }
    var method: Moya.Method {
        switch self {
        case .showMatches:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .showMatches:
            return .requestPlain
        }
    }
//    var sampleData: Data {
//        switch self {
//        case .showMatches(let apiKey):
//            return "{\"id\": \(apiKey)}".utf8Encoded
//        }
//    }
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                    "X-Auth-Token": "ec68940137274d92b446491cdf164230"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data { Data(self.utf8) }
}
