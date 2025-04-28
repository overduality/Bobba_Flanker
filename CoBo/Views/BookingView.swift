//
//  BookingView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//
import SwiftUI
struct BookingView : View{
    @State private var selectedDate: Date = Date()
    @State private var navigationPath = NavigationPath()
    @State private var isLoading: Bool = false
    @State var bookingController = BookingController()
    @State private var bookings : [Booking] = []
    
    // responsive
    let screenWidth = UIScreen.main.bounds.width
    
    var body:some View{
        NavigationStack(path: $navigationPath) {
            GeometryReader
            { geometry in
                VStack(spacing: 0){
                    ZStack(alignment: .top) {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color.yellow.opacity(0.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: screenWidth > 400 ? geometry.size.width * 0.55
                               : geometry.size.width * 0.60)
                        .cornerRadius(30, antialiased: true)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .ignoresSafeArea()
                        VStack(alignment: .leading, spacing: geometry.size.height*0.01) {
                            Text("🔖").font(.system(.largeTitle)).fontWeight(.bold)
                            Text("Book Collab Space").font(screenWidth > 400 ? .title2 : .title3).fontWeight(.bold)
                            Text("Find and book the Collab Space that fits your needs and availability!").font(.callout)
                        }
                        .safeAreaPadding()
                        .padding(.horizontal, geometry.size.width*0.05)
                        .padding(.top, geometry.size.height*0.01)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    VStack(alignment: .leading, spacing: geometry.size.height*0.025){
                        VStack(alignment: .leading, spacing: 16){
                            HStack{
                                Image("no-1").resizable(capInsets: EdgeInsets()).frame(width: geometry.size.width*0.045, height: geometry.size.width*0.045)
                                Text("Select date").font(.system(.callout)).fontWeight(.medium)
                            }
                            DateManager(selectedDate: $selectedDate)
                        }
                        VStack(alignment: .leading){
                            HStack{
                                Image("no-2").resizable(capInsets: EdgeInsets()).frame(width: geometry.size.width*0.045, height: geometry.size.width*0.045)
                                Text("Select available timeslots").font(.system(.callout)).fontWeight(.medium)
                            }
                            if isLoading {
                                ScrollView {
                                    VStack(spacing: 16) {
                                        ForEach(0..<3, id: \.self) { _ in
                                            BookingViewSkeletonCard()
                                        }
                                    }
                                    .padding(.vertical)
                                }
                            } else {
                                CollabspaceCardManager(navigationPath: $navigationPath, selectedDate: $selectedDate, geometrySize: geometry.size.width)
                            }
                            
                        }
                    }
                    .safeAreaPadding()
                    .padding(.horizontal, 16)
                    .padding(.top, geometry.size.height*(-0.075))
                    
                }
                .navigationDestination(for: BookingFormContext.self) { context in
                    BookingFormView(navigationPath: $navigationPath, bookingDate: context.date, timeslot: context.timeslot, collabSpace: context.collabSpace)
                }
            }
            
            
        }.onChange(of: selectedDate) { oldValue, newValue in
            isLoading = true
            bookings = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                bookings = bookingController.getBookingsByDate(newValue)
                isLoading = false
                
            }
            
        }
    }
}



private struct BookingViewSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 163, height: 170, alignment: .leading)
                    .clipped()
                    .clipShape(TopLeftRoundedShape())
                    .padding(.leading, -15)
                    .padding(.top, -80)
                VStack(alignment: .leading, spacing: 12) {
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 110, height: 20)
                    HStack(alignment: .top, spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 50, height: 10)

                            HStack(spacing: 6) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 22, height: 10)
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 22, height: 10)
                                    }

                                    HStack {
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 22, height: 10)
                                            .offset(y: -10)

                                        VStack {
                                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                                .frame(width: 22, height: 10)
                                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                                .frame(width: 22, height: 10)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 50, height: 10)

                            HStack(spacing: 6) {
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 22, height: 10)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 22, height: 10)
                            }
                        }
                    }
}
            }

            Divider()
                .offset(y: -8)

            VStack(alignment: .leading, spacing: 12) {
                SkeletonView(RoundedRectangle(cornerRadius: 12))
                    .frame(width: 120, height: 15)
                HStack {
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                }

                HStack {
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                    SkeletonView(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 93, height: 36)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .redacted(reason: .placeholder)
    }
}

    #Preview {
        BookingView()
    }
