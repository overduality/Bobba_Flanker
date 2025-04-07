//
//  BookingSuccessView.swift
//  Project 1 Apple
//
//  Created by Rieno on 25/03/25.
//

import SwiftUI

struct BookingSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath

    @State private var shadowRadius: CGFloat = 5
    @State private var isPresented = false
    @State var booking: Booking

    var formattedBookingDate: String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"

        return "\(weekdayFormatter.string(from: booking.date)), \(dateFormatter.string(from: booking.date))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ZStack {
                        circleShape()
                            .fill(Color(red: 33 / 255, green: 216 / 255, blue: 79 / 255))
                            .frame(width: 80, height: 80)
                            .shadow(color: .green, radius: shadowRadius)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    shadowRadius = 15
                                }
                            }

                        checkmarkShape()
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .frame(width: 65, height: 65)
                    }

                    Spacer()

                    // Decorative background circles
                    ZStack {
                        circleBGShape()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 255 / 255, green: 233 / 255, blue: 130 / 255), Color.white]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 165, height: 165)
                            .offset(x: 30, y: -140)
                            .opacity(0.4)

                        circleBGShape2()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 238 / 255, green: 183 / 255, blue: 255 / 255), Color.white]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 191.28, height: 191.28)
                            .offset(x: 115, y: -60)
                            .opacity(0.4)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Group {
                    Text("Your booking has been placed!")
                        .bold()
                        .font(.system(size: 17))

                    Text("Now save this code")
                        .bold()
                        .padding(.bottom, 10)
                        .font(.system(size: 17))

                    VStack(alignment: .leading) {
                        HStack {
                            Text("This code won't be shown again.")
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 127 / 255, green: 41 / 255, blue: 154 / 255))
                                .italic()
                                .bold()

                            Text("Save this 6-digit code")
                                .font(.system(size: 13))
                                .multilineTextAlignment(.leading)
                        }

                        Text("for future check-in to verify your attendance.")
                            .font(.system(size: 13))
                    }

                    CodeDisplayComponent(code: booking.checkInCode ?? "XXXXXX")

                    HStack {
                        Button(action: {
                            isPresented = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Want to add this to iCal?")
                                    .bold()
                                    .foregroundColor(Color(red: 127 / 255, green: 41 / 255, blue: 154 / 255))
                                    .frame(width: 300, height: 50, alignment: .leading)
                                    .font(.system(size: 13))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        .background(Color(red: 250 / 255, green: 233 / 255, blue: 255 / 255))
                        .frame(width: 370, height: 50)
                        .cornerRadius(10)
                        .opacity(0.6)
                    }
                    .sheet(isPresented: $isPresented) {
                        CalendarQRView()
                            .presentationDetents([.height(400)])
                            .presentationCornerRadius(25)
                    }

                    Text("Booking Summary")
                        .bold()
                        .padding(.top, 15)
                        .font(.system(size: 15))

                    Divider()
                        .background(.black)
                        .padding(.bottom, 20)

                    HStack(alignment: .top) {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.red)

                        Text("Please note that late check-in will cause your booking to be cancelled.")
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 15)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Button(action: {
                        navigationPath = NavigationPath()
                    }) {
                        Text("Back to Home Page")
                            .frame(width: 370, height: 60)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("Purple"), Color("Medium-Purple")]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(24)
                    }
                    .padding(.top, 50)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

#Preview {
    let navigationPath = NavigationPath()
    let booking = DataManager.getBookingData().first!
    BookingSuccessView(navigationPath: .constant(navigationPath), booking: booking)
}
