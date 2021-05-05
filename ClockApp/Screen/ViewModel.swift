//
//  ViewModel.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var presenters: [LapItemPresenter] = []
    @Published var totalFormattedTime: String = ""
    @Published var isLapStarted: Bool = false
    @Published var leftButtonType: LeftButtonType = .lapPassive
    @Published var totalTimeDegree: Double = 0
    @Published var totalTimeMinuteDegree: Double = 0
    @Published var currentLapDegree: Double?
    
    private var lapIndex: Int = 0
    private var lapTimes: [Double] = []
    private var startDate: Date?
    private var timer: Timer?
    private var totalTimeElapsed: Double = 0
    
    init() {
        self.resetView()
    }
    
    func rightButtonTapped() {
        
        if self.isLapStarted {
            self.updateTimes()
            self.timer?.invalidate()
            self.leftButtonType = .reset
        } else {
            self.startDate = Date()
            self.updatePresenters()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (_) in
                self?.updateCurrentLapTime()
            })
            self.leftButtonType = .lapActive
        }
        self.isLapStarted.toggle()
    }
    
    func leftButtonTapped() {
        switch self.leftButtonType {
        case .lapPassive:
            ()
        case .lapActive:
            self.updateTimes()
            self.lapTimes.append(0)
            self.lapIndex += 1
            self.startDate = Date()
            self.updatePresenters()
        case .reset:
            self.resetView()
        }
    }
    
    private func updateTimes() {
        let timeElapsed = self.getTimeElapsed()
        self.totalTimeElapsed += timeElapsed
        self.lapTimes[self.lapIndex] += timeElapsed
    }
    
    private func resetView() {
        self.leftButtonType = .lapPassive
        self.presenters = []
        self.lapTimes = []
        self.lapTimes.append(0)
        self.lapIndex = 0
        self.totalFormattedTime = self.getFormattedString(0)
        self.totalTimeElapsed = 0
        self.totalTimeDegree = 0
        self.currentLapDegree = nil
    }
    
    private func updateCurrentLapTime() {
        var timeElapsed: TimeInterval = 0
        var laptimeElapsed: TimeInterval = 0
        if startDate != nil {
            laptimeElapsed = self.getTimeElapsed() + self.lapTimes[self.lapIndex]
            timeElapsed = self.getTimeElapsed() + self.totalTimeElapsed
            
            if timeElapsed != 0 {
                self.totalTimeDegree = Double.pi * Double(timeElapsed) / 30
                self.totalTimeMinuteDegree = Double.pi * Double(timeElapsed) / 900
            }
            if laptimeElapsed != 0 {
                self.currentLapDegree = Double.pi * Double(laptimeElapsed) / 30
            }
        }
        
        self.totalFormattedTime = self.getFormattedString(timeElapsed)
        self.presenters[0].time = self.getFormattedString(laptimeElapsed)
    }
    
    private func getTimeElapsed() -> Double {
        return Date().timeIntervalSince1970 - self.startDate!.timeIntervalSince1970
    }
    
    private func getFormattedString(_ timeElapsed: Double) -> String {
        
        var timeElapsed = timeElapsed
        
        let minutes: Int = Int(timeElapsed / 60)
        timeElapsed -= (Double(minutes) * 60)
        
        let seconds: Int = Int(timeElapsed)
        timeElapsed -= Double(seconds)
        
        let miliseconds = Int(timeElapsed * 100)
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, miliseconds)
    }
    
    private func updatePresenters() {
        self.presenters = []
        for (index, lap) in self.lapTimes.enumerated() {
            self.presenters.append(LapItemPresenter(lap: "Lap \(index + 1)",
                                                    time: self.getFormattedString(lap),
                                                    type: .normal))
        }
        var times = self.lapTimes
        times.removeLast()
        if times.count > 1 {
            var minIndex = 0
            var maxIndex = 0
            for (index, time) in times.enumerated() {
                if time < times[minIndex] {
                    minIndex = index
                }
                if time > times[maxIndex] {
                    maxIndex = index
                }
            }
            self.presenters[minIndex].type = .best
            self.presenters[maxIndex].type = .worst
        }
        self.presenters.reverse()
    }
}
