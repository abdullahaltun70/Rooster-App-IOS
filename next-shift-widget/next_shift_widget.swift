//import WidgetKit
//import SwiftUI
//
//public struct Shift: Codable, Hashable, Identifiable {
//    public let id: UUID
//    public let name: String
//    public let workday: String
//    public let start_time: String
//    public let end_time: String
//    
//    public init(id: UUID = UUID(), name: String, workday: String, start_time: String, end_time: String) {
//        self.id = id
//        self.name = name
//        self.workday = workday
//        self.start_time = start_time
//        self.end_time = end_time
//    }
//}
//
//public class ShiftsViewModel: ObservableObject {
//    public init() {}
//    @Published var shifts: [Shift] = []
//    @Published var shiftsCurrentWeek: [String: [Shift]] = [:]
//    @Published var isLoading = false
//    
//    func getShifts() {
//        isLoading = true
//        
//        guard let url = URL(string: "https://api.aaltun.nl/get-shifts") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let data = data else { return }
//            
//            do {
//                let decodedShifts = try JSONDecoder().decode([Shift].self, from: data)
//                DispatchQueue.main.async {
//                    self.shifts = decodedShifts
//                    self.isLoading = false
//                }
//            } catch {
//                print("Error decoding data: \(error)")
//            }
//        }.resume()
//    }
//    
//    func getShiftsByEmployee(employeeName: String, completion: @escaping (Result<[Shift], Error>) -> Void) {
//        guard let url = URL(string: "https://api.aaltun.nl/get-shifts-by-employee/\(employeeName)") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                let error = NSError(domain: "DataError", code: 0, userInfo: nil)
//                completion(.failure(error))
//                return
//            }
//            
//            do {
//                let shifts = try JSONDecoder().decode([Shift].self, from: data)
//                completion(.success(shifts))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    
//    public func getShiftsCurrentWeek(for employeeName: String) { // Voeg parameter 'for employeeName' toe
//        DispatchQueue.main.async {
//            self.isLoading = true
//        }
//        
//        guard let url = URL(string: "https://api.aaltun.nl/get-shifts-current-week/\(employeeName)") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let data = data else { return }
//            
//            do {
//                self.shiftsCurrentWeek = try JSONDecoder().decode([String: [Shift]].self, from: data)
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                }
//            } catch {
//                print("Error decoding data: \(error)")
//            }
//        }.resume()
//    }
//}
//
//public struct Provider: TimelineProvider {
//    @AppStorage("selectedEmployee") private var selectedEmployee: String = "Abdullah Altun"
//    
//    public func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), nextShifts: [])
//    }
//    
//    public func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), nextShifts: [])
//        completion(entry)
//    }
//    
//    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        // Implement the logic to fetch the next shifts here
//        let nextShifts = getNextShifts()
//        
//        // Generate a timeline with the next shifts
//        let timeline = Timeline(entries: [SimpleEntry(date: Date(), nextShifts: nextShifts)], policy: .atEnd)
//        completion(timeline)
//    }
//    
//    // Function to fetch the next shifts
//    // Function to fetch the next shifts
//    func getNextShifts() -> [Shift] {
//        let viewModel = ShiftsViewModel() // Create an instance of ShiftsViewModel
//        viewModel.getShiftsCurrentWeek(for: selectedEmployee) // Call the method to populate shiftsCurrentWeek
//        
//        // Now you can access shiftsCurrentWeek property from the viewModel instance
//        let sortedShifts = viewModel.shiftsCurrentWeek.sorted(by: { $0.key < $1.key })
//        
//        var shiftsArray: [Shift] = []
//        
//        for (_, shifts) in sortedShifts {
//            shiftsArray.append(contentsOf: shifts)
//        }
//        
//        return shiftsArray
//    }
//    
//    public struct SimpleEntry: TimelineEntry {
//        public let date: Date
//        public let nextShifts: [Shift]
//    }
//    
//    struct WidgetBackgroundView: View {
//        var body: some View {
//            Color.clear
//                .background(Color.clear)
//        }
//    }
//    
//    public struct NextShiftWidgetEntryView: View {
//        var entry: Provider.Entry
//        let testStr = UserDefaults(suiteName: "altun.Rooster-App")!.string(forKey: "selectedEmployee")
//        
//        public var body: some View {
//            VStack {
//                ForEach(entry.nextShifts) { shift in
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text(shift.name)
//                            if shift.name == testStr {
//                                Image(systemName: "person.fill")
//                                    .foregroundColor(.blue)
//                            }
//                        }
//                        HStack {
//                            Text(shift.start_time)
//                            Text("-")
//                            Text(shift.end_time)
//                        }
//                    }
//                }
//            }
//            .containerBackground(Color.clear, for: .widget) // Set container background for the widget
//        }
//    }
//    
//}
//
//public struct NextShiftWidget: Widget {
//    public init() {}
//    let kind: String = "next_shift_widget"
//    
//    public var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            NextShiftWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("Next Shift Widget")
//        .description("Displays the next shift.")
//    }
//}
//
//@main
//public struct MainNextShiftWidget: WidgetBundle {
//    public init() {}
//    @WidgetBundleBuilder
//    public var body: some Widget {
//        NextShiftWidget()
//    }
//}
//
//public struct WidgetPreview: PreviewProvider {
//    public static var previews: some View {
//        let employee = UserDefaults(suiteName: "altun.Rooster-App")!.string(forKey: "selectedEmployee")
//        
//        return NextShiftWidgetEntryView(entry: Provider.SimpleEntry(date: Date(), nextShifts: [
//            Shift(id: UUID(), name: employee ?? "default value", workday: "Monday", start_time: "09:00", end_time: "17:00")
//        ]))
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

