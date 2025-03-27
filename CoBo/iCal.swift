import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) var dismiss // buat close modal
    var body: some View {
        VStack(alignment:.center) {
            HStack{
                Button("Close") {
                    // Close the modal
                    dismiss()  // Use SwiftUI's environment dismiss function
                }
                Text("Add this booking to iCal")
                    .padding(.leading, 40)
                    .font(.headline)

                Spacer()
            }.padding()
            Text("""
Scan this QR code to effortlessly add the 
event to your iCal and receive timely reminders.
""")
                .multilineTextAlignment(.center) // Centers text alignment
                .font(.system(size: 13))
            Spacer()

        }
    }
}

#Preview {
    ModalView()
}
