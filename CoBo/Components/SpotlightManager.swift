//
//  SpotlightManager.swift
//  CoBo
//
//  Created by Rieno on 16/05/25.
//


import AppIntents

// MARK: -- Your Item
enum CollabType: String, AppEnum {
    case collab2, collab3a, collab3b, collab4a, collab4b, collab5, collab7
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Collab Type"
    }

    static var caseDisplayRepresentations: [CollabType : DisplayRepresentation] {
        [
            .collab2: "Collab 2",
            .collab3a: "Collab 3A",
            .collab3b: "Collab 3B",
            .collab4a: "Collab 4A",
            .collab4b: "Collab 4B",
            .collab5: "Collab 5",
            .collab7: "Collab 7",
        ]
    }
}


// MARK: -- Step 2: Make Your App Intent Accessible in Your Device Here
struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: OrderSpace(),
                    phrases: ["Book Space in \(.applicationName)"]
                    ,shortTitle: "Book Collab Space", systemImageName: "book.fill")
        
        AppShortcut(intent: OrderCollabSpace4(),
                    phrases: ["Book Space in \(.applicationName)"]
                    ,shortTitle: "Book Collab Space", systemImageName: "4.circle.fill")

//        AppShortcut(intent: YourOwnAction(),
//                    phrases: ["My Own Action in \(.applicationName)"]
//                    ,shortTitle: "Own Action", systemImageName: "pencil.fill")
        
    }
    
}


// MARK: -- Step 1: Create Your App Intent Here
struct OrderSpace: AppIntent {
    
    @Parameter(title: "Collab Space") var collabtype: CollabType
    @Parameter(title: "Timeslot") var timeslotNumber: Int
    @Parameter(title: "Coordinator Name") var name: String
    
    static var title: LocalizedStringResource = LocalizedStringResource("Book Space")
    
    func perform() async throws -> some IntentResult {
        print("Selected Coffee Type: \(collabtype)")
        OrderViewModel.shared.addOrder(name: name, collabType: collabtype.rawValue.capitalized, quantity: timeslotNumber)
        print(OrderViewModel.shared.orderList)
        return .result()
    }
}

struct OrderCollabSpace4: AppIntent {
    
    @Parameter(title: "Time Slot") var quantity: Int
    @Parameter(title: "Coordinator Name") var name: String

    static var title: LocalizedStringResource = LocalizedStringResource("Order Collab Space 4")
    
    func perform() async throws -> some IntentResult {
        OrderViewModel.shared.addOrder(name: name, collabType: "Collab Space 4", quantity: quantity)
        return .result()
    }
}

//// MARK: -- Customize Your Own
//struct YourOwnAction: AppIntent {
//    
//    @Parameter(title: "Your Parameter") var parameter1: Int
//    @Parameter(title: "Your Parameter") var parameter2: String
//
//    static var title: LocalizedStringResource = LocalizedStringResource("Your Own")
//    
//    func perform() async throws -> some IntentResult {
//        print("this is your input, parameter1: \(parameter1), parameter2: \(parameter2)")
//        return .result()
//    }
//    
//}
//
