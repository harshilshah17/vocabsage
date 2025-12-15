//
//  AskTheSageView.swift
//  vocabsage
//
//  Created by Harshil Shah on 12/14/25.
//

import SwiftUI

struct AskTheSageView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "sparkles")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("Ask the Sage")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("This panel will host AI interactions to help you explore and understand your concepts better.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                
                Text("Coming soon...")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview {
    AskTheSageView()
}

