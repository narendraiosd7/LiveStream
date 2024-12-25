import UIKit

class CommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var userDetailsContainer: UIView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var rewardIcon: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with comment: Comment, isTopComment: Bool) {
    userNameLabel.text = comment.username
    commentLabel.text = comment.comment
    profilePic.loadImage(from: comment.picURL)
    profilePic.layer.cornerRadius = profilePic.frame.height / 2
    userDetailsContainer.layer.cornerRadius = 25
    if isTopComment {
      userNameLabel.textColor = .white
      userDetailsContainer.backgroundColor = UIColor(named: "backgroundColor")
      rewardIcon.image = UIImage(named: "roseIcon")
      countLabel.text = "X 22"
    } else {
      userNameLabel.textColor = UIColor(named: "textColor")
      userDetailsContainer.backgroundColor = .clear
      rewardIcon.isHidden = true
      countLabel.isHidden = true
    }
  }
}
