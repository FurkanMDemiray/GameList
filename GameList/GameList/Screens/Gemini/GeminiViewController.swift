//
//  GeminiViewController.swift
//  GameList
//
//  Created by Melik Demiray on 23.05.2024.
//

import UIKit

class GeminiViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let genres = ["Action", "RPG", "Chill", "TPS", "Multiplayer", "Platform", "Story", "Co-Op", "Puzzle", "Shooter", "Looter", "2D"]

    var viewModel: GeminiViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    private var selectedIndexPaths: [IndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient()
        viewModel.getResponse()
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GenresCell", bundle: nil), forCellWithReuseIdentifier: "GenresCell")
    }
}

extension GeminiViewController: GeminiViewModelDelegate {
    func printResponse() {

    }
}

extension GeminiViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath) as! GenresCell
        cell.setGenre(genres[indexPath.row])

        // Update cell appearance based on selection
        if selectedIndexPaths.contains(indexPath) {
            cell.cellView.backgroundColor = UIColor(hex: "#1ECBE1")
        } else {
            cell.cellView.backgroundColor = .systemRed // or the default background color
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if the cell is already selected
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            // If selected, deselect it
            selectedIndexPaths.remove(at: index)
        } else {
            // If not selected, add it to the selected indices
            selectedIndexPaths.append(indexPath)
        }
        // Reload the collection view to reflect changes
        collectionView.reloadData()
    }
}

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


