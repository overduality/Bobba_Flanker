//
//  BookingFormView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 27/03/25.
//  Adjusted by Rieno on 07/05/25

import SwiftUI
import SwiftData

struct BookingFormView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    @State private var selectedTimeslot: Timeslot
    
    let bookingDate: Date
    @State var timeslot: Timeslot
    let collabSpace: CollabSpace
    
    var userController = UserController()
    
    @State var meetingName: String = ""
    @State var bookingCoordinator: User?
    @State var bookingPurpose: BookingPurpose? = nil
    @State private var selectedItems: [User] = []
    
    @State private var showAlert: Bool = false
    @State private var emptyFields: [String] = []
    
    @State var users: [User] = []
    @State private var showConflictAlert: Bool = false
    @State private var conflictMessage: String = ""
    @State private var showBookingSuccess = false
    @State private var confirmedBooking: Booking? = nil
    @State private var availableTimeslots: [Timeslot] = []

    init(
        navigationPath: Binding<NavigationPath>,
        bookingDate: Date,
        timeslot: Timeslot,
        collabSpace: CollabSpace
    ) {
        self._navigationPath = navigationPath
        self.bookingDate = bookingDate
        self._timeslot = State(initialValue: timeslot)
        self.collabSpace = collabSpace
        self._selectedTimeslot = State(initialValue: timeslot)
    }
    
    func updateAvailableTimeslots() {
        let bookingController = BookingController()
        bookingController.setupModelContext(modelContext)
        let existingBookings = bookingController.getAllBooking()

        let bookedSlots = existingBookings
            .filter {
                Calendar.current.isDate($0.date, inSameDayAs: bookingDate) &&
                $0.collabSpace.id == collabSpace.id
            }
            .map { $0.timeslot }

        availableTimeslots = DataManager.getTimeslotsData().filter {
            !bookedSlots.contains($0)
        }

        if !availableTimeslots.contains(selectedTimeslot),
           let firstAvailable = availableTimeslots.first {
            selectedTimeslot = firstAvailable
            timeslot = firstAvailable
        }
    }


    
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Text("Booking Form")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.bottom, 12)
                            Spacer()
                        }
                        
                        GroupBoxView {
                            HStack {
                                Text("Date")
                                Spacer()
                                Text(formattedDate)
                            }
                            Divider()
                            
                            HStack {
                                Text("Space")
                                Spacer()
                                Text(collabSpace.name)
                            }
                            Divider()
                            
                            GeometryReader { geo in
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Time")
                                    HStack{
                                        Spacer()
                                        Picker("Time", selection: $selectedTimeslot) {
                                            ForEach(availableTimeslots, id: \.self) { slot in
                                                Text(slot.name).tag(slot)
                                            }
                                        }
                                        .pickerStyle(.segmented)
                                        .frame(width: geo.size.width)
                                        .clipped()
                                        .onChange(of: selectedTimeslot) {
                                            timeslot = selectedTimeslot
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .frame(height: 64)
                            .padding(.bottom, 24)
                            
                            
                        }
                        
                        
                        formField(label: "Coordinator", isRequired: true)
                        SearchableDropdownComponent(selectedItem: $bookingCoordinator, data: users)
                            .onChange(of: bookingCoordinator) { oldValue, newValue in
                                if let coordinator = newValue {
                                    meetingName = "\(coordinator.name)'s Meeting"
                                    
                                    let newBooking = Booking(
                                        name: meetingName,
                                        coordinator: coordinator,
                                        purpose: bookingPurpose ?? .others,
                                        date: bookingDate,
                                        participants: selectedItems,
                                        timeslot: timeslot,
                                        collabSpace: collabSpace,
                                        status: .notCheckedIn,
                                        checkInCode: generateCode()
                                    )
                                    
                                    let bookingController = BookingController()
                                    bookingController.setupModelContext(modelContext)
                                    let existingBookings = bookingController.getAllBooking()
                                    
                                    let isValid = BookingValidator.isBookingValid(newBooking: newBooking, existingBookings: existingBookings)
                                    
                                    if !isValid {
                                        conflictMessage = "You already have a booking that overlaps or is directly next to this timeslot."
                                        showConflictAlert = true
                                        bookingCoordinator = nil
                                        meetingName = ""
                                    }
                                } else {
                                    meetingName = ""
                                }
                            }
                        
                        formField(label: "Meeting's Name", isRequired: true)
                        TextField("Challenge Group Meeting", text: $meetingName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 232/255, green: 232/255, blue: 232/255), lineWidth: 1)
                            )
                        
                        formField(label: "Purpose", isRequired: true)
                        BookingPurposeDropdownComponent(selectedItem: $bookingPurpose)
                        
                        Text("Add Participant(s)")
                            .font(.callout)
                            .padding(.top, 25)
                        Text("By adding participants, you automatically include them as invitees in iCal event.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        MultipleSelectionDropdownComponent(selectedData: $selectedItems, allData: users)
                        
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.7, alignment: .leading)
                }
                
                VStack(alignment: .leading){
                    Spacer()
                    BookingSummaryView(
                        coordinator: $bookingCoordinator,
                        meetingName: $meetingName,
                        purpose: $bookingPurpose,
                        participants: $selectedItems,
                        date: bookingDate,
                        time: timeslot.name,
                        collabSpace: collabSpace.name
                    )
                    Spacer()
                    
                    GeometryReader { proxy in
                        Button(action: book) {
                            Text("Book")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: proxy.size.width * 0.9, height: 48)
                                .background(isFormValid ? Color("Green-Dark") : Color(red: 224/255, green: 224/255, blue: 224/255))
                                .cornerRadius(7)
                        }
                        .disabled(!isFormValid)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(height: 60)
                    
                    Spacer()
                }
                
                .frame(width: geometry.size.width * 0.3, alignment: .top)
                .background(Color.white)
            }
            .background(Color(.systemGray6).ignoresSafeArea())
        }
        .onAppear {
            userController.setupModelContext(modelContext)
            users = userController.getAllUser()
            updateAvailableTimeslots()
        
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Required Fields"), message: Text("Please fill: \(emptyFields.joined(separator: ", "))"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showConflictAlert) {
            Alert(title: Text("Consecutive Booking Detected"), message: Text(conflictMessage), dismissButton: .default(Text("OK")))
        }
        
        .sheet(item: $confirmedBooking, onDismiss: {
            updateAvailableTimeslots()
            navigationPath = NavigationPath()
        }) { booking in
            BookingSuccessView(
                navigationPath: $navigationPath,
                booking: $confirmedBooking
            )
            .presentationDetents([.height(800)])
            .presentationCornerRadius(25)
        }
        .toolbar(.hidden, for: .tabBar)


            
    }
        
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter.string(from: bookingDate)
    }

    var isFormValid: Bool {
        bookingCoordinator != nil && !meetingName.isEmpty && bookingPurpose != nil
    }

    func formField(label: String, isRequired: Bool) -> some View {
        HStack {
            Text(label)
            if isRequired {
                Text("*").foregroundColor(.red)
            }
        }.padding(.top, 25)
    }

    func book() {
        emptyFields.removeAll()

        if bookingCoordinator == nil {
            emptyFields.append("Coordinator")
        }
        if meetingName.isEmpty {
            emptyFields.append("Meeting Name")
        }
        if bookingPurpose == nil {
            emptyFields.append("Purpose")
        }

        if emptyFields.isEmpty {
            let newBooking = Booking(
                name: meetingName,
                coordinator: bookingCoordinator!,
                purpose: bookingPurpose!,
                date: bookingDate,
                participants: selectedItems,
                timeslot: timeslot,
                collabSpace: collabSpace,
                status: .notCheckedIn,
                checkInCode: generateCode()
            )

            modelContext.insert(newBooking)
            confirmedBooking = newBooking

            DispatchQueue.main.async {
                showBookingSuccess = true
            }

        } else {
            showAlert = true
        }
    }

    func generateCode() -> String {
        String(Int.random(in: 100000...999999))
    }
}

