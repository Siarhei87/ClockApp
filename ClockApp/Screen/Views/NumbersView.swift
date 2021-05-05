//
//  NumbersView.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

struct NumbersView: View {
    
    let numbers: [Int]
    let font: Font
    let textColor: Color
    
    var body: some View {
        ZStack {
            ForEach(0..<self.numbers.count) { index in
                let degree: Double = Double.pi * 2 / Double(self.numbers.count)
                let itemDegree = degree * Double(index)
                VStack {
                    Text("\(self.numbers[index])")
                        .rotationEffect(.radians(-itemDegree))
                        .foregroundColor(self.textColor)
                        .font(self.font)
                    Spacer()
                } .rotationEffect(.radians(itemDegree))
            }
        }
    }
}
