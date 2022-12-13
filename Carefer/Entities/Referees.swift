import Foundation
struct Referees: Codable {
	let id: Int?
	let name: String?
	let role: String?
	let nationality: String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case role = "role"
		case nationality = "nationality"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		role = try values.decodeIfPresent(String.self, forKey: .role)
		nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
	}

}
