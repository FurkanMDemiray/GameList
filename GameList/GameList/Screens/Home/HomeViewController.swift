//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

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
        setConfigures()
        homeViewModel.load()
    }

//MARK: - Configure
    private func configureCollectionView() {
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
        view.addSubview(notFoundLabel)
        notFoundLabel.text = message
        NSLayoutConstraint.activate([
            notFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func hidePageControl() {
        pageControl.isHidden = true
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

    /*private func getAı() async {

        let model = GenerativeModel(name: "gemini-pro", apiKey: Constants.geminiAPIKey)

        let prompt = "Write a short description about a \(gameName!) game."
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                print(text)
            }
        } catch {
            print(error)
        }
    }*/
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
        notFoundLabel.isHidden = true
    }
    
    func showPageControl() {
        pageControl.isHidden = false
    }

    func showSlider() {
        if tableViewTopConstraint != nil {
            tableViewTopConstraint.isActive = false
        }
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8)
        tableViewTopConstraint.isActive = true

        sliderCollectionView.isHidden = false
        pageControl.isHidden = false
    }

    func hideSlider() {
        if tableViewTopConstraint != nil {
            tableViewTopConstraint.isActive = false
        }
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16)
        tableViewTopConstraint.isActive = true

        sliderCollectionView.isHidden = true
        pageControl.isHidden = true
    }

    func reloadGamesCollectionView() {
        tableView.reloadData()
    }

    func reloadSliderCollectionView() {
        sliderCollectionView.reloadData()
    }
}

//MARK: - SearchBar Delegate
extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homeViewModel.searchGames(with: searchText)
        if searchText.isEmpty {
            showSlider()
        } else {
            if homeViewModel.numberOfGames == 0 {
                notFoundLabel.text = "No game found!"
                notFoundLabel.isHidden = false
            } else {
                notFoundLabel.isHidden = true
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

