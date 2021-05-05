//
//  ActionButtonStyle.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    
    let textColor: Color
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(self.backgroundColor, lineWidth: 2)
            )
            .background(Circle().foregroundColor(self.backgroundColor).padding(4))
            .foregroundColor(self.textColor)
    }
}
