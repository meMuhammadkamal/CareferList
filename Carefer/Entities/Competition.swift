import Foundation
struct Competition: Codable {
	let id: Int?
	let area: Area?
	let name: String?
	let code: String?
	let plan: String?
	let lastUpdated: String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case area = "area"
		case name = "name"
		case code = "code"
		case plan = "plan"
		case lastUpdated = "lastUpdated"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		area = try values.decodeIfPresent(Area.self, forKey: .area)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		code = try values.decodeIfPresent(String.self, forKey: .code)
		plan = try values.decodeIfPresent(String.self, forKey: .plan)
		lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
	}

}
