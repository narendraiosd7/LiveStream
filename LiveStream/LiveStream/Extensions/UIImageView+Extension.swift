import UIKit

extension UIImageView {
  
  func loadImage(from urlString: String) {
    guard let url = URL(string: urlString) else {
      return
    }
  
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url),
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.image = image
        }
      }
    }
  }
}
