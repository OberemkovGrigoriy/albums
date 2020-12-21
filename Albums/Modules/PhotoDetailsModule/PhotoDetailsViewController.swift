//
//  PhotoDetailsViewController.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit
import AlamofireImage

final class PhotoDetailViewController: UIViewController, ContentViewHolder {
    typealias ContentView = PhotoDetailView

    private let photoImage: UIImage
    private let imageTitle: String
    private let imageURL: URL

    private let downloader = ImageDownloader()
    private var receipt: RequestReceipt?

    init(image: UIImage, title: String, imageURL: URL) {
        self.photoImage = image
        self.imageTitle = title
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PhotoDetailView(image: self.photoImage, imageTitle: self.imageTitle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.backgroundColor = .systemGray6
        self.contentView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        self.dowloadImage()
    }

    private func dowloadImage() {
        let request = URLRequest(url: imageURL)
        self.receipt = self.downloader.download(request, completion:  { [weak self] response in
            if case .success(let image) = response.result {
                self?.contentView.imageView.image = image
            }
        })
    }

    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
}
