//
//  SettingsView.swift
//  Rooster App
//
//  Created by Abdullah on 17/02/2024.
//

// SettingsView.swift

import SwiftUI

public struct SettingsView: View {
    @AppStorage("selectedEmployee") private var selectedEmployee: String = "Abdullah Altun"
    @State private var employeeNames: [String] = []
    @StateObject var viewModel = ShiftsViewModel()

    public var body: some View {
        NavigationView {
            Form {
                Section("Medewerker") {
                    Text(selectedEmployee)
                }

                Section(header: Text("Selecteer Medewerker")) {
                    Picker(selection: $selectedEmployee, label: Text("Medewerker")) {
                        ForEach(employeeNames, id: \.self) { employee in
                            Text(employee)
                                .tag(employee) // Set tag to employee name
                        }
                    }
                }
            }
            .onAppear {
                // Fetch employee names
                viewModel.getEmployeeNames { names in
                    self.employeeNames = names
                }
                UserDefaults.standard.set(selectedEmployee, forKey: "selectedEmployee")
            }
            .navigationTitle("Settings")
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
