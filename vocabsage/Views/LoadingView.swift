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
            // Gradient background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Mirage-style animated spinner with glass effect
                ZStack {
                    // Glass background
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
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
                
                // App name with glass effect
                Text("VocabSage")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .tracking(0.5)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
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

