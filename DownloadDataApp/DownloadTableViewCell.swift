//
//  DownloadTableViewCell.swift
//  DownloadDataApp
//
//  Created by Sveta on 09.12.2021.
//

import UIKit

struct DownloadItem {
    let image: UIImage?
}

class DownloadTableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    
    var userImage = UIImageView()
    private let nameLabel = UILabel()
    private var progressBar = UIProgressView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 4))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(userImage)
        self.addSubview(progressBar)
        self.initialSetup()
        self.configureImage()
        self.userImageSetupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        self.userImage.contentMode = .scaleAspectFit
        self.progressBar.isHidden = true
    }

    private func configureImage() {
        self.userImage.layer.cornerRadius = 12
        self.userImage.layer.opacity = 0.8
    }
    private func userImageSetupLayout() {
        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.userImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func updateImage(_ image: UIImage?) {
        self.progressBar.isHidden = true
        self.userImage.image = image
    }
    
    func updateProgress(_ progress: Float) {
        self.progressBar.isHidden = false
        self.progressBar.progress = progress
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImage.image = nil
        self.progressBar.progress = 0.0
        self.progressBar.isHidden = true
    }
}
