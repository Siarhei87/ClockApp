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
    
    init() {
        self.presenters = [
            LapItemPresenter(lap: "lap 1", time: "00.02.85", type: .normal),
            LapItemPresenter(lap: "lap 2", time: "00.02.85", type: .normal),
            LapItemPresenter(lap: "lap 3", time: "00.02.85", type: .best),
            LapItemPresenter(lap: "lap 4", time: "00.02.85", type: .worst),
            LapItemPresenter(lap: "lap 5", time: "00.02.85", type: .normal)
        ]
    }
}
