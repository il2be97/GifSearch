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
     
     
     -- я хочу чтобы ты сделала чтобы кормила из контроллера объект в который надо задекодировать твой response :)
     -> [InformationAboutGig]  - таким способом ты говоришь что твой респонс декодируется в массив InformationAboutGig,
     тебе надо сделать чтобы он работал с любым объектом подписанным на Decodable протокол
     
     посмотри в статье как запрос делается - https://gist.github.com/asmallteapot/1cef51f8c8d8f1c929bb168cf7ce8adb
     
     public func dataTask<T>(with request: URLRequest,
                             decodedAs decodableType: T.Type,
                             using decoder: DataDecoder,
                             completionHandler: @escaping (T?, URLResponse?, Error?) -> Void
     обрати внимание на `<T>` - это дженерик, таким способом ты можешь передать из другого места любой объект, и он попытается задекодировать твой ответ (json) в этот новый объект
     
     +
     
     Сделай чтобы apiRequest передавался целостно:
     if let text = textSearch {
         urlString += "\(text)"
     }
     
     вот это логику вынеси пожалуйста отсюда (если хочешь - можешь в контроллер, либо погугли как, условно посмотри эту статью https://medium.com/swift2go/building-safe-url-in-swift-using-urlcomponents-and-urlqueryitem-alfian-losari-510a7b1f3c7e)
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
