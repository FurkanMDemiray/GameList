//
//  GenresCell.swift
//  GameList
//
//  Created by Melik Demiray on 24.05.2024.
//

import UIKit

class GenresCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        configureLabel()
        self.backgroundColor = .clear

    }

    private func configureCell() {
        cellView.layer.cornerRadius = 20
        cellView.layer.masksToBounds = true
    }

    private func configureLabel() {
        let screenWidth = UIScreen.main.bounds.width
        genreLabel.textColor = .white
        screenWidth > 375 ? (genreLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)) : (genreLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold))
    }

    func setGenre(_ genre: String) {
        genreLabel.text = genre
    }
}
