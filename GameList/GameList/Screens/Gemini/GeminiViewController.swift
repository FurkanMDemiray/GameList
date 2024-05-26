//
//  GeminiViewController.swift
//  GameList
//
//  Created by Melik Demiray on 23.05.2024.
//

import UIKit
import SDWebImage

class GeminiViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var viewModel: GeminiViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    private var selectedIndexPaths: [IndexPath] = []

//MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGradient()
        configureCollectionView()
        configureImageView()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }

//MARK: - Configure
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GenresCell", bundle: nil), forCellWithReuseIdentifier: "GenresCell")
    }

    private func configureImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toDetailView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }

    private func updateCollectionViewHeight() {
        let collectionViewWidth = collectionView.frame.size.width
        let collectionViewHeight = viewModel.getCollectionViewHeight(width: collectionViewWidth, itemCount: viewModel.getGenres().count)
        collectionViewHeightConstraint.constant = collectionViewHeight - 14
    }

//MARK: - Get Image
    private func getImage() {
        DispatchQueue.main.async {
            let url = self.viewModel.getImageUrl()
            self.imageView.sd_setImage(with: URL(string: url))
        }
    }

//MARK: - Actions
    @IBAction func getSuggestionBtnClicked(_ sender: Any) {
        guard let _ = viewModel.getFeatures().first else {
            showAlert(title: "Warning", message: "Please select at least one feature to get a suggestion.")
            return
        }
        imageView.image = nil
        viewModel.getResponse(features: viewModel.getFeatures())
        viewModel.clearFeatures()
        selectedIndexPaths.removeAll()
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aiToDetail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.detailViewModel = DetailViewModel(gameID: GameNameID.gameNameIdDict[viewModel.getGameName()]!)
        }
    }

    @objc private func toDetailView() {
        if imageView.image == nil {
            showAlert(title: "Warning", message: "Please get a suggestion first.")
            return
        }
        performSegue(withIdentifier: "aiToDetail", sender: nil)
    }

}

// MARK: - ViewModel Delegate
extension GeminiViewController: GeminiViewModelDelegate {
    func showIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func didReceiveResponse() {
        getImage()
    }
}

// MARK: - CollectionView
extension GeminiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGenres().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath) as! GenresCell
        cell.setGenre(viewModel.getGenres()[indexPath.row])

        if selectedIndexPaths.contains(indexPath) {
            cell.cellView.backgroundColor = UIColor(hex: "10439F")
        }
        else {
            cell.cellView.backgroundColor = UIColor(hex: "454545")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            viewModel.removeFeature(viewModel.getGenres()[indexPath.row])
        }
        else {
            selectedIndexPaths.append(indexPath)
            viewModel.addFeature(viewModel.getGenres()[indexPath.row])
        }
        collectionView.reloadData()
    }
}

// MARK: - CollectionViewFlowLayout
extension GeminiViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = viewModel.getCellWidhtHeight(collectionView.frame.size.width)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


