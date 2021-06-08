//
//  Json.swift
//  GIF
//
//  Created by admin on 26.05.2021.
//

import Foundation

struct responseFromTheServer: Decodable {
    var data: [DataJson]
}

struct DataJson: Decodable {
    var images: Images
}

struct Images: Decodable {
    var original: Original
}

struct Original: Decodable {
    var height: String
    var width: String
    var url: URL?
    
    init(url: String,height:String, width: String ) {
        self.url = URL(string: url) ?? nil
        self.height = height
        self.width = width
    }
}