struct BookingSummaryView: View {
    @Binding var coordinator: User?
    @Binding var meetingName: String
    @Binding var purpose: BookingPurpose?
    @Binding var participants: [User]

    let date: Date
    let time: String
    let collabSpace: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Booking Summary")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 8)
            Text("Please review your booking before confirming")
                .font(.system(size: 16, weight: .regular))
                .padding(.bottom, 32)
            SummaryRow(icon: "mappin.and.ellipse", text: collabSpace, filled: true)
                .padding(.bottom, 24)
            SummaryRow(icon: "calendar", text: formattedDate, filled: true)
                .padding(.bottom, 24)
            SummaryRow(icon: "clock", text: "\(time) WIB", filled: true)
                .padding(.bottom, 24)
            SummaryRow(icon: "person.fill", text: coordinator?.name ?? "Select Coordinator", filled: coordinator != nil)
                .padding(.bottom, 24)
            SummaryRow(icon: "flag.fill", text: purpose?.rawValue ?? "Select Purpose", filled: purpose != nil)
                .padding(.bottom, 24)
            SummaryRow(
                icon: "person.2.fill",
                text: participants.isEmpty ? "Number of Participants" : "\(participants.count) participant(s)",
                filled: !participants.isEmpty
            )


        }
        .padding()
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct SummaryRow: View {
    let icon: String
    let text: String
    let filled: Bool

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if filled {
                    Image(systemName: icon)
                        .foregroundColor(Color("Green-Dark"))
                        .font(.system(size: 16))
                        .padding(6)
                        .background(.white)
                        .clipShape(Circle())
                } else {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
            }

            Text(text)
                .foregroundColor(filled ? .black : .gray)
                .font(.system(size: 16, weight: .regular))
        }
    }
}
struct GroupBoxView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 232/255, green: 232/255, blue: 232/255), lineWidth: 1)
        )
    }
}
