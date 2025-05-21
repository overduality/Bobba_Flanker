//
//  CollabspaceCardManager.swift
//  cobo-personal
//
//  Created by Amanda on 26/03/25.
//  Adjusted by Rieno on 07/05/25

import SwiftUI

struct CollabspaceCardManager: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var navigationPath: NavigationPath
    @Binding var selectedDate: Date

    var geometrySize: CGFloat
    var selectedFilter: FilterOption
    var capacitySortOrder: CapacitySortOrder
    var filteredSpaces: [CollabSpace] {
        switch selectedFilter {
        case .collabSpace:
            return collabSpaces
        case .capacity:
            switch capacitySortOrder {
            case .ascending:
                return collabSpaces.sorted { $0.maxCapacity < $1.maxCapacity }
            case .descending:
                return collabSpaces.sorted { $0.maxCapacity > $1.maxCapacity }
            case .none:
                return collabSpaces
            }
        case .appleTV:
            return collabSpaces.filter { $0.tvAvailable }
        case .tableWhiteboard:
            return collabSpaces.filter { $0.tableWhiteBoard }
        case .focusArea:
            return collabSpaces.filter { $0.focusArea }
        case .whiteboardWall:
            return collabSpaces.filter { $0.wallWhiteBoard }
        case .sofa:
            return collabSpaces.filter { $0.sofa }
        }
    }

    var collabSpaceController = CollabSpaceController()
    @State var collabSpaces: [CollabSpace] = []

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]

        let cardWidth = (geometrySize - 16 * 3) / 2

        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 80) {
                ForEach(filteredSpaces, id: \.self) { collabspace in
                    CollabspaceCard(
                        navigationPath: $navigationPath,
                        collabSpace: .constant(collabspace),
                        selectedDate: $selectedDate,
                        geometrySize: cardWidth
                    )
                }
            }
            .padding(.vertical, 12)
        }

        .onAppear {
            collabSpaceController.setupModelContext(self.modelContext)
            collabSpaces = collabSpaceController.getAllCollabSpace()
        }
    }
}
