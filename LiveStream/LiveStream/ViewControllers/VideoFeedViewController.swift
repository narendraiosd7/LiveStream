import UIKit

class VideoFeedViewController: UIViewController {
  
  @IBOutlet weak var videoFeedCollectionView: UICollectionView!
  
  private var viewModel = VideoFeedViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    bindingViewModel()
    Task {
      await viewModel.fetchVideos()
      await viewModel.fetchComments()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let layout = videoFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = CGSize(width: videoFeedCollectionView.bounds.width, height: videoFeedCollectionView.bounds.height)
      videoFeedCollectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  func setupCollectionView() {
    if let layout = videoFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
      layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    videoFeedCollectionView.contentInsetAdjustmentBehavior = .never
    videoFeedCollectionView.isPagingEnabled = true
    videoFeedCollectionView.delegate = self
    videoFeedCollectionView.dataSource = self
    videoFeedCollectionView.register(UINib(nibName: "VideoFeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoFeedCollectionViewCell")
  }
  
  private func bindingViewModel() {
    viewModel.reloadVideos = { [weak self] in
      DispatchQueue.main.async {
        self?.videoFeedCollectionView.reloadData()
      }
    }

    viewModel.reloadComments = { [weak self] in
      DispatchQueue.main.async {
        self?.videoFeedCollectionView.reloadData()
      }
    }
  }
  
  private func pauseAllVideos() {
    for cell in videoFeedCollectionView.visibleCells {
      if let videoCell = cell as? VideoFeedCollectionViewCell {
        videoCell.pauseVideo()
      }
    }
  }
}

extension VideoFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.videos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoFeedCollectionViewCell", for: indexPath) as? VideoFeedCollectionViewCell else {
      return UICollectionViewCell()
    }
    pauseAllVideos()
    let video = viewModel.videos[indexPath.row]
    cell.videoPlayerView.layoutIfNeeded()
    cell.configure(with: video)
    cell.comments = viewModel.comments
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return UIScreen.main.bounds.size
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let visibleIndex = Int(round(scrollView.contentOffset.y / scrollView.bounds.height))
    
    guard visibleIndex >= 0, visibleIndex < videoFeedCollectionView.numberOfItems(inSection: 0) else { return }
    
    if let currentCell = videoFeedCollectionView.cellForItem(at: IndexPath(item: visibleIndex, section: 0)) as? VideoFeedCollectionViewCell {
      currentCell.playVideo()
    }
    
    let visibleCells = videoFeedCollectionView.visibleCells.compactMap { $0 as? VideoFeedCollectionViewCell }
    for cell in visibleCells where cell != videoFeedCollectionView.cellForItem(at: IndexPath(item: visibleIndex, section: 0)) {
      cell.pauseVideo()
    }
  }
}
