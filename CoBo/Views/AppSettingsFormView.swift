//
//  AppSettingsFormView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 20/04/25.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct AppSettingsFormView: View {
    @Environment(Settings.self) private var settings
    @Environment(\.modelContext) private var modelContext
    
    @Binding private var navigationPath: NavigationPath
    
    @State private var checkInTolerance: Int
    @State private var validBookInAdvance: Int
    @State private var showSuccessMessage = false
    
    init(navigationPath: Binding<NavigationPath>) {
        _checkInTolerance = State(initialValue: 0)
        _validBookInAdvance = State(initialValue: 0)
        _navigationPath = navigationPath
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("Check-in Tolerance")
                        .font(.caption)
                    TextField("Minutes", value: $checkInTolerance, format: .number)
                        .font(.caption)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Book in Advance:")
                        .font(.caption)
                    TextField("Days", value: $validBookInAdvance, format: .number)
                        .font(.caption)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Button {
                saveChanges()
            } label: {
                Text("Save")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color("Purple")
                    )
                    .cornerRadius(24)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                
            }
        }
        .navigationTitle("General Settings")
        .overlay {
            if showSuccessMessage {
                VStack {
                    Text("Settings Updated")
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                        )
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: showSuccessMessage)
                .padding(.top, 10)
            }
        }
        .onAppear {
            checkInTolerance = settings.checkInTolerance
            validBookInAdvance = settings.validBookInAdvance
        }
    }
    
    func saveChanges() {
        settings.checkInTolerance = checkInTolerance
        settings.validBookInAdvance = validBookInAdvance
        
        // Save changes to the model context
        do {
            try modelContext.save()
            
            // Show success message
            showSuccessMessage = true
            
            // Hide success message after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSuccessMessage = false
            }
            
            if navigationPath.count > 0 {
                navigationPath.removeLast()
            }
        } catch {
            print("Error saving settings: \(error)")
        }
    }
}



#Preview {
    @Previewable @State var navPath = NavigationPath()
    AppSettingsFormView(navigationPath: $navPath)
        .environment(Settings())
}
