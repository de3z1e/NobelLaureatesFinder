//
//  BackgroundWavesView.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import SwiftUI

struct BackgroundWavesView: View {
    
    @State var isAnimating = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let screenBounds = UIScreen.main.bounds
        let yOffset: CGFloat = 100
        
        // Period must be greater than or equal to 1.0
        let period1: CGFloat = 2.0
        let period2: CGFloat = 1.0
        let period3: CGFloat = 1.5
        
        ZStack {
            drawWave(period: period1, amplitude: 100, yOffset: screenBounds.midY + 50 + yOffset)
                .foregroundColor(Color(.lightBlue))
                .offset(x: isAnimating ? -screenBounds.width * period1 : 0)
                .animation(Animation.linear(duration: 6).repeatForever(autoreverses: false))
            drawWave(period: period2, amplitude: 100, yOffset: screenBounds.midY + 0 + yOffset)
                .foregroundColor(Color(.lightBlue))
                .offset(x: isAnimating ? -screenBounds.width * period2 : 0)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            drawWave(period: period3, amplitude: 150, yOffset: screenBounds.midY + 100 + yOffset)
                .foregroundColor(Color(.lightBlue))
                .offset(x: isAnimating ? -screenBounds.width * period3 : 0)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: colorScheme == .dark ? "moon.fill" : "sun.max.fill")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .rotationEffect(.degrees(-1))
                        .foregroundColor(colorScheme == .dark ? .white : .yellow)
                        .scaleEffect(isAnimating ? 1.02 : 1.0, anchor: .center)
                        .rotationEffect(.degrees(isAnimating ? 2: 0.0), anchor: .center)
                        .animation(Animation.linear(duration: 0.4).repeatForever(autoreverses: true))
                }
                Spacer()
            }
            .padding(.top, 100)
            .padding(.trailing, 50)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.isAnimating = true
        }
        .onDisappear {
            self.isAnimating = false
        }
    }
    
    private func drawWave(period: CGFloat, amplitude: CGFloat, yOffset: CGFloat) -> Path {
        Path { path in
            let periodLength = UIScreen.main.bounds.width * period
            path.move(to: CGPoint(x: 0, y: yOffset))
            path.addCurve(
                to: CGPoint(x: periodLength, y: yOffset),
                control1: CGPoint(x: periodLength * 1/3, y: yOffset + amplitude),
                control2: CGPoint(x: periodLength * 2/3, y: yOffset - amplitude)
            )
            path.addCurve(
                to: CGPoint(x: 2 * periodLength, y: yOffset),
                control1: CGPoint(x: periodLength * 4/3, y: yOffset + amplitude),
                control2: CGPoint(x: periodLength * 5/3, y: yOffset - amplitude)
            )
            path.addLine(to: CGPoint(x: 2 * periodLength, y: UIScreen.main.bounds.maxY))
            path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.maxY))
        }
    }
}

struct BackgroundWavesView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundWavesView()
            .preferredColorScheme(.light)
    }
}
