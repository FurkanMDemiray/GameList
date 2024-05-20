//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var gamesCollectionView: UICollectionView!

    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
        setGradientBackground()
        configurePageControl()
        homeViewModel.load()
    }

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

}

// MARK: - ViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {

    func reloadGamesCollectionView() {
        gamesCollectionView.reloadData()
    }

    func reloadSliderCollectionView() {
        sliderCollectionView.reloadData()
    }
}

