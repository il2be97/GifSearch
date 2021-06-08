//
//  DelayToGetText.swift
//  GIF
//
//  Created by admin on 03.06.2021.
//

import Foundation

protocol DelayToGetTextDelegate {
    func serverResponse()
}

class DelayToGetText: DelayToGetTextProtocol {
    
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
