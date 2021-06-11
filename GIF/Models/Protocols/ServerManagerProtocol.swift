//
//  ServerManagerProtocol.swift
//  GIF
//
//  Created by admin on 03.06.2021.
//

import UIKit

// InformationAboutGig - мне кажется последняя буква не должна быть g :))
protocol ServerManagerProtocol {
    func serverRequest(apiRequest: String, textSearch: String?) -> [InformationAboutGig]
}
