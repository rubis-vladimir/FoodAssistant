//
//  TimerManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import Foundation


protocol TimerManagerUpdatable: AnyObject {
    
    func didUpdateTimers(timers: [StepTimer])
}

protocol TimerManagement {
    func addTimer(for timer: StepTimer)
    
    func deleteTimer(for timer: StepTimer)
    
    func stopTimer(for timer: StepTimer)
    
    func startTimer(for timer: StepTimer)
}

/// #Менеджер  работы с таймерами обратного отсчета
final class TimerManager {
    
    weak var delegate: TimerManagerUpdatable?
    
    private var timers: [StepTimer] = [] {
        didSet {
            delegate?.didUpdateTimers(timers: timers)
        }
    }
    
    private let shared = TimerManager()
    
    init() {}
}

extension TimerManager: TimerManagement {
    func addTimer(for timer: StepTimer) {
        
    }
    
    func deleteTimer(for timer: StepTimer) {
        guard let index = timers.firstIndex(where: {$0.title == timer.title}) else { return }
        timers[index].timer?.invalidate()
        timers.remove(at: index)
    }
    
    func stopTimer(for timer: StepTimer) {
        guard let index = timers.firstIndex(where: {$0.title == timer.title}) else { return }
        timers[index].timer?.invalidate()
    }
    
    func startTimer(for timer: StepTimer) {
        
    }
}

struct StepTimer {
    
    var title: String
    var timer: Timer?
    var step: InstuctionStep
    
    var count: Int {
        didSet {
            guard count == 0 else { return }
            print("Уведомление \(title)")
        }
    }
}
