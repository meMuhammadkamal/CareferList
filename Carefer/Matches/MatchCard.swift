//
//  MatchCard.swift
//  Carefer
//
//  Created by Muhammad Kamal on 11/12/2022.
//

import SwiftUI

struct MatchCard: View {
    var match: Matches
    var isFavoriteVisible: Bool
    @State  var showAlert = false
    var body: some View {
        HStack {
            VStack {
                TextView(
                    titleName: match.homeTeam?.name ?? ""
                    , colorCode: .black
                    , fontSize: 16
                    , fontFamilyName: Fonts.REGULAR_FONT.rawValue).frame(maxWidth: 200)
                    .multilineTextAlignment(.center)
            }
            Spacer().fixedSize()
            if match.utcDate?.convertToDate(format: .FULL_DATE) ?? Date() < Date() {
                HStack {
                    TextView(titleName: "\(match.score?.fullTime?.homeTeam ?? 0)", colorCode: .white, fontSize: 14, fontFamilyName: Fonts.MEDIUM_FONT.rawValue)
                        .padding(.leading, 8).padding(.bottom, 5).padding(.top, 5)
                    TextView(titleName: "-", colorCode: .white, fontSize: 14
                             , fontFamilyName: Fonts.REGULAR_FONT.rawValue)
                    TextView(titleName: "\(match.score?.fullTime?.awayTeam ?? 0)"
                             , colorCode: .white
                             , fontSize: 14
                             , fontFamilyName: Fonts.MEDIUM_FONT.rawValue)
                    .padding(.trailing, 8).padding(.bottom, 5).padding(.top, 5)
                }.background(.red)
            }
            if match.utcDate?.convertToDate(format: .FULL_DATE) ?? Date() > Date() {
                HStack {
                    TextView(titleName: match.utcDate?.formatDate(fromFormat: .FULL_DATE, toFromat: .TIME) ?? ""
                             , colorCode: .black
                             , fontSize: 14
                             , fontFamilyName: Fonts.MEDIUM_FONT.rawValue)
                    .padding(.leading, 8).padding(.bottom, 5).padding(.top, 5)
                }
            }

            Spacer().fixedSize()
            VStack {
                TextView(titleName: match.awayTeam?.name ?? "", colorCode: .black, fontSize: 16, fontFamilyName: Fonts.REGULAR_FONT.rawValue).frame(maxWidth: 200)
                    .multilineTextAlignment(.center)
            }
            if !isFavoriteVisible {
                Button {
                    LocalStorage.sharedInstance.addToFavorite(match: match)
                    showAlert = true
                } label: {
                    Image("star")
                }
            }
        }.modifier(AlertView(showAlert: $showAlert, title: "Success", message: "Match added to favorites"))
    }
}
