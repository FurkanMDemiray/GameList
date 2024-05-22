//
//  GameCell.swift
//  GameList
//
//  Created by Melik Demiray on 18.05.2024.
//

import UIKit
import SDWebImage

class GameCell: UICollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabels()
        configureGameImage()
    }

    private func configureLabels() {
        nameLabel.font = UIFont(name: "PermanentMarker-Regular", size: 18)
        releaseLabel.font = UIFont(name: "OldGameFatty", size: 16)
        ratingLabel.font = UIFont(name: "OldGameFatty", size: 16)
    }

    private func configureGameImage() {
        gameImage.layer.cornerRadius = 20
        gameImage.contentMode = .scaleAspectFill
        gameImage.clipsToBounds = true
    }

    func configureCell(with game: Results? = nil, model: FavoritesModel? = nil) {
        if let game = game {
            nameLabel.text = game.name
            releaseLabel.text = game.released
            ratingLabel.text = "\(game.rating ?? 0) ★"
            gameImage.sd_setImage(with: URL(string: game.backgroundImage ?? ""))
        }
        if let model = model {
            nameLabel.text = model.name
            releaseLabel.text = model.releaseDate
            ratingLabel.text = "\(model.score ?? 0) ★"
            gameImage.sd_setImage(with: URL(string: model.image ?? ""))
        }
    }

}
