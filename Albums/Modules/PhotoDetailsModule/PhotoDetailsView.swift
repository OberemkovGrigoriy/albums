//
//  PhotoDetailsView.swift
//  Albums
//
//  Created by Gregory Oberemkov on 21.12.2020.
//

import UIKit

final class PhotoDetailView: UIView {
    var imageView = UIImageView()
    
    let closeButton = UIButton(type: .close)
    
    private let imageTitle: String
    private let titleLabel = UILabel()

    init(image: UIImage, imageTitle: String) {
        self.imageTitle = imageTitle
        super.init(frame: .zero)
        self.imageView.image = image
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = self.imageTitle
        self.addSubview(imageView)
        self.imageView.isUserInteractionEnabled = true
        self.imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(UIApplication.shared.windows[0].frame.height / 2)
            make.width.equalTo(UIApplication.shared.windows[0].frame.width)
        }
        
        self.imageView.addSubview(closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.left.equalToSuperview().inset(20)
        }

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(self.imageView.snp.bottom).offset(50)
        }
    }
}
