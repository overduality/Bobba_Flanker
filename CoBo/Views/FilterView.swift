//
//  FilterView.swift
//  Project 1 Apple
//
//  Created by Rieno on 07/05/25.
//
import SwiftUI
import SwiftData

struct FilterBar: View {
    @Binding var selectedFilter: FilterOption
    @Binding var capacitySortOrder: CapacitySortOrder
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Button(action: {
                            if option == .capacity {
                                if selectedFilter != option {
                                    selectedFilter = option
                                    capacitySortOrder = .descending
                                } else {
                                    capacitySortOrder = capacitySortOrder == .descending ? .ascending : .descending
                                }
                            } else {
                                selectedFilter = option
                                capacitySortOrder = .none
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: iconName(for: option))
                                    .font(.system(size: 22))
                                    .foregroundColor(selectedFilter == option ? Color("Green-Dark") : .gray)
                                
                                HStack(spacing: 4) {
                                    Text(option.rawValue)
                                        .font(.system(size: 18))
                                        .fontWeight(selectedFilter == option ? .semibold : .regular)
                                        .foregroundColor(selectedFilter == option ? Color("Green-Dark") : .gray)
                                    
                                    if option == .capacity {
                                        Image(systemName: {
                                            if selectedFilter == option {
                                                return capacitySortOrder == .ascending ? "arrow.up" : "arrow.down"
                                            } else {
                                                return "arrow.up.arrow.down"
                                            }
                                        }())
                                        .font(.system(size: 16))
                                        .foregroundColor(selectedFilter == option ? Color("Green-Dark") : .gray) 
                                    }
                                }
                                
                                Rectangle()
                                    .frame(width: 160, height: 2)
                                    .foregroundColor(selectedFilter == option ? Color("Green-Dark") : .clear)
                                    .padding(.top, 2)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 16)
            }
        }
    }

    
    private func iconName(for option: FilterOption) -> String {
        switch option {
        case .collabSpace: return "house"
        case .capacity: return "person"
        case .appleTV: return "tv"
        case .tableWhiteboard: return "pencil.line"
        case .focusArea: return "target"
        case .whiteboardWall: return "pencil.and.outline"
        case .sofa: return "sofa.fill"
        }
    }
}

struct CollabSpaceListView: View {
    @Query private var collabSpaces: [CollabSpace]
    @State private var selectedFilter: FilterOption = .collabSpace
    @State private var capacitySortOrder: CapacitySortOrder = .none
    @State private var navigationPath = NavigationPath()
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
                .padding(.bottom, -80)
            DateManager(selectedDate: $selectedDate)
                .padding(.horizontal, 28)
            FilterBar(selectedFilter: $selectedFilter, capacitySortOrder: $capacitySortOrder)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(filteredAndSortedSpaces, id: \.self) { space in
                        CollabspaceCard(
                            navigationPath: $navigationPath,
                            collabSpace: .constant(space),
                            selectedDate: $selectedDate,
                            geometrySize: UIScreen.main.bounds.width
                        )
                    }
                }
                .padding()
            }
        }
    }
    
    private var filteredAndSortedSpaces: [CollabSpace] {
        var filteredSpaces = collabSpaces
        switch selectedFilter {
        case .collabSpace:
            break
        case .capacity:
            if capacitySortOrder != .none {
                filteredSpaces.sort { space1, space2 in
                    if capacitySortOrder == .ascending {
                        return space1.minCapacity < space2.minCapacity
                    } else {
                        return space1.minCapacity > space2.minCapacity
                    }
                }
            }
        case .appleTV:
            filteredSpaces = filteredSpaces.filter { $0.tvAvailable }
        case .tableWhiteboard:
            filteredSpaces = filteredSpaces.filter { $0.tableWhiteBoard }
        case .focusArea:
            filteredSpaces = filteredSpaces.filter { $0.focusArea }
        case .whiteboardWall:
            filteredSpaces = filteredSpaces.filter { $0.wallWhiteBoard }
        case .sofa:
            filteredSpaces = filteredSpaces.filter { $0.sofa }
        }
        
        return filteredSpaces
    }
}
