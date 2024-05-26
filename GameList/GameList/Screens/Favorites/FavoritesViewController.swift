//
//  FavoritesViewController.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var favoritesViewModel: FavoritesViewModelProtocol! {
        didSet {
            favoritesViewModel.delegate = self
        }
    }
    private var gameId: Int?

    var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites found!"
        label.font = UIFont(name: "OldGameFatty", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColectionView()
        view.addGradient()
    }

    override func viewWillAppear(_ animated: Bool) {
        favoritesViewModel.getData()
    }

//MARK: - Configure
    private func configureColectionView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 116
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "GameCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    private func configureNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

//MARK: - TableView Delegate
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.getNumberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        let item = favoritesViewModel.getItem(at: indexPath.row)
        cell.configureCell(model: item)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this game from favorites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.favoritesViewModel.deleteItem(at: indexPath.row)
                self.favoritesViewModel.getData()
                tableView.reloadData()
                completion(true)
            }))
            self.present(alert, animated: true)
        }

        delete.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameId = favoritesViewModel.getGameID(name: favoritesViewModel.getItem(at: indexPath.row).name ?? "")
        performSegue(withIdentifier: "favoriteToDetail", sender: nil)
    }
}

// MARK: - FavoritesViewModelDelegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    func showNoData() {
        favoritesViewModel.getNumberOfItems() == 0 ? configureNoDataLabel() : noDataLabel.removeFromSuperview()
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - Navigation
extension FavoritesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.detailViewModel = DetailViewModel(gameID: gameId ?? 0)
        }
    }
}
