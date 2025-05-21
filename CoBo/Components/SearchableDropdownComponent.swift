//
//  SerachableDropdownComponent.swift
//  CoBo
//
//  Created by Evan Lokajaya on 26/03/25.
//  Adjusted by Rieno on 07/05/25

import SwiftUI
import SwiftData


struct SearchableDropdownComponent<T:DropdownProtocol>: View {
    @State private var isExpanded = false
    @State private var dropdownLabel: String
    @State private var searchText = ""
    @Binding private var selectedItem: T?
    
    let lightGrayColor = Color(red: 243/255, green: 243/255, blue: 243/255)
    
    var data: [T]
    
    var filteredData: [T] {
        if searchText.isEmpty {
            return self.data
        } else {
            return self.data.filter { $0.dropdownLabel.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(selectedItem: Binding<T?>, data: [T]) {
        self.data = data
        self._selectedItem = selectedItem
        self._dropdownLabel = State(initialValue: selectedItem.wrappedValue?.dropdownLabel ?? "Select an Option")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(dropdownLabel)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(Color.darkPurple)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 14)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 232/255, green: 232/255, blue: 232/255), lineWidth: 1))
                        }
                        
                
                Spacer()
                    .frame(height: isExpanded ? 300 : 0)
            }
            
            if isExpanded {
                VStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    if filteredData.isEmpty {
                        Text("No results found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(filteredData) { item in
                                    Text(item.dropdownLabel)
                                        .font(.system(size:16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            dropdownLabel = item.dropdownLabel
                                            selectedItem = item
                                            withAnimation {
                                                isExpanded = false
                                            }
                                        }
                                        .background(Color.white)
                                    Divider()
                                }
                            }
        
                            
                        }
                    }
                }
                .frame(maxHeight: 300)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .offset(y: 60)
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .background(
            isExpanded ?
                Color.black.opacity(0.001)
                    .onTapGesture {
                        withAnimation {
                            isExpanded = false
                        }
                    }
                    .ignoresSafeArea()
                : nil
        )
        .onChange(of: selectedItem) { oldValue, newValue in
            dropdownLabel = newValue?.dropdownLabel ?? "Select an Option"
        }
        .onAppear {
            dropdownLabel = selectedItem?.dropdownLabel ?? "Search or Select an Option"
        }
    }
    
}

struct SearchableComponentTestView: View {
    @State var selectedUser: User? = nil
    var users = DataManager.getUsersData()
    
    var body: some View {
        SearchableDropdownComponent(selectedItem: $selectedUser, data: users)
    }
}

#Preview {
    SearchableComponentTestView()
}

