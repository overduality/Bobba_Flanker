//
//  AdminBookingLogFilterView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 21/04/25.
//

import SwiftUI
import SwiftData

struct FilterPredicate: Equatable {
    var startDate: Date? = nil
    var endDate: Date? = nil
    var timeslotsPredicate: Set<Timeslot> = []
    var collabSpacePredicate: Set<CollabSpace> = []
    var bookingStatusPredicate: Set<BookingStatus> = []
}

struct AdminBookingLogFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var activePredicates: FilterPredicate
    
    @Query var timeslots: [Timeslot]
    @Query var collabSpaces: [CollabSpace]
    
    // Temporary state for the filter selections
    @State private var tempPredicates: FilterPredicate
    
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var showingStartDatePicker = false
    @State private var showingEndDatePicker = false
    
    init(activePredicates: Binding<FilterPredicate>) {
        self._activePredicates = activePredicates
        // Initialize the temporary state with the current active predicates
        self._tempPredicates = State(initialValue: activePredicates.wrappedValue)
        self._startDate = State(initialValue: activePredicates.wrappedValue.startDate)
        self._endDate = State(initialValue: activePredicates.wrappedValue.endDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                // Date Section
                Section {
                    HStack {
                        Text("Start Date")
                        Spacer()
                        Button(startDate == nil ? "Not Set" : startDate!.formatted(date: .abbreviated, time: .omitted)) {
                            showingStartDatePicker.toggle()
                        }
                        .foregroundColor(startDate == nil ? .gray : .blue)
                    }
                    
                    if showingStartDatePicker {
                        HStack {
                            DatePicker("", selection: Binding(
                                get: { startDate ?? Date() },
                                set: { startDate = $0 }
                            ), displayedComponents: .date)
                            .labelsHidden()
                            
                            Button("Clear") {
                                startDate = nil
                                tempPredicates.startDate = nil
                            }
                            .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        Text("End Date")
                        Spacer()
                        Button(endDate == nil ? "Not Set" : endDate!.formatted(date: .abbreviated, time: .omitted)) {
                            showingEndDatePicker.toggle()
                        }
                        .foregroundColor(endDate == nil ? .gray : .blue)
                    }
                    
                    if showingEndDatePicker {
                        HStack {
                            DatePicker("", selection: Binding(
                                get: { endDate ?? Date() },
                                set: { endDate = $0 }
                            ), displayedComponents: .date)
                            .labelsHidden()
                            
                            Button("Clear") {
                                endDate = nil
                                tempPredicates.endDate = nil
                            }
                            .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("Date")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onChange(of: startDate) { newValue in
                    tempPredicates.startDate = newValue
                }
                .onChange(of: endDate) { newValue in
                    tempPredicates.endDate = newValue
                }
                
                // Timeslot Section
                Section {
                    ForEach(timeslots) { timeslot in
                        Button(action: {
                            toggleSelection(for: timeslot, in: \.timeslotsPredicate)
                        }) {
                            HStack {
                                let isSelected = tempPredicates.timeslotsPredicate.contains(timeslot)
                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isSelected ? .blue : .gray)
                                Text(timeslot.name)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    Text("Timeslot(s)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Collab Space Section
                Section {
                    ForEach(collabSpaces) { collabSpace in
                        Button(action: {
                            toggleSelection(for: collabSpace, in: \.collabSpacePredicate)
                        }) {
                            HStack {
                                let isSelected = tempPredicates.collabSpacePredicate.contains(collabSpace)
                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isSelected ? .blue : .gray)
                                Text(collabSpace.name)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    HStack {
                        Text("Collab Space")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Booking Status Section
                Section {
                    ForEach(BookingStatus.allCases) { bookingStatus in
                        Button(action: {
                            toggleSelection(for: bookingStatus, in: \.bookingStatusPredicate)
                        }) {
                            HStack {
                                let isSelected = tempPredicates.bookingStatusPredicate.contains(bookingStatus)
                                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isSelected ? .blue : .gray)
                                Text(bookingStatus.rawValue)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    HStack{
                        Text("Booking Status")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            // Apply Button
            Button(action: {
                activePredicates = tempPredicates
                dismiss()
            }) {
                Text("Apply")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .padding()
        }
        .safeAreaPadding()
    }
    
    private func toggleSelection<T: Hashable>(for item: T, in keyPath: WritableKeyPath<FilterPredicate, Set<T>>) {
        if tempPredicates[keyPath: keyPath].contains(item) {
            tempPredicates[keyPath: keyPath].remove(item)
        } else {
            tempPredicates[keyPath: keyPath].insert(item)
        }
    }
}

#Preview {
    @Previewable @State var activePredicates = FilterPredicate()
    AdminBookingLogFilterView(activePredicates: $activePredicates)
}
