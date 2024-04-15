//
//  Model.swift
//  UnsplashScroll
//
//  Created by Matrix on 14/04/24.
//

import Foundation


struct Photo: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
    let thumb: String
}
