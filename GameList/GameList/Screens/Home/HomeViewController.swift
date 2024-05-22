//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var gamesCollectionView: UICollectionView!

    private var gamesCollectionViewTopConstraint: NSLayoutConstraint!

    let notFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "No games found."
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
        setGradientBackground()
        configurePageControl()
        configureCollectionViewsConstraints()
        configureNotFoundLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.load()
    }

//MARK: - Configure
    private func configureCollectionView() {
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        sliderCollectionView.showsHorizontalScrollIndicator = false

        gamesCollectionView.dataSource = self
        gamesCollectionView.delegate = self
        gamesCollectionView.showsVerticalScrollIndicator = false

        gamesCollectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        sliderCollectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
    }

    private func configurePageControl() {
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
    }

    private func configureCollectionViewsConstraints() {
        gamesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        sliderCollectionView.translatesAutoresizingMaskIntoConstraints = false

        gamesCollectionViewTopConstraint = gamesCollectionView.topAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: 8)
        gamesCollectionViewTopConstraint.isActive = true
    }

    private func configureNotFoundLabel() {
        view.addSubview(notFoundLabel)
        notFoundLabel.isHidden = true
        NSLayoutConstraint.activate([
            notFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
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

//MARK: - ScrollView Delegate
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
        if collectionView == sliderCollectionView {
            return 3
        } else {
            return homeViewModel.numberOfGames
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
            cell.configureCell(with: homeViewModel.getResults()[indexPath.row])
            return cell
        }
        else if collectionView == sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            if homeViewModel.getFirstThreeImages().count > 0 {
                cell.configure(with: homeViewModel.getFirstThreeImages()[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == gamesCollectionView {
            gameId = homeViewModel.getGameId(at: indexPath.row)
            performSegue(withIdentifier: "toDetailVC", sender: nil)
        }
    }

}

// MARK: - ViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {

    func showSlider() {
        if gamesCollectionViewTopConstraint != nil {
            gamesCollectionViewTopConstraint.isActive = false
        }
        gamesCollectionViewTopConstraint = gamesCollectionView.topAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: 8)
        gamesCollectionViewTopConstraint.isActive = true

        sliderCollectionView.isHidden = false
        pageControl.isHidden = false
    }

    func hideSlider() {
        if gamesCollectionViewTopConstraint != nil {
            gamesCollectionViewTopConstraint.isActive = false
        }
        gamesCollectionViewTopConstraint = gamesCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8)
        gamesCollectionViewTopConstraint.isActive = true

        sliderCollectionView.isHidden = true
        pageControl.isHidden = true
    }

    func reloadGamesCollectionView() {
        gamesCollectionView.reloadData()
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

