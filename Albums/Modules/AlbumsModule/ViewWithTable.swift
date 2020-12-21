//
//  ViewWithTable.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit
import SnapKit

final class ViewWithTable: UIView {

    var tableView = UITableView()
    
    var state: LoadingViewState = .loading {
        didSet {
            self.setupViewState()
        }
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let errorButton = UIButton()
    private var action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupViewState()
        self.setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAction(action: @escaping () -> Void) {
        self.action = action
    }

    private func setupLayout() {
        self.tableView.backgroundColor = UIColor.systemGray6
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
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
            self.tableView.isHidden = true
            self.errorButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .error:
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.errorButton.isHidden = false
            self.tableView.isHidden = true
        case .downloaded:
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.errorButton.isHidden = true
            self.tableView.isHidden = false
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
