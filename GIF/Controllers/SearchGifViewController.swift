//
//  SearchGifViewController.swift
//  GIF
//
//  Created by admin on 25.05.2021.
//

import UIKit

class SearchGifViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    
    /* Если ты не собираешься в процессе менять эти переменные - они не должны быть var
     
     -- Тогда их необходимо сразу инициализировать. Так будет правильно??
     
     -- Да, ты их нигде не пересоздаешься и ты их один раз за время жизни контроллера создаешьб поэтому если ты проиницилизируешь сразу serverManager, timerManager - будет ок (конечно можешь переопределить инициализатор, но так как ты работаешь со сторибордом - это не получится сделать
     
     */
    
    var serverManager: ServerManagerProtocol?
    var timerManager: TimerManager?
    var arrayGif = [InformationAboutGig]()
    
    private lazy var cellHeight: CGFloat = 150
    private lazy var cellWidth: CGFloat = collectionView.frame.width / 2 - 10
    // чем отличие :Int и =Int()
    /// Это вопрос?
    
    // MARK: Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerManager = TimerManager()
        timerManager?.delegate = self
        serverManager = ServerManager()
        
        collectionView.register(UINib(nibName: "CollectionViewCellWithGif", bundle: nil), forCellWithReuseIdentifier: CollectionViewCellWithGif.identifier)
    }
    
    
    // MARK: IBAction
    @IBAction func textFiedAction(_ sender: UITextField) {
        let text = self.textField.text
        if text?.isEmpty == true {
           
            /* сюда можешь запихнуть и
             self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
             даже при пустом массиве если ты это вызовешь - не будет страшно
             -- ЗАЧЕМ тут этот метод? */
            
            /*
             По-сути у тебя идет дублирование кода (не страшное - на как вариант можно исправить):
             
             collectionView.reloadData()
             arrayGif = arrayGifInformation
             
             - можно вынести логику в одно место, чтобы избежать дублирование - но это не страшно
             */
            
            arrayGif.removeAll()
            collectionView.reloadData()
        } else {
            timerManager?.startTimer()
        }
    }
}

// MARK: CollectionViewDataSource
extension SearchGifViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGif.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellWithGif.identifier, for: indexPath) as! CollectionViewCellWithGif
        cell.runGif(with: arrayGif[indexPath.row].url)
        return cell
    }
}

// MARK: CollectionViewFlowLayout
extension SearchGifViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth , height: cellHeight)
    }
}

// MARK: DelayToGetTextDelegate
extension SearchGifViewController: TimerManagerDelegate {
    func timerСompleted() {
        if let arrayGifInformation = serverManager?.serverRequest(apiRequest: API.apiRequest,textSearch: textField.text) {
            arrayGif = arrayGifInformation
        }
        
        /* даже если у тебя ошибка с сервера пришла, массив по-сути не изменится но ты скроллишь вверх и обновляешь таблицу - не думаю что это правильно*/
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.collectionView.reloadData()
        }
    }
}

