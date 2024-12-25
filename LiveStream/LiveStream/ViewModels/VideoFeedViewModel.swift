import Foundation

class VideoFeedViewModel {
  private let apiService: APIServiceProtocol
  private(set) var videos: [Video] = []
  private(set) var comments: [Comment] = []

  var reloadVideos: (() -> Void)?
  var reloadComments: (() -> Void)?

  init(apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
  }

  func fetchVideos() async {
    do {
      self.videos = try await apiService.fetchVideos()
      reloadVideos?()
    } catch {
      print("Error fetching videos: \(error.localizedDescription)")
    }
  }
  
  func fetchComments() async {
    do {
      self.comments = try await apiService.fetchComments()
      reloadComments?()
    } catch {
      print("Error fetching videos: \(error.localizedDescription)")
    }
  }
}
