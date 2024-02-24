//
//  ShiftsCurrentWeekView.swift
//  Rooster App
//
//  Created by YourName on 19/02/2024.
//

import SwiftUI

struct CurrentWeekView: View {
    @StateObject var viewModel = ShiftsViewModel()
    @AppStorage("selectedEmployee") private var selectedEmployee = "Abdullah Altun" // Geselecteerde werknemer uit de instellingen

    var body: some View {
        let sortedShifts = viewModel.shiftsCurrentWeek.sorted(by: { $0.key < $1.key })
        
        let list = List(sortedShifts, id: \.key) { date, shifts in
            Section(header: Text(date.formattedHeader()).bold().font(.title2)) {
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
        
        let navigation = NavigationView {
            list
                .onAppear() {
                    viewModel.getShiftsCurrentWeek(for: selectedEmployee)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Added to ensure consistent navigation style
        
        return navigation
    }
}


extension String {
    func formattedHeader() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL") // Set language to Dutch
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "nl_NL") // Set language to Dutch
        dayFormatter.dateFormat = "EEEE"
        let dayString = dayFormatter.string(from: date)
        
        return "\(dayString) - \(self)"
    }
}


struct CurrentWeekView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeekView()
    }
}
