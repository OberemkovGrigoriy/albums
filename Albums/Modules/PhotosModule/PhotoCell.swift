//
//  PhotoCell.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit
import AlamofireImage

final class PhotoCell: UICollectionViewCell {
    static let identifier = "PhotosView"
    
    let photoView = UIImageView()
    var model: Photo?

    private let activityIndicator = UIActivityIndicatorView()
    private let downloader = ImageDownloader()
    private var receipt: RequestReceipt?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWith(model: Photo) {
        self.model = model
        activityIndicator.startAnimating()
        let request = URLRequest(url: model.thumbnailUrl)
        self.photoView.backgroundColor = .clear
        self.receipt = self.downloader.download(request, completion:  { [weak self] response in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            if case .success(let image) = response.result {
                self?.photoView.image = image
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.stopAnimating()
        if let receipt = self.receipt {
            self.downloader.cancelRequest(with: receipt)
        }
        self.photoView.image = nil
        self.model = nil
    }

    private func setupLayout() {
        self.contentView.addSubview(photoView)
        photoView.snp.makeConstraints { photoView in
            photoView.edges.equalToSuperview()
        }
        self.contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
