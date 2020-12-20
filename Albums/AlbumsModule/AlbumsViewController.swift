//
//  AlbumsViewController.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit

final class AlbumsViewController: UIViewController, ContentViewHolder {
    typealias ContentView = ViewWithTable
    var albums: [Album] = []
    
    private let albumService = AlbumService()

    override func loadView() {
        self.view = ViewWithTable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.dowloadAlbums()
    }
    
    private func setupView() {
        self.title = "Albums"
        self.navigationController?.navigationBar.barTintColor = .systemGray6
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.contentView.backgroundColor = UIColor.systemGray6
        
        self.contentView.tableView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
        self.contentView.tableView.delegate = self
        self.contentView.tableView.dataSource = self
        self.contentView.tableView.separatorStyle = .none

        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.title = "Albums"
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addAction(action: self.dowloadAlbums)
    }
    
    private func dowloadAlbums() {
        self.contentView.state = .loading
        self.albumService.request { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                switch result {
                case .success(let albums):
                    self.albums = albums
                    self.contentView.tableView.reloadData()
                    self.contentView.state = .downloaded
                case .failure:
                    self.contentView.state = .error
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDatasource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
        cell.applyText(text: albums[indexPath.row].title)
        return cell
    }
}

