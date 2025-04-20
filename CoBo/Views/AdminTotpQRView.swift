//
//  AdminTotpQRView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 20/04/25.
//

import SwiftUI

struct AdminTotpQRView: View {
    @Environment(Settings.self) private var settings
    
    var image: Image? {
        get {
            let provisioningUri = TotpUtil.getProvisioningUri(for: settings.adminSecretKey, username: "Admin")
            return generateQRCode(for: provisioningUri)
        }
    }
    
    var body: some View {
        VStack {
            Text("Scan this QR Code using your preferred authenticator")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            if let qrImage = image {
                qrImage
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(maxWidth: 250, maxHeight: 250)
                    .background(Color.gray.opacity(0.2))
            } else {
                Text("Failed to generate QR code")
                    .foregroundColor(.red)
            }
        }
    }
    
    func generateQRCode(for value: String) -> Image? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        guard let data = value.data(using: .utf8) else { return nil }
        filter.message = data
        filter.correctionLevel = "M"
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return Image(decorative: cgImage, scale: 1)
            }
        }
        
        return nil
    }
}

#Preview {
    AdminTotpQRView()
}
