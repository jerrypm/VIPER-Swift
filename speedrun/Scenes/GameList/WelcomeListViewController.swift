import UIKit
import RxSwift

protocol WelcomeListViewUpdatesHandler: class {
  
  func updateWelcomeListView()
}

class WelcomeListViewController: UIViewController, WelcomeListViewUpdatesHandler, NoInternetAlertDelegate {

//MARK: Relationships
  
  var presenter: WelcomeListEventHandler!
  
  var viewModel: WelcomeListViewModel {
    return presenter.viewModel
  }
  
  let disposeBag = DisposeBag()
  var tableGameArray: Array<Game> = []
  let imageCache = NSCache<NSString, UIImage>()
  let noInternetAlert = NoInternetAlert()
  private lazy var refreshControl = UIRefreshControl()
  
//MARK: - IBOutlets
  
  @IBOutlet weak var gamesListTableView: UITableView!
  
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
    
    viewModel.gameArray.asObservable()
      .subscribe(onNext:{ updatedArray in
       
        self.tableGameArray = updatedArray
        
      }).disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.handleLoadGameList()
  }
  
//MARK: - UI Configuration
  
  private func configureOutlets() {
    
    noInternetAlert.delegate = self
    
    title = NSLocalizedString("gameList_title", comment: "GameList View Title")
    
    gamesListTableView.delegate = self
    gamesListTableView.dataSource = self
    gamesListTableView.allowsSelection = true
    gamesListTableView.tableFooterView = UIView()
    gamesListTableView.separatorColor = ThemeColor.gray.SPColor
    gamesListTableView.separatorInset.left = 0
    gamesListTableView.backgroundColor = ThemeColor.white.SPColor
    gamesListTableView.register(UINib(nibName: "GameListViewCell", bundle: nil), forCellReuseIdentifier: "GameListCell")
    
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    gamesListTableView.refreshControl = refreshControl
  }
  
//MARK: - WelcomeListViewUpdatesHandler
  
  func updateWelcomeListView() {
    self.gamesListTableView.reloadData()
  }
  
//MARK: - WelcomeListViewUpdatesMethods
  
  @objc func handleRefresh() {
    
    let kTimeToRefreshTableDataInSeconds = 1.0
    
    DispatchQueue.main.asyncAfter(deadline: .now() + kTimeToRefreshTableDataInSeconds) {
      self.refreshControl.endRefreshing()
      self.presenter.handleLoadGameList()
    }
  }
  
  func noInternetAlertFeedback() {
    noInternetAlert.show(animated: true)
  }
  
  func noInternetAlertReloadConnection() {
    viewModel.showNoInternetAlert.value = false
    presenter.handleLoadGameList()
  }
  
}

//MARK: - UITableViewDelegate and UITableViewDataSource

extension WelcomeListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    guard let gameListCell = tableView.dequeueReusableCell(withIdentifier: "GameListCell") as? GameListViewCell else { return cell }
    
    gameListCell.nameLabel.text = self.tableGameArray[indexPath.row].name
    gameListCell.logoImageView.image = nil
    
    if let cachedImage = imageCache.object(forKey: NSString(string: self.tableGameArray[indexPath.row].image)) {
      gameListCell.logoImageView.image = cachedImage
      
    } else {
      
      DispatchQueue.global().async {
        let image = self.tableGameArray[indexPath.row].image.stringURLtoUIImage()
        
        DispatchQueue.main.async {
          gameListCell.logoImageView.image = nil
          self.imageCache.setObject(image, forKey: NSString(string: self.tableGameArray[indexPath.row].image))
          gameListCell.logoImageView.image = image
        }
      }
    }

    return gameListCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleItemSelected(at: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableGameArray.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 107.0
  }
}
