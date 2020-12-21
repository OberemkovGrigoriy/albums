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
    
    private let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWith(model: Photo) {
        activityIndicator.startAnimating()
        let downloader = ImageDownloader()
        let urlRequest = URLRequest(url: model.thumbnailUrl)
        self.photoView.backgroundColor = UIColor.systemGray4
        downloader.download(urlRequest, completion:  { [weak self] response in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            if case .success(let image) = response.result {
                self?.photoView.image = image
            }
        })
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
