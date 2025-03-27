import SwiftUI

struct CodeDisplayView: View {
    @State private var generatedCode: String = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                ForEach(Array(generatedCode), id: \.self) { digit in
                    Text(String(digit))
                        .frame(width: 45, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
            }
            .onAppear {
                generatedCode = generateCode()
            }
        }
        .padding()
    }

    // Function to generate a random 6-digit code
    func generateCode() -> String {
        let randomNumber = Int.random(in: 100000...999999)
        return String(randomNumber)
    }
}

#Preview {
    CodeDisplayView()
}
