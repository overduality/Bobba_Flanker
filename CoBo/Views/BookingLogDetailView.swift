//
//  BookingLogDetailsView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import SwiftUI

struct BookingLogDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    var userController = UserController()
    
    var booking: Booking
    
    var formattedDate: String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        
        return "\(weekdayFormatter.string(from: booking.date)), \(dateFormatter.string(from: booking.date))"
    }
    
    @State var meetingName: String = ""
    @State var bookingCoordinator: User?
    @State var bookingPurpose: BookingPurpose? = nil
    @State private var participants: [User] = []
    
    @State var showAlert: Bool = false
    @State var emptyFields: [String] = []
    
    @State var users: [User] = []
    
    init(navigationPath: Binding<NavigationPath>, booking: Booking) {
        self._navigationPath = navigationPath
        print("Init Details")
        print(booking.name)
        print(booking.coordinator?.name)
        self.booking = booking
        self._meetingName = State(initialValue: booking.name ?? "")
        self._bookingCoordinator = State(initialValue: booking.coordinator ?? nil)
        self._bookingPurpose = State(initialValue: booking.purpose ?? nil)
        self._participants = State(initialValue: booking.participants)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Date").font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text(formattedDate).font(.system(size:13))
                }
                .padding(.vertical)
                Divider()
                HStack {
                    Text("Time").font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text(booking.timeslot.name).font(.system(size:13))
                }
                .padding(.vertical)
                Divider()
                HStack {
                    Text("Space").font(.system(size: 14, weight: .medium))
                    Spacer()
                    Text(booking.collabSpace.name).font(.system(size:13))
                }
                .padding(.vertical)
                Divider()
                HStack{
                    Text("Coordinator").font(.system(size: 14, weight: .medium))
                    Text("*").foregroundStyle(Color.red)
                }
                .padding(.top, 25)
                SearchableDropdownComponent(selectedItem: $bookingCoordinator, data: users)
                    .onChange(of: bookingCoordinator) { oldValue, newValue in
                            if let coordinatorName = newValue?.name {
                                meetingName = "\(coordinatorName)'s Meeting"
                            } else {
                                meetingName = ""
                            }
                        }
                HStack{
                    Text("Meeting's Name").font(.system(size: 14, weight: .medium))
                    Text("*").foregroundStyle(Color.red)
                }
                .padding(.top, 25)
                
                TextField("Challenge Group Meeting", text: $meetingName)
                    .font(.system(size:13))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack{
                    Text("Purpose").font(.system(size: 14, weight: .medium))
                    Text("*").foregroundStyle(Color.red)
                }
                .padding(.top, 25)
                BookingPurposeDropdownComponent(selectedItem: $bookingPurpose)
                Text("Add Participant(s)").font(.system(size: 14, weight: .medium))
                    .padding(.top, 25)
                Text("By adding participants, you automatically include them as invitees in iCal event, available after booking.")
                    .padding(.top, 4)
                    .padding(.bottom,4)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.gray)
                MultipleSelectionDropdownComponent(selectedData: $participants, allData: users)
                    .padding(.bottom)
                Spacer()
                Button {
                    saveChanges()
                } label: {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .medium))
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
                        .padding(.top, 12)
                }
                Button {
                    cancelBooking()
                } label: {
                    Text("Cancel Booking")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(24)
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                }
            }
            .padding(.horizontal)
        }
        .safeAreaPadding()
        .onAppear {
            userController.setupModelContext(modelContext)
            users = userController.getAllUser()
        }
    }
    
    func saveChanges() {
        print("Save Changes")
    }
    
    func cancelBooking() {
        print("Cancel Booking")
    }
}

#Preview {
    let navigationPath = NavigationPath()
    let booking = DataManager.getBookingData().first
    BookingLogDetailsView(navigationPath: .constant(navigationPath), booking: booking!)
}
