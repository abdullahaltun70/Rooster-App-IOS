// ContentView.swift
import SwiftUI


struct ContentView: View {
    var body: some View {
        
        TabView {
            GetAllShiftsView()
                .tabItem{
                    Label("My Shifts", systemImage: "house")
                }
            ShiftsView()
                .tabItem{
                    Label("All Shifts", systemImage: "calendar")
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
