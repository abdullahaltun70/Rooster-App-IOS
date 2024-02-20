//
//  ThirdWeekShiftsView.swift
//  Rooster App
//
//  Created by Abdullah on 18/02/2024.
//

import SwiftUI

struct ThirdWeekView: View {
    @StateObject var viewModel = ShiftsViewModel()
    
    var body: some View {
        let sortedShifts = viewModel.shiftsThirdWeek.sorted(by: { $0.key < $1.key })
        
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
                            if shift.name == "Abdullah Altun" {
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
                .onAppear {
                    viewModel.getShiftsThirdWeek()
                }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Added to ensure consistent navigation style
        
        return navigation
    }
}

struct ThirdWeekView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdWeekView()
    }
}
