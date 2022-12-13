//
//  MatchesViewModel.swift
//  Carefer
//
//  Created by Muhammad Kamal on 07/12/2022.
//

import Foundation
import Moya
import Combine
@MainActor class MatchesViewModel: ObservableObject {
    @Published var groupedMatches: [Date: [Matches]]?
    @Published var apiError: ApiError?

    let session: Session
    init(session: Session = Session.default) {
        self.session = session
    }

    func retreiveMatches() async throws {
        do {
            let matches = try await
            ApiManager.sharedInstance.fetchData(session: session, responseClass: MatchesList.self, service: .showMatches(year: YEAR))
                .matches
            if let matches = matches {
               let sortedMatches =  matches.sorted { match1, match2 in
                    match1.utcDate?.convertToDate(format: .YEAR) ?? Date() < match2.utcDate?.convertToDate(format: .YEAR) ?? Date()
                }
                self.groupedMatches = groupMatchesByDay(sortedMatches)
            } else {
                self.apiError = ErrorHandler.generateError(message: GENERIC_ERROR_MESSAGE, errorCode: GENERIC_ERROR_CODE)
            }
        } catch {
            self.apiError = ErrorHandler.generateError(message: GENERIC_ERROR_MESSAGE, errorCode: GENERIC_ERROR_CODE)
        }
    }
}
