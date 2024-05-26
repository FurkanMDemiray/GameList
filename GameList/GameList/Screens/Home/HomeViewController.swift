import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!

    private var tableViewTopConstraint: NSLayoutConstraint!

    let notFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "No game found!"
        label.textColor = .white
        label.font = UIFont(name: "PermanentMarker-Regular", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }
    var gameId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfigures()
        self.homeViewModel.load()
    }

//MARK: - Configure
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        sliderCollectionView.setCollectionViewLayout(layout, animated: false)
        sliderCollectionView.isPagingEnabled = true
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 116
        tableView.backgroundView?.addGradient()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    private func configurePageControl() {
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
    }

    private func configureCollectionViewsConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        sliderCollectionView.translatesAutoresizingMaskIntoConstraints = false

        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8)
        tableViewTopConstraint.isActive = true
    }

    private func configureNoDataLabel(_ message: String = "Loading...") {
        DispatchQueue.main.async {
            self.view.addSubview(self.notFoundLabel)
            self.notFoundLabel.text = message
            NSLayoutConstraint.activate([
                self.notFoundLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.notFoundLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
                ])
        }
    }

    private func hidePageControl() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = true
        }
    }

    private func setConfigures() {
        hidePageControl()
        configureCollectionView()
        view.addGradient()
        configurePageControl()
        configureCollectionViewsConstraints()
        configureNoDataLabel()
        configureTableView()
    }

//MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailVC = segue.destination as! DetailViewController
            if let gameId = gameId {
                detailVC.detailViewModel = DetailViewModel(gameID: gameId)
            }
        }
    }

//MARK: - Slider ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == sliderCollectionView {
            let page = scrollView.contentOffset.x / scrollView.frame.width
            pageControl.currentPage = Int(page)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = sliderCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

//MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        if homeViewModel.getFirstThreeImages().count > 0 {
            cell.configure(with: homeViewModel.getFirstThreeImages()[indexPath.row])
        }
        return cell
    }
}

//MARK: - CollectionView FlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.numberOfGames
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.configureCell(with: homeViewModel.getResults()[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameId = homeViewModel.getGameId(at: indexPath.row)
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
}

// MARK: - ViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func showNoData() {
        configureNoDataLabel("No data found.")
    }

    func showLoading() {
        configureNoDataLabel("Loading...")
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.notFoundLabel.isHidden = true
        }
    }

    func showPageControl() {
        DispatchQueue.main.async {
            self.pageControl.isHidden = false
        }
    }

    func showSlider() {
        DispatchQueue.main.async {
            if self.tableViewTopConstraint != nil {
                self.tableViewTopConstraint.isActive = false
            }
            self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.pageControl.bottomAnchor, constant: 8)
            self.tableViewTopConstraint.isActive = true

            self.sliderCollectionView.isHidden = false
            self.pageControl.isHidden = false
            self.notFoundLabel.isHidden = true
        }
    }

    func hideSlider() {
        DispatchQueue.main.async {
            if self.tableViewTopConstraint != nil {
                self.tableViewTopConstraint.isActive = false
            }
            self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 16)
            self.tableViewTopConstraint.isActive = true

            self.sliderCollectionView.isHidden = true
            self.pageControl.isHidden = true
        }
    }

    func reloadGamesCollectionView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func reloadSliderCollectionView() {
        DispatchQueue.main.async {
            self.sliderCollectionView.reloadData()
        }
    }
}

//MARK: - SearchBar Delegate
extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.searchGames(with: searchText)
        if searchText.isEmpty {
            showSlider()
        } else {
            DispatchQueue.main.async {
                if self.homeViewModel.numberOfGames == 0 {
                    self.notFoundLabel.text = "No game found!"
                    self.notFoundLabel.isHidden = false
                } else {
                    self.notFoundLabel.isHidden = true
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
