//
//  SettingsView.swift
//  Rooster App
//
//  Created by Abdullah on 17/02/2024.
//

import SwiftUI


struct SettingsView: View {
    @State private var showNotifications = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    @State private var fontSize: Double = 16.0

    var body: some View {
        Form {
            Section("General") {
                Toggle("Show Notifications", isOn: $showNotifications)
                Picker("Font Size", selection: $fontSize) {
                    Text("Small").tag(14.0)
                    Text("Medium").tag(16.0)
                    Text("Large").tag(18.0)
                }
            }

            Section("Sounds & Vibrations") {
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Vibration", isOn: $vibrationEnabled)
            }

            // More sections and settings...

            Button("Save") {
                // Handle saving settings
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
