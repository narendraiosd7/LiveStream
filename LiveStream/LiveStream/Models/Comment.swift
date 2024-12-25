import Foundation

struct Comment: Decodable {
  let id: Int
  let username: String
  let picURL: String
  let comment: String
}
