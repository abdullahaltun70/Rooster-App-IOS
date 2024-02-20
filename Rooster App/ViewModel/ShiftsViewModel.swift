//
//  ShiftsViewModel.swift
//  Rooster App
//
//  Created by Abdullah on 06/02/2024.
//

import Foundation

class ShiftsViewModel: ObservableObject {
    @Published var shifts: [Shift] = []
    @Published var shiftsCurrentWeek: [String: [Shift]] = [:]
    @Published var shiftsNextWeek: [String: [Shift]] = [:]
    @Published var shiftsThirdWeek: [String: [Shift]] = [:]

    @Published var isLoading = false // Voeg een isLoading property toe
    
    func getShifts() {
        isLoading = true

        guard let url = URL(string: "https://api.aaltun.nl/get-shifts") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let decodedShifts = try JSONDecoder().decode([Shift].self, from: data)
                DispatchQueue.main.async {
                    self.shifts = decodedShifts
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

    
    
    func getShiftsCurrentWeek() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: "https://api.aaltun.nl/get-shifts-current-week") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.shiftsCurrentWeek = try JSONDecoder().decode([String: [Shift]].self, from: data)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func getShiftsNextWeek() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: "https://api.aaltun.nl/get-shifts-next-week") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.shiftsNextWeek = try JSONDecoder().decode([String: [Shift]].self, from: data)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    
    }
    
    func getShiftsThirdWeek() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: "https://api.aaltun.nl/get-shifts-third-week") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                self.shiftsThirdWeek = try JSONDecoder().decode([String: [Shift]].self, from: data)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }


    
    func updateRoosterCurrentWeek(completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true // Zet isLoading op true tijdens het bijwerken van het rooster

        guard let url = URL(string: "https://api.aaltun.nl/update-rooster") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error updating rooster: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                print("Unknown error updating rooster")
                completion(.failure(unknownError))
                return
            }

            print("Rooster Current Week updated successfully with status code: \(httpResponse.statusCode)")

            if (200..<300).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async {
                        self.getShiftsCurrentWeek() // Call on main thread
                        completion(.success(()))
                    }
            } else {
                let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
            }
        }.resume()
    }


}
