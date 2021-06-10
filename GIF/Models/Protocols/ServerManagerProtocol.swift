//
//  ServerManagerProtocol.swift
//  GIF
//
//  Created by admin on 03.06.2021.
//

import UIKit

protocol ServerManagerProtocol {
    func serverRequest(apiRequest: String, textSearch: String?) -> [InformationAboutGig]
}
