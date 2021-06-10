//
//  ServerManager.swift
//  GIF
//
//  Created by admin on 25.05.2021.
//

import Foundation

class ServerManager: ServerManagerProtocol {
    
    // MARK: Sesrver request
    /* перееменуй его пожалуйста `УСЛОВНО (тут можешь по-другому сделать)` func serverRequest<Response: Codable>(url: URL, completion: @escaping (Response) -> ()) (либо попробуй переписать под себя)
     таким образом ты сможешь использовать этот метод в любом месте с любым запросом и получать любой ответ
     https://gist.github.com/asmallteapot/1cef51f8c8d8f1c929bb168cf7ce8adb
     
     -- ты хочешь, чтобы я разделила запрос и ответ?
     */
    
    func serverRequest(apiRequest: String, textSearch: String?) -> [InformationAboutGig] {
        var arrayGif = [InformationAboutGig]()
        var urlString = apiRequest
        
        if let text = textSearch {
            urlString += "\(text)"
        }
        guard let url = URL(string: urlString) else { return arrayGif}
        let group = DispatchGroup()
        group.enter()
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil, let data = data else {
                print(error)
                return
            }
            do {
                let json = try JSONDecoder().decode(ResponseFromTheServer.self, from: data)
                if json.data.count != 0 {
                    for i in 0...json.data.count - 1 {
                        arrayGif.append(json.data[i].images.original)
                    }
                }
            } catch let error {
                print(error)
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return arrayGif
    }
}
