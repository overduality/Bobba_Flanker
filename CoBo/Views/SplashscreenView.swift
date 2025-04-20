//
//  SplashscreenView.swift
//  CoBo
//
//  Created by Amanda on 27/03/25.
//

import SwiftUI
import SwiftData

struct SplashscreenView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var settings: Settings?
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        if isActive {
            IntroductionView()
                .transition(.opacity.animation(.easeIn(duration: 0.5)))
                .environment(settings ?? Settings())
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                Image("splashscreen-key")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .onAppear {
                        loadAppSettings()
                        
                        withAnimation(.easeIn(duration: 1.5)) {
                            opacity = 1.0
                        }
                      

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isActive = true
                        }
                    }
            }
            .environment(settings ?? Settings())
        }
    }
    
    func loadAppSettings() {
        do {
            let descriptor = FetchDescriptor<Settings>()
            let fetchedSettings = try modelContext.fetch(descriptor)
            settings = fetchedSettings.first
        } catch {
            print("Failed to fetch settings: \(error)")
        }
    }
}

#Preview {
    SplashscreenView()
}
