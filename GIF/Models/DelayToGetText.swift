//
//  DelayToGetText.swift
//  GIF
//
//  Created by admin on 03.06.2021.
//

import Foundation

/* Это название очень сильно уменьшает переиспользованность этого класса ( перевеод названия класса - задержка для получения текста) исходя из нвазания - кажется что ты можешь использовать этот класс только для получения текста, и если понадобится использовать этот класс для другой логики (условно таймер для обновления UI) он не будет подходить, старайся думать более абстрактно, можешь условно назвать его TimerManager  */
protocol DelayToGetTextDelegate {
    func serverResponse()
}

class DelayToGetText: DelayToGetTextProtocol {
    
    /* Нет смысла в такой инициализации так как эту переменную мы сразу пересоздадаим при вызове startTimer, сделай условно var timer: Timer?  */
    var timer = Timer()
    let timeDelay = 0.7
    var delegate: DelayToGetTextDelegate?
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeDelay, target: self, selector: #selector(gettingImageLinks), userInfo: nil, repeats: false)
    }
    
    @objc func gettingImageLinks(){
        delegate?.serverResponse()
    }
}
