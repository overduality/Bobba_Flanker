//
//  CheckinView.swift
//  CoBo
//
//  Created by Amanda on 27/03/25.
//
import SwiftUI
struct CheckinView: View {
    @State private var otp: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var showAlert = false
    private let numberOfFieldsInOTP = 6
    @Environment(\.dismiss) private var dismissKeyboard
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .top){
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color("Light-Purple").opacity(0.5)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 220)
                .ignoresSafeArea()
                VStack{
                    VStack(alignment: .leading, spacing: 6){
                        Text("🔑").font(.system(size: 34)).fontWeight(.bold)
                        Text("Check-in to Booking").font(.system(size: 21)).fontWeight(.bold)
                        Text("Enter your 6-digit check-in code. You can only check-in once your booking's check-in time has begun.").font(.system(size: 13))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    
                    // OTP Component
                    VStack{
                        OTPFieldView(numberOfFields: numberOfFieldsInOTP, otp: $otp)
                            .onChange(of: otp) { newOtp in
                                if newOtp.count == numberOfFieldsInOTP {
                                    
                                }
                            }
                            .focused($isTextFieldFocused)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 54)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isTextFieldFocused = true
                        }
                    }
                    Button(action: {
                            isTextFieldFocused = false
                            showAlert = true
                            //                        checkInBooking(otp)
                        }) {
                            Text("Check-in")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color("Purple"),
                                            Color("Medium-Purple")
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(24)
                                .padding(.horizontal, 12)
                                .padding(.top, 16)
                        }
                        .padding(.top, 16)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Check-in Successful 🎉"),
                                message: Text("You have successfully checked in."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                }
                .safeAreaPadding()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
        
    }
    
}

#Preview {
    CheckinView()
}
