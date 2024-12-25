import UIKit
import AVFoundation

class VideoFeedCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var videoPlayerView: UIView!
  @IBOutlet weak var userDetailsContainer: UIView!
  @IBOutlet weak var userProfilePic: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var heartImage: UIImageView!
  @IBOutlet weak var numberOfLikesLabel: UILabel!
  @IBOutlet weak var followButton: UIButton!
  @IBOutlet weak var topicContainer: UIView!
  @IBOutlet weak var topicIcon: UIImageView!
  @IBOutlet weak var topicLabel: UILabel!
  @IBOutlet weak var popularityContainer: UIView!
  @IBOutlet weak var popularityIcon: UIImageView!
  @IBOutlet weak var poularityLabel: UILabel!
  @IBOutlet weak var viewsContainer: UIView!
  @IBOutlet weak var viewsIcon: UIImageView!
  @IBOutlet weak var viewsLabel: UILabel!
  @IBOutlet weak var downArrowIcon: UIImageView!
  @IBOutlet weak var closeIcon: UIImageView!
  @IBOutlet weak var exploreContainer: UIView!
  @IBOutlet weak var exploreLeadingIcon: UIImageView!
  @IBOutlet weak var exploreLabel: UILabel!
  @IBOutlet weak var exploreTrailingIcon: UIImageView!
  @IBOutlet weak var topRoseIcon: UIImageView!
  @IBOutlet weak var roseContainer: UIView!
  @IBOutlet weak var topRoseLabel: UILabel!
  @IBOutlet weak var hoursView: UIView!
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var bottomRoseIcon: UIImageView!
  @IBOutlet weak var bottomRoseLabel: UILabel!
  @IBOutlet weak var giftIcon: UIImageView!
  @IBOutlet weak var giftLabel: UILabel!
  @IBOutlet weak var shareIcon: UIImageView!
  @IBOutlet weak var shareLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textFieldContainer: UIView!
  @IBOutlet weak var commentTableView: UITableView!
  
  private var player: AVPlayer?
  private var playerLayer: AVPlayerLayer?
  var comments: [Comment] = []

  override func awakeFromNib() {
    super.awakeFromNib()
    setupVideoPlayerLayer()
    setupUI()
    addTapGesture()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer?.frame = contentView.bounds
  }
  
  private func setupVideoPlayerLayer() {
    playerLayer = AVPlayerLayer()
    playerLayer?.videoGravity = .resizeAspectFill
    if let playerLayer = playerLayer {
      contentView.layer.insertSublayer(playerLayer, at: 0)
    }
  }
  
  private func setupUI() {
    userProfilePic.layer.cornerRadius = 5
    userProfilePic.clipsToBounds = true
    userDetailsContainer.layer.cornerRadius = 10
    followButton.tintColor = .red
    topicContainer.layer.cornerRadius = 5
    popularityContainer.layer.cornerRadius = 5
    viewsContainer.layer.cornerRadius = 5
    exploreContainer.layer.cornerRadius = exploreContainer.frame.height / 2
    exploreContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    roseContainer.layer.cornerRadius = 5
    hoursView.layer.cornerRadius = hoursView.frame.height / 2
    textFieldContainer.layer.cornerRadius = textFieldContainer.frame.height / 2
    textField.layer.cornerRadius = textField.frame.height / 2
    textField.layer.masksToBounds = true
    textField.layer.borderColor = UIColor.gray.cgColor

    commentTableView.dataSource = self
    commentTableView.delegate = self
    commentTableView.backgroundColor = .clear
    commentTableView.separatorStyle = .none
    commentTableView.isScrollEnabled = true
    commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
  }
  
  func configure(with video: Video) {
    if let url = URL(string: video.video) {
      player = AVPlayer(url: url)
      playerLayer?.player = player
      player?.play()
      player?.actionAtItemEnd = .none
      
      // Loop the video
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(loopVideo),
        name: .AVPlayerItemDidPlayToEndTime,
        object: player?.currentItem
      )
    }
    
    userProfilePic.loadImage(from: video.profilePicURL)
    userNameLabel.text = video.username
    numberOfLikesLabel.text = "\(video.likes)"
    topicLabel.text = video.topic
    poularityLabel.text = "Popular Live"
    viewsLabel.text = "\(video.viewers)"
    exploreLabel.text = "Explore"
    topRoseLabel.text = "1/5"
    hoursLabel.text = "3h 59m"
  }
  
  @objc private func loopVideo() {
    player?.seek(to: .zero)
    player?.play()
  }
  
  private func addTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    videoPlayerView.addGestureRecognizer(tapGesture)
    videoPlayerView.isUserInteractionEnabled = true
  }

  @objc private func handleTap() {
    if player?.timeControlStatus == .playing {
      pauseVideo()
    } else {
      playVideo()
    }
  }
  
  func playVideo() {
    player?.play()
  }
  
  func pauseVideo() {
    player?.pause()
  }
  
  func toggleVideoPlayback() {
    guard let player = player else { return }
    if player.timeControlStatus == .playing {
      pauseVideo()
    } else {
      playVideo()
    }
  }
  
  func isVideoPlaying() -> Bool {
    return player?.timeControlStatus == .playing
  }

  @IBAction func emojiPressed(_ sender: UIButton) {
    
  }
}

extension VideoFeedCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
      return UITableViewCell()
    }

    let comment = comments[indexPath.row]
    let isTopComment = indexPath.row == 0
    cell.configure(with: comment, isTopComment: isTopComment)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 50
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 15
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0
  }
}
