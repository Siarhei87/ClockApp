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
    private let miniTickHeight: CGFloat = 6
    private let miniLongTickHeight: CGFloat = 9
    private let tickWidth: CGFloat = 2
    private let numberPadding: CGFloat = 40
    private let miniNumberPadding: CGFloat = 24
    private let actionButtonPadding: CGFloat = 16
    
    @ObservedObject private var viewModel: ViewModel = ViewModel()
    
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
                        
                        let miniWidth = width * 0.27
                        let miniExtraMarginFromBottom = width * 0.1
                        let miniPaddingBottom = miniWidth + miniExtraMarginFromBottom
                        ClockView(count: 48,
                                  longDivider: 2,
                                  longTickHeight: self.miniLongTickHeight,
                                  tickHeight: self.miniTickHeight,
                                  tickWidth: self.tickWidth,
                                  highlightedColorDivider: 8,
                                  highlightedColor: .clockHighlightedLineColor,
                                  normalColor: .clockLinecolor)
                            .frame(width: miniWidth, height: miniWidth)
                            .padding(.bottom, miniPaddingBottom)
                        
                        let numberWidth = width - self.numberPadding
                        NumbersView(numbers: self.getNumbers(count: 12),
                                    font: .clockText,
                                    textColor: .clockTextColor)
                            .frame(width: numberWidth, height: numberWidth)
                        
                        let minNumberWidth = miniWidth - self.miniNumberPadding
                        NumbersView(numbers: self.getNumbers(count: 6),
                                    font: .miniClockText,
                                    textColor: .clockTextColor)
                            .frame(width: minNumberWidth, height: minNumberWidth)
                            .padding(.bottom, miniPaddingBottom)
                        
                        Text(self.viewModel.totalFormattedTime)
                            .font(.lapText)
                            .foregroundColor(.clockTextColor)
                            .padding(.top, width * 0.39)
                        
                        if self.viewModel.currentLapDegree != nil {
                            NeedleView(width: 8,
                                       height: width,
                                       color: .needleCurrentLap,
                                       bottomLineHeight: 30,
                                       filledCenter: false)
                                .rotationEffect(.radians(self.viewModel.currentLapDegree!))
                        }
                        
                        NeedleView(width: 8,
                                   height: width,
                                   color: .needleNormal,
                                   bottomLineHeight: 30,
                                   filledCenter: false)
                            .rotationEffect(.radians(self.viewModel.totalTimeDegree))
                        
                        NeedleView(width: 6,
                                   height: miniWidth,
                                   color: .needleNormal,
                                   filledCenter: true)
                            .rotationEffect(.radians(Double.pi / 2))
                            .padding(.bottom, miniPaddingBottom)
                        
                        HStack {
                            let leftButtonFeatures = self.getLeftButtonFeatures()
                            Button(leftButtonFeatures.0) {
                                self.viewModel.leftButtonTapped()
                            } .buttonStyle(ActionButtonStyle(textColor: leftButtonFeatures.1, backgroundColor: leftButtonFeatures.2))
                            
                            Spacer()
                            
                            let rightButtonTextColor: Color = self.viewModel.isLapStarted
                                ? .rightButtonActiveText
                                : .rightButtonText
                            let rightButtonBackgrounColor: Color = self.viewModel.isLapStarted
                                ? .rightButtonActive
                                : .rightButton
                            Button(self.viewModel.isLapStarted ? "Stop" : "Start") {
                                self.viewModel.rightButtonTapped()
                            } .buttonStyle(ActionButtonStyle(textColor: rightButtonTextColor, backgroundColor: rightButtonBackgrounColor))
                            
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
    
    private func getLeftButtonFeatures() -> (String, Color, Color) {
        switch self.viewModel.leftButtonType {
        case .lapPassive:
            return ("Lap", .leftButtonText, .leftButton)
        case .lapActive:
            return ("lap", .leftButtonActiveText, .leftButtonActive)
        case .reset:
            return ("Reset", .leftButtonActiveText, .leftButtonActive)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
