//import SwiftUI
//
//struct BookingSuccessModal: View {
//    @Binding var isPresented: Bool
//    @Binding var navigationPath: NavigationPath
//    var booking: Booking
//    
//    var checkInTimeRange: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let start = formatter.string(from: booking.startTime)
//        let end = formatter.string(from: booking.endTime)
//        return "\(start) - \(end)"
//    }
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            Spacer(minLength: 20)
//
//            // Checkmark Icon
//            Circle()
//                .fill(Color.green)
//                .frame(width: 80, height: 80)
//                .overlay(
//                    Image(systemName: "checkmark")
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(.white)
//                )
//                .shadow(color: .green, radius: 15)
//            
//            // Success Text
//            Text("Success!")
//                .font(.title)
//                .bold()
//            
//            // Subtext
//            VStack(spacing: 8) {
//                Text("The check-in code is")
//                + Text(" required ").bold()
//                + Text("to check in")
//                
//                CodeDisplayComponent(code: booking.checkInCode ?? "XXXXXX")
//                
//                Text("The check-in window will remain open for ")
//                + Text("30 minutes (\(checkInTimeRange))").bold()
//                + Text(".\nLate check-ins will be marked as no-shows, and the booked space will be reopened.")
//            }
//            .font(.callout)
//            .multilineTextAlignment(.center)
//            .padding(.horizontal)
//            
//            Divider()
//                .padding(.horizontal)
//            
//            // QR Code Section
//            VStack(spacing: 12) {
//                Text("Scan this QR code to automatically create event in your ")
//                + Text("iCal").italic().bold()
//                + Text(" for a timely reminder for you and all participants.")
//                
//                CalendarQRView(booking: booking)
//                    .frame(height: 200)
//            }
//            .font(.footnote)
//            .multilineTextAlignment(.center)
//            .padding(.horizontal)
//            
//            Spacer()
//            
//            // Button
//            Button(action: {
//                navigationPath = NavigationPath()
//                isPresented = false
//            }) {
//                Text("Back to Home Page")
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 50)
//                    .foregroundColor(.white)
//                    .background(Color("Purple"))
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//            }
//            .padding(.bottom, 16)
//        }
//        .padding(.top)
//        .presentationDetents([.large])
//        .presentationCornerRadius(30)
//    }
//}
//#Preview {
//    let navigationPath = NavigationPath()
//    let booking = DataManager.getBookingData().first!
//    BookingSuccessModal(navigationPath: .constant(navigationPath), booking: booking)
//}
