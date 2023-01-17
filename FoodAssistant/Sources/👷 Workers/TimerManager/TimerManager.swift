//
//  TimerManager.swift
//  FoodAssistant
//
//  Created by Владимир Рубис on 11.01.2023.
//

import Foundation

protocol TimerManagerUpdatable: AnyObject {

    func didUpdateTimers(timers: [RecipeTimer])
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

    private var timers: [RecipeTimer] = [] {
        didSet {
            delegate?.didUpdateTimers(timers: timers)
        }
    }

    private var stepTimer: StepTimer?

    static let shared = TimerManager()

    private init() {}
}

extension TimerManager: TimerManagement {

    func addTimer(for stepTimer: StepTimer) {

        let recipeTimer = RecipeTimer(stepTimer: stepTimer) { _ in
//            print("XXX - \(x)")
        }

        recipeTimer.start()
        timers.append(recipeTimer)

        print(timers)
    }

    func deleteTimer(for timer: StepTimer) {
        guard let index = timers.firstIndex(where: {$0.stepTimer == stepTimer}) else { return }
        timers[index].stop()
        timers.remove(at: index)
    }

    func stopTimer(for timer: StepTimer) {
        guard let index = timers.firstIndex(where: {$0.stepTimer == stepTimer}) else { return }
        timers[index].stop()
    }

    func startTimer(for timer: StepTimer) {
        guard let index = timers.firstIndex(where: {$0.stepTimer == stepTimer}) else { return }
        timers[index].start()
    }
}

struct StepTimer: Equatable {
    /// Идентификатор рецепта
    var id: Int
    /// Название рецепта
    var title: String
    /// Шаг рецепта
    var step: Int
    /// Таймер
    var timer: Timer?

    var count: Int {
        didSet {
            guard count == 0 else { return }
            print(titleNotification)
        }
    }

    mutating func countDown() {
        count -= 1
    }

    var titleNotification: String {
        "Рецепт: \(title)/nШаг \(step)"
    }

    static func == (lhs: StepTimer, rhs: StepTimer) -> Bool {
        lhs.id ==  rhs.id && lhs.step ==  rhs.step
    }
}

class Weak<T: AnyObject> {
  weak var value: T?
  init (value: T) {
    self.value = value
  }
}

class RecipeTimer: Equatable {

    typealias Update = (Int) -> Void
    var timer: Timer?
    var count: Int
    var stepTimer: StepTimer
    var update: Update?

    init(stepTimer: StepTimer, update: @escaping Update) {
        self.stepTimer = stepTimer
        self.update = update
        self.count = stepTimer.count
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
//        if timer != nil {
//            RunLoop.current.add(timer!, forMode: .common)
//        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func restart() {
        count = stepTimer.count
    }
    /**
     * This method must be in the public or scope
     */
    @objc func timerUpdate() {

        guard count > 0 else {
            timer?.invalidate()
            return
        }
        count -= 1

        if let update = update {
            update(count)
        }
    }

    static func == (lhs: RecipeTimer, rhs: RecipeTimer) -> Bool {
        lhs.stepTimer.id ==  rhs.stepTimer.id && lhs.stepTimer.step ==  rhs.stepTimer.step
    }
}
