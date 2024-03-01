import WidgetKit
import SwiftUI

struct NextShiftsProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), shifts: [:])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), shifts: [:])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // Replace "Abdullah Altun" with the desired employee name
        let employeeName = "Abdullah Altun"
        
        let currentDate = Date()
        
        let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let shiftsViewModel = ShiftsViewModel()
        shiftsViewModel.getShiftsCurrentWeek(for: employeeName)
        
        let entry = SimpleEntry(date: entryDate, shifts: shiftsViewModel.shiftsCurrentWeek)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let shifts: [String: [Shift]]
}

struct Next_Shifts_WidgetEntryView : View {
    var entry: NextShiftsProvider.Entry

    var body: some View {
        // You can customize this view to display the first shift of each day
        VStack {
            ForEach(entry.shifts.sorted(by: { $0.key < $1.key }), id: \.key) { day, shifts in
                if let firstShift = shifts.first {
                    Text("\(day): \(firstShift.name) - \(firstShift.start_time) to \(firstShift.end_time)")
                }
            }
        }
    }
}

struct Next_Shifts_Widget: Widget {
    let kind: String = "Next_Shifts_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NextShiftsProvider()) { entry in
            Next_Shifts_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Shifts")
        .description("Displays the next shift for each day of the week.")
    }
}

struct Next_Shifts_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Next_Shifts_WidgetEntryView(entry: SimpleEntry(date: Date(), shifts: [:]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
