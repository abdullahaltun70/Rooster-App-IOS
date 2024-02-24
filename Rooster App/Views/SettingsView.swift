//
//  SettingsView.swift
//  Rooster App
//
//  Created by Abdullah on 17/02/2024.
//

// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedEmployee") private var defaultEmployee: String = "Abdullah Altun"
    @State private var employeeNames: [String] = []
    @StateObject var viewModel = ShiftsViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    Text("Display Name: \(defaultEmployee)")
                    TextField("Enter your name", text: $defaultEmployee)
                }

                Section(header: Text("Select Employee")) {
                    Picker(selection: $defaultEmployee, label: Text("Employee")) {
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
