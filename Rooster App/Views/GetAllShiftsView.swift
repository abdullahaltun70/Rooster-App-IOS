//
//  GetAllShiftsView.swift
//  Rooster App
//
//  Created by Abdullah on 18/02/2024.
//

import Combine
import SwiftUI

struct Refreshable: ViewModifier {
    @Binding var isRefreshing: Bool
    @Binding var successMessage: String?
    @ObservedObject var viewModel = ShiftsViewModel()
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ActivityIndicator(isAnimating: $isRefreshing, style: .large)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            )
            .overlay(
                Group {
                    if successMessage != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 50))
                            .transition(.opacity) // Voeg een overgang toe voor het vervagen
                            .animation(.easeInOut(duration: 3), value: 0.5) // Voer een animatie uit om te vervagen
                    }
                }
                    .onReceive(Just(successMessage)) { message in
                        // Reset de successMessage na 2 seconden
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            successMessage = nil
                        }
                    }
            )
    }
}

extension View {
    func refreshable(isRefreshing: Binding<Bool>, successMessage: Binding<String?>, viewModel: ShiftsViewModel) -> some View {
        self.modifier(Refreshable(isRefreshing: isRefreshing, successMessage: successMessage, viewModel: viewModel))
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct GetAllShiftsView: View {
    @State private var isRefreshing = false
    @ObservedObject var viewModel = ShiftsViewModel()
    @State private var successMessage: String? = nil
    @AppStorage("selectedEmployee") private var selectedEmployee = "Abdullah Altun"


    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(selectedEmployee) // Display selected employee name
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button(action: {
                        isRefreshing = true
                        viewModel.updateRoosterCurrentWeek { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    isRefreshing = false
                                    successMessage = "Rooster bijgewerkt!"
                                    print("Rooster bijgewerkt!")
                                }
                            case .failure(let error):
                                print("Error updating rooster: \(error)")
                            }
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.title)
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(isRefreshing ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                            .padding()
                    }
                }

                List {
                    ForEach(viewModel.shifts, id: \.self) { shift in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(shift.workday.formattedHeader())
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("\(shift.start_time) - \(shift.end_time)")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .refreshable {
                    isRefreshing = true
                    viewModel.getShiftsByEmployee(employeeName: selectedEmployee) { result in // Call API with selected employee name
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                isRefreshing = false
                                successMessage = "Rooster bijgewerkt!"
                            }
                        case .failure(let error):
                            print("Error updating rooster: \(error)")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    viewModel.getShiftsByEmployee(employeeName: selectedEmployee) { result in // Call API with selected employee name
                        switch result {
                        case .success(let shifts):
                            DispatchQueue.main.async {
                                self.viewModel.shifts = shifts // Update shifts
                            }
                        case .failure(let error):
                            print("Error fetching shifts: \(error)")
                        }
                    }
                }
                .refreshable(isRefreshing: $isRefreshing, successMessage: $successMessage, viewModel: viewModel)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .navigationBarTitle("All Shifts") // Set navigation bar title
            .onChange(of: selectedEmployee) {
                viewModel.getShiftsByEmployee(employeeName: selectedEmployee) { result in // Call API with new selected employee name
                    switch result {
                    case .success(let shifts):
                        DispatchQueue.main.async {
                            self.viewModel.shifts = shifts // Update shifts
                        }
                    case .failure(let error):
                        print("Error fetching shifts: \(error)")
                    }
                }
            }
        }
    }
}

struct GetAllShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        GetAllShiftsView()
    }
}

