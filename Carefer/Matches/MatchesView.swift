//
//  ContentView.swift
//  Carefer
//
//  Created by Muhammad Kamal on 06/12/2022.
//

import SwiftUI
import Combine
struct MatchesView: View {
    @ObservedObject var matchesViewModel = MatchesViewModel()
    @State  var showAlert = false
    @State private var showFavorite = false
    @State  var message = ""
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Toggle( isOn: $showFavorite) {
                    TextView(titleName: "Favorite List", colorCode: .black, fontSize: 14, fontFamilyName: Fonts.REGULAR_FONT.rawValue)
                }.frame(maxWidth: 170)
            }
            if showFavorite {
                List {
                    if let matches = LocalStorage.sharedInstance.getFavoriteFixtures() {
                        ForEach(matches) { match in
                            MatchCard(match: match, isFavoriteVisible: showFavorite)
                        }
                    }
                }
            } else {
                List {
                        if let matches = matchesViewModel.groupedMatches {
                            ForEach(matches.keys.map({$0}), id: \.self) { matchDate in
                                Section(header: TextView(titleName: convertDateToString(date: matchDate, format: .YEAR )
                                                         , colorCode: .darkBlue, fontSize: 16, fontFamilyName: Fonts.MEDIUM_FONT.rawValue)) {
                                    if let match = matches[matchDate] {
                                        ForEach(match.indices, id: \.self) { index in
                                            MatchCard(match: match[index], isFavoriteVisible: showFavorite)
                                            }
                                        }
                                    }
                                }
                            }
                        }
            }
        }.navigationBarTitle("", displayMode: .inline)
            .edgesIgnoringSafeArea(.bottom)
        .padding(.top, 20)
        .onAppear {
            Task.init {
                do {
                    try await matchesViewModel.retreiveMatches()
                } catch {
                    message = error.localizedDescription
                    showAlert = true
                }
            }
        }.modifier(AlertView(showAlert: $showAlert, title: "Error", message: message))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
