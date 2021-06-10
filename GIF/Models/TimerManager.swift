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

class TimerManager: TimerManagerProtocol {
    var timer: Timer?
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
