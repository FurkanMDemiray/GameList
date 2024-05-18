//
//  GameCell.swift
//  GameList
//
//  Created by Melik Demiray on 18.05.2024.
//

import UIKit
import SDWebImage

class GameCell: UICollectionViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var ratingReleaseLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureGameImage()
    }

    private func configureGameImage() {
        gameImage.layer.cornerRadius = 20
        gameImage.contentMode = .scaleAspectFill
        gameImage.clipsToBounds = true
    }

    func configureCell(with game: Results) {
        nameLabel.text = game.name
        ratingReleaseLabel.text = "\(game.rating ?? 0.0) - \(game.released ?? "")"
        gameImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        gameImage.sd_setImage(with: URL(string: game.backgroundImage ?? ""))
    }

}
