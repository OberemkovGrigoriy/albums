//
//  AlbumCell.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit
import SnapKit

final class AlbumCell: UITableViewCell {
    static let identifier = "AlbumCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.4, height: 2.0)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.6
        return view
    }()
    private let albumLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyText(text: String) {
        albumLabel.text = text
    }

    private func setupLayout() {
        contentView.backgroundColor = .systemGray6
        addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
        }
        albumLabel.textAlignment = .center
        self.cardView.addSubview(albumLabel)
        albumLabel.numberOfLines = 0
        albumLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

