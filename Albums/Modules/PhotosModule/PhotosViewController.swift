//
//  PhotosViewController.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit

final class PhotosViewController: UIViewController, ContentViewHolder {
    typealias ContentView = PhotosView

    var selectedCell: UICollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    
    private var photos: [Photo] = []
    private let photosService = PhotosService()
    private let id: Int
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PhotosView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.backgroundColor = UIColor.systemGray6
        self.contentView.collectionView.delegate = self
        self.contentView.collectionView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.contentView.collectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.identifier
        )
        self.contentView.addAction(action: self.dowloadPhotos)
        self.dowloadPhotos()
    }

    private func dowloadPhotos() {
        self.contentView.state = .loading
        self.photosService.request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos.filter { $0.albumId == self.id }
                self.contentView.collectionView.reloadData()
                self.contentView.state = .downloaded
            case .failure:
                self.contentView.state = .error
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCellImageViewSnapshot = selectedCell?.contentView.snapshotView(afterScreenUpdates: false)
        guard
            let photoCell = selectedCell as? PhotoCell,
            let selectedImage = photoCell.photoView.image,
            let title = photoCell.model?.title,
            let url = photoCell.model?.url
        else { return }
        let controller = PhotoDetailViewController(image: selectedImage, title: title, imageURL: url)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.present(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.contentView.collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.updateWith(model: photos[indexPath.row])
        return cell
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let photoDetailsVC = presented as? PhotoDetailViewController,
            let selectedSnapshot = self.selectedCellImageViewSnapshot
        else { return nil }
        
        return Animator(
            type: .present,
            firstViewController: (presenting as! UINavigationController).viewControllers.last! as! PhotosViewController,
            secondViewController: photoDetailsVC,
            selectedCellImageViewSnapshot: selectedSnapshot
        )
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let secondViewController = dismissed as? PhotoDetailViewController,
            let selectedSnapshot = self.selectedCellImageViewSnapshot
        else { return nil }
        return Animator(
            type: .dismiss,
            firstViewController: self,
            secondViewController: secondViewController,
            selectedCellImageViewSnapshot: selectedSnapshot
        )
    }
}
