//
//  HeaderView.swift
//  Project 1 Apple
//
//  Created by Rieno on 07/05/25.
//

import SwiftUI

struct Header: View {
    let headerColor: Color = Color(red: 210/255, green: 231/255, blue: 235/255)

    var body: some View {
        ZStack {
            headerColor
                .frame(height: 150)

            Text("Choose the perfect Collab Space for your needs")
                .font(.system(size: 32, weight: .light, design: .monospaced))
                .padding(.horizontal)
                .padding(.top, 64)
        }                .edgesIgnoringSafeArea(.top)

    }
}

#Preview {
    Header()
}

