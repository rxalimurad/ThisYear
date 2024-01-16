//
//  ProgressWidgetWrapper.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import SwiftUI
struct WaveShape: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    var phase: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let offsetY = (1.0 - amplitude) * height
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: offsetY))
        
        for x in stride(from: 0, through: width, by: 1) {
            let y = amplitude * sin(frequency * CGFloat(x) + phase) + offsetY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct WaveProgressBar: View {
    @Binding var percentage: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.red, lineWidth: 2.0)
                .frame(width: 100, height: 100)
            
            WaveShape(amplitude: CGFloat(percentage / 100), frequency: 2 * .pi / 320 * 0.8, phase: 0)
                .fill(Color.red.opacity(0.5))
                .frame(width: 100, height: 100)
                .animation(.easeInOut(duration: 1.0))
        }
    }
}

struct ProgressWidgetWrapper: View {
    @State private var percentage: Double = 50.0
    
    var body: some View {
        VStack {
            WaveProgressBar(percentage: $percentage)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressWidgetWrapper()
    }
}
