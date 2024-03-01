//
//  SecondWeekShiftsView.swift
//  Rooster App
//
//  Created by Abdullah on 18/02/2024.
//

import SwiftUI

public struct SecondWeekView: View {
    @StateObject var viewModel = ShiftsViewModel()
    @AppStorage("selectedEmployee") private var selectedEmployee = "Abdullah Altun" // Geselecteerde werknemer uit de instellingen
    
    public var body: some View {
        let sortedShifts = viewModel.shiftsNextWeek.sorted(by: { $0.key < $1.key })
        
        let list = List(sortedShifts, id: \.key) { date, shifts in
            Section(header: Text(date.formattedHeader()).bold().font(.title2)) {
                if shifts.isEmpty {
                    Text("No shifts available for this day")
                        .foregroundColor(.gray)
                } else {
                    ForEach(shifts.sorted(by: { shift1, shift2 in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        if let startTime1 = formatter.date(from: shift1.start_time),
                           let startTime2 = formatter.date(from: shift2.start_time) {
                            return startTime1 < startTime2
                        }
                        return false
                    }), id: \.self) { shift in
                        VStack(alignment: .leading) {
                            HStack {
                                if shift.name == selectedEmployee {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.blue)
                                }
                                Text("\(shift.name)").font(.headline)
                            }
                            HStack {
                                Text(shift.start_time)
                                Text("-")
                                Text(shift.end_time)
                            }
                        }
                    }
                }
            }
        }
        
        let navigation = NavigationView {
            list
                .onAppear() {
                    viewModel.getShiftsNextWeek(for: selectedEmployee)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        return navigation
    }
}

struct SecondWeekView_Previews: PreviewProvider {
    static var previews: some View {
        SecondWeekView()
    }
}
