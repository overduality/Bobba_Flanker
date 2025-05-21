//
//  BookingView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//  Adjusted by Rineo on 07/05/25.
import SwiftUI

struct BookingView: View {
    @State private var selectedDate: Date = Date()
    @State private var navigationPath = NavigationPath()
    @State private var isLoading: Bool = false
    @State private var bookingController = BookingController()
    @State private var bookings: [Booking] = []
    let screenWidth = UIScreen.main.bounds.width
    @State private var selectedFilter: FilterOption = .collabSpace
    @State private var capacitySortOrder: CapacitySortOrder = .ascending // Default
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Header()
                        .padding(.bottom, -64)
                    DateManager(selectedDate: $selectedDate)
                        .padding(.horizontal, 28)
                    FilterBar(selectedFilter: $selectedFilter, capacitySortOrder: $capacitySortOrder)
                    
    
                    VStack(alignment: .leading, spacing: 40) {
                        
                        if isLoading {
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 40),
                                    GridItem(.flexible(), spacing: 40)
                                ], spacing: 40) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        BookingViewSkeletonCard()
                                    }
                                }
                                .padding()
                            }
                        

                        } else {
                            CollabspaceCardManager(
                                navigationPath: $navigationPath,
                                selectedDate: $selectedDate,
                                geometrySize: geometry.size.width, selectedFilter: selectedFilter,
                                capacitySortOrder: capacitySortOrder
                            )
                        }
                    }
                    .safeAreaPadding()
                    .padding(.horizontal, 16)
                    
                }
                
                .navigationDestination(for: BookingFormContext.self) { context in
                    BookingFormView(navigationPath: $navigationPath, bookingDate: context.date, timeslot: context.timeslot, collabSpace: context.collabSpace)
                }
                .onChange(of: selectedDate) { oldValue, newValue in
                    isLoading = true
                    bookings = []

                    let currentSelectedDate = newValue

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if currentSelectedDate == selectedDate {
                            bookings = bookingController.getBookingsByDate(newValue)
                            isLoading = false
                        }
                    }
                }.toolbar(.hidden, for: .tabBar)


            }
        }
    
    }
}




    
private struct BookingViewSkeletonCard: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 296, height: 220, alignment: .leading)
                    .clipped()
                    .clipShape(TopLeftRoundedShape())
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 192, height: 24)
                    .padding(.leading, 16)
                HStack{
                    VStack(alignment: .leading){
                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                            .frame(width: 51, height: 16)
                        HStack{
                            VStack{
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 27, height: 26)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 27, height: 26)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 27, height: 26)
                            }
                            VStack(spacing:20){
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 100, height: 14)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 100, height: 14)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 100, height: 14)
                            }
                        }
                    }   .padding(.leading, 16)
                        .padding(.bottom, 16)

                
                    VStack{
                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                            .frame(width: 51, height: 16)
                        HStack{
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 27, height: 26)
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 34, height: 14)}
                        
                    }.padding(.leading, 40)
                        .padding(.bottom,68)
                }
                }
                VStack(alignment: .center, spacing: 16) {
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 160, height: 24)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 152, height: 40)
                    
                    
                }                    .padding(.horizontal, 32)

                
                
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .redacted(reason: .placeholder)
        }
        
        
    }



#Preview {
    BookingViewSkeletonCard()
}
