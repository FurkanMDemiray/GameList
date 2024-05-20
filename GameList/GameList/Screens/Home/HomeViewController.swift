//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import UIKit
import SDWebImage
import GoogleGenerativeAI

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameImage: UIImageView!

    var homeViewModel: HomeViewModelProtocol! {
        didSet {
            homeViewModel.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
        setGradientBackground()
        configureGameImage()
        homeViewModel.load()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
    }

    private func configureGameImage() {
        gameImage.layer.cornerRadius = 20
        gameImage.clipsToBounds = true
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

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.nubmerOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.configureCell(with: homeViewModel.getResults()[indexPath.row])
        return cell
    }

}

// MARK: - ViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {

    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

