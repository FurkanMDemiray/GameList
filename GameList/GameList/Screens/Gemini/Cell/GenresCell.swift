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
        genreLabel.textColor = .white
        genreLabel.font = UIFont(name: "OldGameFatty", size: 14)
    }

    func setGenre(_ genre: String) {
        genreLabel.text = genre
    }
}
