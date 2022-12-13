//
//  LocalStorage.swift
//  Carefer
//
//  Created by Muhammad Kamal on 13/12/2022.
//

import Foundation
class LocalStorage {
    static let sharedInstance = LocalStorage()
    let defaults = UserDefaults.standard
    var favFixture: Data? { get { return defaults.data(forKey: FAVORITE_FIXTURE ) ?? nil } set { defaults.set(newValue, forKey: FAVORITE_FIXTURE)  } }

    func getFavoriteFixtures() -> [Matches]? {
        if let data = favFixture {
            do {
                let decoder = JSONDecoder()
                let matches = try decoder.decode([Matches].self, from: data)
                return matches
            } catch {
                print("Unable to Decode (\(error))")
            }
        }
        return nil
    }

    func addToFavorite(match: Matches) {
        do {
            let encoder = JSONEncoder()
            var matches  = [Matches]()
            if let favMatches = getFavoriteFixtures() {
                matches = favMatches
            }
            matches.append(match)
            let data = try encoder.encode(matches)
            favFixture = data
        } catch {
            print("Unable to Encode Array (\(error))")
        }
    }
}
