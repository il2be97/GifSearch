//
//  ResponseFromTheServer.swift
//  GIF
//
//  Created by admin on 26.05.2021.
//

import Foundation

struct ResponseFromTheServer: Decodable {
    var data: [DataJson]
}

struct DataJson: Decodable {
    var images: Images
}

struct Images: Decodable {
    var original: InformationAboutGig
}

struct InformationAboutGig: Decodable {
    var height: String
    var width: String
    var url: URL
}
