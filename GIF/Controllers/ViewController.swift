//
//  ViewController.swift
//  GIF
//
//  Created by admin on 25.05.2021.
//

import UIKit

class SearchGifViewController: UIViewController, DelayToGetTextDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    /* Если ты не собираешься в процессе менять эти переменные - они не должны быть var */
    var serverManager: ServerManagerProtocol?
    var delay: DelayToGetText?
    var apiRequest = "https://api.giphy.com/v1/gifs/search?api_key=yUQshQuEGxnOMme5L0gvO1visY2m5G7i&q="
    var arrayGifUrl = [URL]()
    
    private var cellHeight = CGFloat()
    private var cellWidth = CGFloat()
    // чем отличие :Int и =Int()
    
    // MARK: Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay = DelayToGetText()
        delay?.delegate = self
        serverManager = ServerManager()
        
        collectionView.register(UINib(nibName: "CollectionViewCellWithGif", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCellWithGif")
    }
    
    override func viewDidLayoutSubviews() {
        cellHeight = 150
        cellWidth = collectionView.frame.width / 2 - 10
    }
    
    // MARK: IBAction
    @IBAction func textFiedAction(_ sender: UITextField) {
        let text = self.textField.text
        if text?.isEmpty == true {
            arrayGifUrl = []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            delay?.startTimer()
        }
    }
    
    func serverResponse() {
        arrayGifUrl = (serverManager?.serverRequest(apiRequest: apiRequest,textSearch: textField.text))!
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.collectionView.reloadData()
        }
        
        
        //        DispatchQueue.main.async {
        // 
        //        }
        //        serverManager?.serverRequest(apiRequest: apiRequest,
        //                                     textSearch: textField.text,
        //                                     urlForImages: { (arrayGifUrl) in
        //                                        self.arrayGifUrl = arrayGifUrl
        //
        //                                        DispatchQueue.main.async {
        //                                            self.collectionView.reloadData()
        //                                        }
        //                                      })
        
    }
}
extension SearchGifViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGifUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellWithGif", for: indexPath) as! CollectionViewCellWithGif
        cell.runGif(with: arrayGifUrl[indexPath.row])
        return cell
    }
}

extension SearchGifViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: CollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellHeight)
    }
}

