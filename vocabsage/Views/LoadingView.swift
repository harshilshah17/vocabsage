//
//  LoadingView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Mirage-style animated spinner
                ZStack {
                    // Outer circle
                    Circle()
                        .stroke(Color.primary.opacity(0.15), lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    // Rotating bars (similar to Mirage loader)
                    ForEach(0..<12) { index in
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(Color.primary.opacity(opacity))
                            .frame(width: 3, height: 12)
                            .offset(y: -22)
                            .rotationEffect(.degrees(Double(index) * 30))
                            .opacity(opacity)
                    }
                }
                .rotationEffect(.degrees(rotation))
                
                // App name
                Text("VocabSage")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .tracking(0.5)
            }
        }
        .onAppear {
            // Continuous rotation
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            // Pulsing opacity
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                opacity = 0.8
            }
        }
    }
}

#Preview {
    LoadingView()
}

