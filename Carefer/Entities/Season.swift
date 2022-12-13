import Foundation
struct Season: Codable {
	let id: Int?
	let startDate: String?
	let endDate: String?
	let currentMatchday: Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case startDate = "startDate"
		case endDate = "endDate"
		case currentMatchday = "currentMatchday"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
		endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
		currentMatchday = try values.decodeIfPresent(Int.self, forKey: .currentMatchday)
	}

}
