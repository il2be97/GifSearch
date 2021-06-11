//
//  TimerManager.swift
//  GIF
//
//  Created by admin on 03.06.2021.
//

import Foundation

protocol TimerManagerDelegate {
    func timerСompleted()
}

/* Поиграйся с атрибутами доступа - поставь где нужно private */
class TimerManager: TimerManagerProtocol {
    var timer: Timer?
    /* timeDelay - ты можешь устанавливать из инициализатова, чтобы в разных контроллерах использовать разную задержку - попробуй сделать инициализатор с этой переменной (0.7 условно будет лежать в контроллере как переменная) */
    let timeDelay = 0.7
    var delegate: TimerManagerDelegate?
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeDelay, target: self, selector: #selector(gettingImageLinks), userInfo: nil, repeats: false)
    }
    
    @objc func gettingImageLinks(){
        delegate?.timerСompleted()
    }
}
