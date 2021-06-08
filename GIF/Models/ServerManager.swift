//
//  ServerManager.swift
//  GIF
//
//  Created by admin on 25.05.2021.
//

import Foundation

class ServerManager: ServerManagerProtocol {
    
    // MARK: Sesrver request
    func serverRequest(apiRequest: String, textSearch: String?) -> [URL] {
                       //urlForImages: @escaping ([URL])->()) {
        var arrayImageUrl = [URL]()
        var urlString = apiRequest
        
        if let text = textSearch {
            urlString += "\(text)"
        }
        
        guard let url = URL(string: urlString) else { return arrayImageUrl}
        let group = DispatchGroup()
        group.enter()
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil, let data = data else {
                print(error)
                return
            }
            do {
                let json = try JSONDecoder().decode(responseFromTheServer.self, from: data)
                guard json.data.count != 0 else { return }
                for i in 0...json.data.count - 1 {
                    arrayImageUrl.append(json.data[i].images.original.url!)
                }
                //urlForImages(arrayImageUrl)
                
            } catch let error {
                print(error)
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return arrayImageUrl
    }
}
