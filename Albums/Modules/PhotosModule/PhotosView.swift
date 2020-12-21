//
//  PhotosView.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit
import SnapKit

final class PhotosView: UIView {
    var collectionView: UICollectionView
    
    var state: LoadingViewState = .loading {
        didSet {
            self.setupViewState()
        }
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorButton = UIButton()
    private var action: (() -> Void)?

    override init(frame: CGRect) {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let size = UIApplication.shared.windows[0].frame.width / 5
        collectionViewFlowLayout.itemSize = CGSize(width: size, height: size)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        super.init(frame: frame)
        self.setupViewState()
        self.setupLayout()
        self.setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAction(action: @escaping () -> Void) {
        self.action = action
    }

    private func setupLayout() {
        collectionView.backgroundColor = UIColor.systemGray6
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(errorButton)
        errorButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(44)
            make.width.equalTo(150)
        }
    }

    private func setupViewState() {
        switch self.state {
        case .loading:
            self.collectionView.isHidden = true
            self.errorButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .error:
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.errorButton.isHidden = false
            self.collectionView.isHidden = true
        case .downloaded:
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.errorButton.isHidden = true
            self.collectionView.isHidden = false
        }
    }

    private func setupButton() {
        self.errorButton.setTitle("Try again", for: .normal)
        self.errorButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.errorButton.layer.borderWidth = 0.5
        self.errorButton.layer.cornerRadius = 5
        self.errorButton.tintColor = .black
        self.errorButton.setTitleColor(.black, for: .normal)
    }

    @objc private func buttonTapped() {
        self.action?()
    }
}
