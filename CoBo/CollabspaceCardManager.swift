//
//  CollabspaceCardManager.swift
//  cobo-personal
//
//  Created by Amanda on 26/03/25.
//
import SwiftUI
struct CollabspaceCardManager : View{
    @Binding var selectedDate: Date
    @State var collabSpaces: [CollabSpace] = DataManager.getCollabSpacesData()
    var body: some View{
        ScrollView(.vertical){
            LazyVStack(spacing: 32){
                ForEach(collabSpaces, id: \.self){
                    collabspace in
                    CollabspaceCard(collabSpace:
                            .constant(CollabSpace(name: collabspace.name,
                                                   capacity: collabspace.capacity,
                                                   whiteboardAmount: collabspace.whiteboardAmount,
                                                   tableWhiteboardAmount: collabspace.tableWhiteboardAmount,
                                                   tvAvailable: collabspace.tvAvailable, image: collabspace.image  )), selectedDate: .constant(Date()))
                }
                
                
                
            }.padding(12)
            
        }
    }
}

#Preview {
    CollabspaceCardManager(selectedDate: .constant(Date()))
}