import WidgetKit
import SwiftUI

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

public struct Shift: Codable, Hashable {
    let name: String
    let workday: String
    let start_time: String
    let end_time: String
}

public class ShiftsViewModel: ObservableObject {
    public init() {}
    @Published var shifts: [Shift] = []
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
}

struct ShiftWidgetEntry: TimelineEntry {
    let date: Date
    let shift: Shift
}

struct ShiftWidgetProvider: TimelineProvider {
    typealias Entry = ShiftWidgetEntry

    let viewModel = ShiftsViewModel()

    func placeholder(in context: Context) -> ShiftWidgetEntry {
        ShiftWidgetEntry(date: Date(), shift: Shift(name: "Loading...", workday: "", start_time: "", end_time: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (ShiftWidgetEntry) -> ()) {
        let entry = ShiftWidgetEntry(date: Date(), shift: Shift(name: "Loading...", workday: "", start_time: "", end_time: ""))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        viewModel.getShifts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let entries: [ShiftWidgetEntry]
            if let shift = self.viewModel.shifts.first {
                entries = [ShiftWidgetEntry(date: Date(), shift: shift)]
            } else {
                entries = [ShiftWidgetEntry(date: Date(), shift: Shift(name: "No shifts found", workday: "", start_time: "", end_time: ""))]
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ShiftWidgetEntryView: View {
    var entry: ShiftWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Next Shift:")
                .font(.headline)
            Text(entry.shift.name)
            Text(entry.shift.workday)
            Text("\(entry.shift.start_time) - \(entry.shift.end_time)")
        }
        .padding()
        .background(Color.clear)
        .containerBackground(Color.clear, for: .widget)
    }
}

@main
struct ShiftWidget: Widget {
    let kind: String = "ShiftWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShiftWidgetProvider()) { entry in
            ShiftWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Shift")
        .description("Displays the next shift for the selected employee.")
        .supportedFamilies([.systemLarge])
    }
}


//struct ShiftWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftWidgetEntry(date: Date(), shift: Shift(name: "upcomingShift", workday: "upcomingShift.workday", start_time: "upcomingShift.start_time", end_time: "upcomingShift.end_time"))
//    }
//}
