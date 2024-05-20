//
//  SliderCell.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import UIKit

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var sliderImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureSliderImage()
    }

    private func configureSliderImage() {
        sliderImage.contentMode = .scaleAspectFill
        sliderImage.layer.cornerRadius = 20
        sliderImage.clipsToBounds = true

        let screenWidth = UIScreen.main.bounds.width
        sliderImage.widthAnchor.constraint(equalToConstant: screenWidth - 16).isActive = true
    }

    func configure(with image: UIImage) {
        sliderImage.image = image
    }
}
