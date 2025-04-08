//
//  IntroductionView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//
import SwiftUI

struct IntroductionView:View{
    @State var navigateToBooking : Bool = false
    var body: some View{
        NavigationStack {
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("Light-Yellow").opacity(0.4),
                            Color.white.opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.top)
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("Light-Purple").opacity(0.75),
                            Color.white.opacity(1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                    .offset(x:-180, y: -600)
                    .blur(radius: 50)
                }
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("Light-Yellow").opacity(0.5),
                        Color.white.opacity(1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .offset(x:180, y: -100)
                .blur(radius: 50)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("Light-Purple").opacity(0.75),
                        Color.white.opacity(1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .offset(x:-220, y: 50)
                .blur(radius: 50)
                
                VStack{
                    Image("introduction-bookcard").resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 150)
                        .padding(.leading, 80)
                    
                    HStack{
                        Image("introduction-collabimg")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220, maxHeight: 220)
                        
                        Image("introduction-timeslots")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                    }
                    
                    VStack(spacing: 6) {
                        Text("Hello pal! 👋🏻 Welcome to")
                            .font(.system(size: 13))
                        Text("COBO — Collab Space Booking")
                            .font(.system(size: 17, weight: .bold))
                        
                        Text("COBO is your go-to solution for reserving Collab Spaces at Apple Developer Academy @ BINUS. It’s time to focus on what truly matters—creating, brainstorming, and meeting with ease.")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 300)
                    }.padding(.top, 32)
                    Button(action: {
                                    navigateToBooking = true // Trigger navigation
                                }) {
                                    Text("Let's Get Started")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 16)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            Color("Purple")
                                        )
                                        .cornerRadius(24)
                                        .padding(.horizontal, 12)
                                        .padding(.top, 24)
                                }
                                .fullScreenCover(isPresented: $navigateToBooking) {
                                    ContentView()
                                }
                    
                
                }.safeAreaPadding().padding(16)
                
            }
        }
    }
}

#Preview {
    IntroductionView()
}
