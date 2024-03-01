//
//  ShiftsView.swift
//  Rooster App
//
//  Created by Abdullah on 17/02/2024.
//

import SwiftUI
import Combine


public struct ShiftsView: View {
    @State private var selectedTab = 0
    @State private var isRefreshing = false
    @State private var successMessage: String? = nil
    @ObservedObject var viewModel = ShiftsViewModel()
    
    public var body: some View {
        VStack  {
            // Picker voor tabbladen
            Picker(selection: $selectedTab, label: Text("Selecteer een tab")) {
                Text("Huidige Week").tag(0)
                Text("Volgende Week").tag(1)
                Text("Derde Week").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            // show view based on picker selection
            if selectedTab == 0 {
                CurrentWeekView()
            } else if selectedTab == 1 {
                SecondWeekView()
            } else {
                ThirdWeekView()
            }
        }.background(Color(.systemGray6))
    }
}


struct ShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsView()
    }
}

