//
//  PhotoModel.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import Foundation

struct Photo: Decodable {
    let id: Int
    let albumId: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
