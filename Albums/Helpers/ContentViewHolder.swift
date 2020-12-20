//
//  ContentViewHolder.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import UIKit

protocol ContentViewHolder: UIViewController {
    associatedtype ContentView
    var contentView: ContentView { get }
}

extension ContentViewHolder {
    var contentView: ContentView {
        guard let contentView = self.view as? ContentView else {
            fatalError()
        }
        return contentView
    }
}
