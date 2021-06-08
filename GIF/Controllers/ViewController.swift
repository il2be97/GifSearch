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
    
    /* Эти методы можешь назвать условно timerManager: TimerManager */
    var delay: DelayToGetText?
    
    /* создай папку Constants и помести пожалуйста это поле туда (можешь сделать enum обширный), посмотри вот эти статьи:
     https://betterprogramming.pub/organizing-your-swift-global-constants-for-beginners-251579485046
     https://medium.com/swift-india/defining-global-constants-in-swift-a80d9e5cbd42
     они на английсском но попробуй разобрать или найти другие
     */
    var apiRequest = "https://api.giphy.com/v1/gifs/search?api_key=yUQshQuEGxnOMme5L0gvO1visY2m5G7i&q="
    
    /* Можешь хранить не [URL], а массив объектов в которых хранится эти URL, и уже в методе cellForItem доставать эти url */
    var arrayGifUrl = [URL]()
    
    /* не обязательно делать эти переменные во viewDidLayoutSubviews, можешь сделать их lazy var либо computed (попробуй два варианта чтобы посмотреть что для тебя удобнее), минус viewDidLayoutSubviews - в том что он не очень явен, вызывается после перерисовки */
    private var cellHeight = CGFloat()
    private var cellWidth = CGFloat()
    // чем отличие :Int и =Int()
    
    // MARK: Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delay = DelayToGetText()
        delay?.delegate = self
        serverManager = ServerManager()
        
        /* Можешь поместить CollectionViewCellWithGif это значение в CollectionViewCellWithGif и сделать его статическим (условно
         static let identifier: String = "CollectionViewCellWithGif"
         так если нам надо будет перееминовать этот идентификатор нам не нужно будет менять его по всему проекту.
         пример:
         у тебя будет 10 viewController где используется эта ячейка, тебе надо будет поменять этот идентификатор (просто с CollectionViewCellWithGif на CollectionViewCellWithGif1 (не спрашивай зачем) - тебе не понадобится шерстить по 10 контроллерам и менять эту стрингу, а можно будет сделать это в одном месте
         */
        collectionView.register(UINib(nibName: "CollectionViewCellWithGif", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCellWithGif")
    }
    
    /* это можно будет убрать как я писал ранее :)) */
    override func viewDidLayoutSubviews() {
        cellHeight = 150
        cellWidth = collectionView.frame.width / 2 - 10
    }
    
    // MARK: IBAction
    @IBAction func textFiedAction(_ sender: UITextField) {
        let text = self.textField.text
        if text?.isEmpty == true {
            /* у массива есть метод removeAll() - попробуй использовать его вместо arrayGifUrl = [], выглядит немного более корректно :), либо сделать один метод updateUI(gifsArray: [Твои объекты], и вызывать его во всех местах чтобы избежать дублирования кода -
             
             arrayGifUrl = []
             DispatchQueue.main.async {
                 self.collectionView.reloadData()
             }
             
             сюда можешь запихнуть и
             self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
             даже при пустом массиве если ты это вызовешь - не будет страшно
             */
            arrayGifUrl = []
            
            /* тут необязателен DispatchQueue.main.async { } так как тут нет перехода в другой поток */
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            delay?.startTimer()
        }
    }
    
    /* сделай пожалуйста extension SearchGifViewController: DelayToGetTextDelegate, будет больше явности (а то когда я заглянул в этот контроллер, мне немного не понятно было как он вызывался)  */
    func serverResponse() {
        /* старайся избегать восклицательных знаков - это можешь вызвать ошибки и многие стараются избегать этого */
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

/* В этой части все хорошо если не считать CollectionViewCellWithGif идентификатор, даже в восклицательном знаке тут ничего супер страшного нету, ну еще // MARK: CollectionViewDataSource ты можешь вынести до extension  */
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

