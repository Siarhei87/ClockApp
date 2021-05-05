//
//  LapItemPresenter.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

struct LapItemPresenter: Identifiable {
    
    let id = UUID()
    var lap: String = ""
    var time: String = ""
    var type: LapType = .normal
}
