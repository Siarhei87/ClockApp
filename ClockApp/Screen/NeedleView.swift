//
//  NeedleView.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import Foundation
import SwiftUI

struct NeedleView: View {
    
    let width: CGFloat
    let height: CGFloat
    let color: Color
    var bottomLineHeight: CGFloat? = nil
    
    var body: some View {
        
        let quarterWidth = self.width / 4
        let halfHeight = self.height / 2
        
        VStack(spacing: 0) {
            Rectangle()
                .fill(self.color)
                .frame(width: quarterWidth, height: halfHeight)
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(self.color, lineWidth: quarterWidth)
                .frame(width: self.width, height: self.width)
            if let bottomLineHeight = self.bottomLineHeight {
                Rectangle()
                    .fill(self.color)
                    .frame(width: quarterWidth, height: bottomLineHeight)
            }
            
            Spacer()
        } .frame(width: self.width, height: self.height)
    }
}
