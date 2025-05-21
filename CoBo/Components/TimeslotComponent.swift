//
//  TimeslotManager.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//  Adjusted by Rieno on 07/05/25


import SwiftUI

struct TimeslotComponent: View {
    @Binding var navigationPath: NavigationPath
    @Binding var timeslot: Timeslot
    @Binding var isBooked: Bool
    
    var selectedDate: Date
    @Binding var collabSpace: CollabSpace
    
    var geometrySize: CGFloat
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        NavigationLink(value: BookingFormContext(date: selectedDate, timeslot: timeslot, collabSpace: collabSpace)) {
            Text("\(timeslot.name)")
                .font(screenWidth > 400 ? .system(size: 14) : .caption2)
                .fontWeight(.semibold)
                .foregroundColor(isBooked ? Color(red: 148/255, green: 148/255, blue: 148/255) : Color("Green-Dark"))
                .frame(width: 152, height: 40)
                .lineLimit(1)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isBooked ? Color(red: 148/255, green: 148/255, blue: 148/255).opacity(0.75) : Color.clear,
                            lineWidth: isBooked ? 0.5 : 0
                        )
                )
                .shadow(color: isBooked ? .clear : Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
        .disabled(isBooked)
    }
}


struct TimeslotComponent_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var navigationPath = NavigationPath()
        @State var timeslot = DataManager.getTimeslotsData()[0]
        @State var collabSpace = DataManager.getCollabSpacesData()[0]

        var body: some View {
            VStack(spacing: 16) {
                // Available
                TimeslotComponent(
                    navigationPath: $navigationPath,
                    timeslot: $timeslot,
                    isBooked: .constant(false),
                    selectedDate: Date(),
                    collabSpace: $collabSpace,
                    geometrySize: 1210
                )

                // Booked
                TimeslotComponent(
                    navigationPath: $navigationPath,
                    timeslot: $timeslot,
                    isBooked: .constant(true),
                    selectedDate: Date(),
                    collabSpace: $collabSpace,
                    geometrySize: 1210
                )
 
        }
            .padding()
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
