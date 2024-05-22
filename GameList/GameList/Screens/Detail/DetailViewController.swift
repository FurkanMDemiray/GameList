//
//  DetailViewController.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import UIKit

class DetailViewController: UIViewController {

//MARK: - Outlets
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var aboutGameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var xboxLabel: UIImageView!
    @IBOutlet weak var pcLabel: UILabel!
    @IBOutlet weak var psImage: UIImageView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var metascoreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!

    var detailViewModel: DetailViewModelProtocol! {
        didSet {
            detailViewModel.delegate = self
        }
    }

    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont(name: "OldGameFatty", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideViews()
        setConfigures()
        detailViewModel.load()
    }

//MARK: - Configure Views
    private func configureBackImage() {
        backImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backImage.addGestureRecognizer(tap)
    }

    private func configureBackgroundImage() {
        gameImage.contentMode = .scaleAspectFill
        gameImage.layer.cornerRadius = 20
        gameImage.clipsToBounds = true
        gameImage.layer.masksToBounds = true
    }

    private func configureLabels() {
        nameLabel.font = UIFont(name: "PermanentMarker-Regular", size: 24)
        metascoreLabel.font = UIFont(name: "OldGameFatty", size: 20)
        releaseDateLabel.font = UIFont(name: "OldGameFatty", size: 20)
    }

    private func configureNoDataLabel(_ message: String = "Loading...") {
        noDataLabel.frame = view.bounds
        view.addSubview(noDataLabel)
    }

    private func configureDescriptionLabel() {
        innerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: aboutGameLabel.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    private func configureReadMoreBtn() {
        innerView.addSubview(readMoreBtn)
        readMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        readMoreBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        readMoreBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    }

    private func setConfigures() {
        configureBackgroundImage()
        configureBackImage()
        configureLabels()
        configureDescriptionLabel()
        configureReadMoreBtn()
    }

//MARK: - Update View
    func updateView() {
        nameLabel.text = detailViewModel?.getName()
        metascoreLabel.text = "Metacritic: \(detailViewModel?.getMetaCritic() ?? 0)"
        releaseDateLabel.text = detailViewModel?.getReleaseDate()
        gameImage.image = detailViewModel?.getBackgroundImage()
        descriptionLabel.text = detailViewModel?.getDescription()
    }

//MARK: - Expand/Collapse Description Label
    private func expandDescriptionLabel() {
        UIView.animate(withDuration: 0.3) {
            NSLayoutConstraint.deactivate(self.descriptionLabel.constraints.filter { $0.firstAttribute == .height })
            self.descriptionLabel.heightAnchor.constraint(equalToConstant: self.descriptionLabel.intrinsicContentSize.height).isActive = true
            self.view.layoutIfNeeded()
        }
    }

    private func collapseDescriptionLabel() {
        UIView.animate(withDuration: 0.3) {
            NSLayoutConstraint.deactivate(self.descriptionLabel.constraints.filter { $0.firstAttribute == .height })
            self.descriptionLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.view.layoutIfNeeded()
        }
    }

//MARK: - Actions
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func readMoreBtnClicked(_ sender: Any) {
        if readMoreBtn.titleLabel?.text == "Read More" {
            readMoreBtn.setTitle("Read Less", for: .normal)
            expandDescriptionLabel()
        } else {
            readMoreBtn.setTitle("Read More", for: .normal)
            collapseDescriptionLabel()
        }
    }
}

// MARK: - DetailViewModelDelegate
extension DetailViewController: DetailViewModelDelegate {
    func showError() {
        configureNoDataLabel("Error")
    }

    func hideError() {
        noDataLabel.isHidden = true
    }

    func showNoData() {
        configureNoDataLabel()
    }

    func hideNodata() {
        noDataLabel.isHidden = true
    }

    func showViews() {
        nameLabel.isHidden = false
        metascoreLabel.isHidden = false
        releaseDateLabel.isHidden = false
        gameImage.isHidden = false
        likeImage.isHidden = false
        aboutGameLabel.isHidden = false
        descriptionLabel.isHidden = false
    }

    private func hideViews() {
        xboxLabel.isHidden = true
        pcLabel.isHidden = true
        psImage.isHidden = true
        nameLabel.isHidden = true
        metascoreLabel.isHidden = true
        releaseDateLabel.isHidden = true
        gameImage.isHidden = true
        likeImage.isHidden = true
        aboutGameLabel.isHidden = true
        descriptionLabel.isHidden = true
    }

    func showXbox() {
        xboxLabel.isHidden = false
    }

    func showPC() {
        pcLabel.isHidden = false
    }

    func showPS() {
        psImage.isHidden = false
    }

    func reloadImage() {
        gameImage.image = detailViewModel.getBackgroundImage()
    }

    func detailViewModelDidFetchData() {
        updateView()
    }
}

