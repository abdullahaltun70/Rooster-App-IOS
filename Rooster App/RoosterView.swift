//
//  RoosterView.swift
//  Rooster App
//
//  Created by Abdullah on 06/02/2024.
//


import SwiftUI

struct RoosterView: View {
    @ObservedObject var viewModel = RoosterViewModel()
    
    var body: some View {
        VStack {
            Button("Get Shifts") {
                viewModel.getShifts()
            }
            .padding()
            
            Button("Update Rooster") {
                viewModel.updateRooster()
            }
            .padding()
            
            List(viewModel.shifts, id: \.name) { shift in
                VStack(alignment: .leading) {
                    Text("Name: \(shift.name)")
                    Text("Workday: \(shift.workday)")
                    Text("Start Time: \(shift.startTime)")
                    Text("End Time: \(shift.endTime)")
                }
            }
        }
    }
}


