//
//  CodeDisplayComponent.swift
//  Project 1 Apple
//
//  Created by Rieno on 07/05/25.
//

import SwiftUI

struct CodeDisplayComponent: View {
    @State var code: String

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                ForEach(Array(code), id: \.self) { digit in
                    Text(String(digit))
                        .frame(width: 64, height: 64)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        .font(.system(size:32))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
    func generateCode() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
}

#Preview {
    var code = "XXXXXX"
    CodeDisplayComponent(code: code)
}
