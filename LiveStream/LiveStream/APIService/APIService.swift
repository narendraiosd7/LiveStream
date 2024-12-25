import Foundation

protocol APIServiceProtocol {
  func fetchVideos() async throws -> [Video]
  func fetchComments() async throws -> [Comment]
}

struct APIService: APIServiceProtocol {
  func fetchVideos() async throws -> [Video] {
    guard let path = Bundle.main.path(forResource: "videos", ofType: "json") else {
      throw NSError(domain: "File not found", code: 404, userInfo: nil)
    }
    
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let response = try JSONDecoder().decode([String: [Video]].self, from: data)
    guard let videos = response["videos"] else {
      throw NSError(domain: "Invalid json structure", code: 400, userInfo: nil)
    }
    
    return videos
  }
  
  func fetchComments() async throws -> [Comment] {
    guard let path = Bundle.main.path(forResource: "comments", ofType: "json") else {
      throw NSError(domain: "File not found", code: 404, userInfo: nil)
    }
    
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let response = try JSONDecoder().decode([String: [Comment]].self, from: data)
    guard let comments = response["comments"] else {
      throw NSError(domain: "Invalid json structure", code: 400, userInfo: nil)
    }
    
    return comments
  }
}
