//
//  PhotoDetailsViewController.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit

final class PhotoDetailViewController: UIViewController, ContentViewHolder {
    typealias ContentView = PhotoDetailView

    private var photoImage: UIImage

    init(image: UIImage) {
        self.photoImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PhotoDetailView(image: self.photoImage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.backgroundColor = .systemGray6
        self.contentView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }

    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
}

final class PhotoDetailView: UIView {
    var imageView = UIImageView()
    
    let closeButton = UIButton(type: .close)
    
    init(image: UIImage) {
        imageView.image = image
        super.init(frame: .zero)
        setupLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(UIApplication.shared.windows[0].frame.height / 2)
            make.width.equalTo(UIApplication.shared.windows[0].frame.width)
        }
        
        imageView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.left.equalToSuperview().inset(20)
        }
    }
}
