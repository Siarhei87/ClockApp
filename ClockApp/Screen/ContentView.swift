//
//  ContentView.swift
//  ClockApp
//
//  Created by Siarhei Dubko on 5.05.21.
//

import SwiftUI

struct ContentView: View {
    
    private let marginLeading: CGFloat = 16
    private let marginTrailing: CGFloat = 16
    private let marginTop: CGFloat = 12
    private let tickHeight: CGFloat = 8
    private let longTickHeight: CGFloat = 14
    private let tickWidth: CGFloat = 2
    private let numberPadding: CGFloat = 40
    private let actionButtonPadding: CGFloat = 16
    
    private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            GeometryReader { geometryReader in
                VStack {
                    ZStack {
                        let width = geometryReader.size.width
                            - self.marginLeading
                            - self.marginTrailing
                        ClockView(count: 240,
                                  longDivider: 4,
                                  longTickHeight: self.longTickHeight,
                                  tickHeight: self.tickHeight,
                                  tickWidth: self.tickWidth,
                                  highlightedColorDivider: 20,
                                  highlightedColor: .clockHighlightedLineColor,
                                  normalColor: .clockLinecolor)
                            .frame(width: width, height: width)
                        
                        let numberWidth = width - self.numberPadding
                        NumbersView(numbers: self.getNumbers(count: 12),
                                    font: .clockText,
                                    textColor: .clockTextColor)
                            .frame(width: numberWidth, height: numberWidth)
                        
                        NeedleView(width: 8,
                                   height: width,
                                   color: .needleNormal,
                                   bottomLineHeight: 30)
                            .rotationEffect(.radians(Double.pi / 2))
                        
                        HStack {
                            
                            Button("Reset") {
                                print("Test")
                            } .buttonStyle(ActionButtonStyle(textColor: .leftButtonText, backgroundColor: .leftButton))
                            
                            Spacer()
                            
                            Button("Start") {
                                print("Test")
                            } .buttonStyle(ActionButtonStyle(textColor: .rightButtonText, backgroundColor: .rightButton))
                            
                        } .padding(.top, width + self.actionButtonPadding)
                    }
                    .padding(.leading, self.marginLeading)
                    .padding(.trailing, self.marginTrailing)
                    .padding(.top, self.marginTop)
                    
                    List {
                        ForEach(self.viewModel.presenters) { item in
                            VStack(alignment: .leading, spacing: 12) {
                                Color.lapCellSeparator.frame(width: geometryReader.size.width,
                                                             height: 1)
                                HStack {
                                    let color = self.getLapTextColor(item.type)
                                    Text(item.lap)
                                        .foregroundColor(color)
                                        .font(.lapCellText)
                                    Spacer()
                                    Text(item.time)
                                        .foregroundColor(color)
                                        .font(.lapCellText)
                                }
                            }
                        } .listRowBackground(Color.backgroundColor)
                    } .onAppear(perform: {
                        UITableView.appearance().backgroundColor = .clear
                        UITableViewCell.appearance().backgroundColor = .clear
                    })
                }
            }
        }
    }
    
    private func getNumbers(count: Int) -> [Int] {
        var numbers: [Int] = []
        numbers.append(count * 5)
        for index in 1..<count {
            numbers.append(index * 5)
        }
        return numbers
    }
    
    private func getLapTextColor(_ type: LapType) -> Color {
        switch type {
        case .normal:
            return .lapCellNormal
        case .best:
            return .lapCellBest
        case .worst:
            return .lapCellWorst
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
