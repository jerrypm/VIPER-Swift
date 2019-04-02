import UIKit
import RxSwift

protocol GameDetailViewUpdatesHandler: class {
  
  func updateGameDetailView()
}

class GameDetailViewController: UIViewController, GameDetailViewUpdatesHandler, NoInternetAlertDelegate {
  
//MARK: Relationships
  
  var presenter: GameDetailEventHandler!
  
  var viewModel: GameDetailViewModel {
    return presenter.viewModel
  }
  
  let disposeBag = DisposeBag()
  let noInternetAlert = NoInternetAlert()
  var game = Game()
  
//MARK: - IBOutlets
  
  @IBOutlet weak var gameImageView: UIImageView!
  @IBOutlet weak var gameNameLabel: UILabel!
  @IBOutlet weak var gameRunPlayerTitleLabel: UILabel!
  @IBOutlet weak var gameRunPlayerNameLabel: UILabel!
  @IBOutlet weak var gameRunTimeTitle: UILabel!
  @IBOutlet weak var gameRunTimeValueLabel: UILabel!
  @IBOutlet weak var playVideoGameButton: UIButton!
  
//MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBindings()
    configureOutlets()
  }
  
  func configureBindings() {
    viewModel.showActivityIndicator.asObservable()
      .subscribe(onNext:{ isLoading in
        guard let show = isLoading else { return }
        
        if show {
          SPLoaderSpinner.sharedInstance.showActivityIndicator(title: NSLocalizedString("loading", comment: "Loading spinner message"))
        } else {
          SPLoaderSpinner.sharedInstance.hideActivityIndicator()
        }
        
      }).disposed(by: disposeBag)
    
    viewModel.showNoInternetAlert.asObservable()
      .subscribe(onNext:{ isInternetFail in
        guard let show = isInternetFail else { return }
        
        if show {
          self.noInternetAlertFeedback()
        }
        
      }).disposed(by: disposeBag)
    
    viewModel.game.asObservable()
      .subscribe(onNext:{ gameObject in
        
        self.game = gameObject
        
        if let videoString = gameObject.gameRun?.video {
          if videoString.isEmpty {
            self.disabledVideoButton()
          } else {
            self.enabledVideoButton()
          }
        }
        
      }).disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.handleLoadGameRun()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    presenter.handleViewWillDisappear()
  }
  
//MARK: - UI Configuration

  private func configureOutlets() {
    title = NSLocalizedString("gamerun_title", comment: "View title")
    
    noInternetAlert.delegate = self
    
    gameRunPlayerTitleLabel.text = NSLocalizedString("player_name", comment: "Game Player title label")
    gameRunTimeTitle.text = NSLocalizedString("time_run", comment: "Game Run time title label")
    playVideoGameButton.setTitle(NSLocalizedString("loading", comment: "Video Button default state before load"), for: .normal)
    playVideoGameButton.setTitleColor(ThemeColor.black.SPColor, for: .normal)
    playVideoGameButton.setTitleColor(ThemeColor.black.SPColor.withAlphaComponent(0.6), for: .highlighted)
    playVideoGameButton.layer.cornerRadius = 7
    playVideoGameButton.backgroundColor = ThemeColor.gray.SPColor
    gameImageView.image = nil
    gameNameLabel.text = ""
    gameRunTimeValueLabel.text = ""
    gameRunPlayerNameLabel.text = ""
  }
  
//MARK: - GameDetailViewUpdatesHandler
  
  func updateGameDetailView() {
    gameImageView.image = game.image.stringURLtoUIImage()
    gameNameLabel.text = game.name
    
    if game.gameRun?.playerName == "" {
      gameRunPlayerNameLabel.text = NSLocalizedString("noplayername", comment: "Player name not available message")
    } else {
      gameRunPlayerNameLabel.text = game.gameRun?.playerName
    }
    
    if let seconds = game.gameRun?.timeRun.stringToDouble() {
      gameRunTimeValueLabel.text = seconds.stringFromInterval()
    } else {
      gameRunTimeValueLabel.text = NSLocalizedString("notimerun", comment: "Time not available message")
    }
  }
  
//MARK: - GameDetailViewUpdatesMethods
  
  func noInternetAlertFeedback() {
    noInternetAlert.show(animated: true)
  }
  
  func noInternetAlertReloadConnection() {
    viewModel.showNoInternetAlert.value = false
    presenter.handleLoadGameRun()
  }
  
//MARK: - GameDetailPrivateMethods
  
  private func disabledVideoButton() {
    playVideoGameButton.setTitle(NSLocalizedString("video_off", comment: "Video Button disabled text").uppercased(), for: .normal)
    self.playVideoGameButton.isEnabled = false
  }
  
  private func enabledVideoButton() {
    playVideoGameButton.setTitle(NSLocalizedString("video_on", comment: "Video Button enabled text").uppercased(), for: .normal)
    self.playVideoGameButton.isEnabled = true
  }
  
//MARK: - Actions
  
  @IBAction func playVideoGameAction(_ sender: UIButton) {
    if let videoString = game.gameRun?.video {
      if let url = URL(string: videoString) {
        UIApplication.shared.open(url, options: [:])
      }
    }
  }
}
