//
//  ShiftsView.swift
//  Rooster App
//
//  Created by Abdullah on 17/02/2024.
//

import SwiftUI
import Combine


struct ShiftsView: View {
    @State private var selectedTab = 0
    @State private var isRefreshing = false
    @State private var successMessage: String? = nil
    @ObservedObject var viewModel = ShiftsViewModel()
    
    var body: some View {
        VStack {
            // Picker voor tabbladen
            Picker(selection: $selectedTab, label: Text("Selecteer een tab")) {
                Text("Current Week").tag(0)
                Text("Next Week").tag(1)
                Text("Third Week").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // TabView met verschillende weergaven
            TabView(selection: $selectedTab) {
                CurrentWeekView()
                    .tag(0)
                
                SecondWeekView()
                    .tag(1)
                
                ThirdWeekView()
                    .tag(2)
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}


struct ShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsView()
    }
}

