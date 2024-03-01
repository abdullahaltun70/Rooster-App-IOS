// ContentView.swift
import SwiftUI


public struct ContentView: View {
    
    public var body: some View {
        
            TabView {
                GetAllShiftsView()
                    .tabItem{
                        Label("Mijn Diensten", systemImage: "house")
                    }
                ShiftsView()
                    .tabItem{
                        Label("Alle Diensten", systemImage: "calendar")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                        
                    }
            }
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
