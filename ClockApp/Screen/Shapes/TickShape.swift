//
//  TickShape.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

struct TickShape: Shape {
    
    let tickHeight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + self.tickHeight))
        return path
    }
    
}
