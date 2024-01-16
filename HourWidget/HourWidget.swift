//
//  HourWidget.swift
//  HourWidget
//
//  Created by Ali Murad on 16/01/2024.
//

import WidgetKit
import SwiftUI
import Combine

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let hpercentage = currentHourPercentageWithSeconds()
        let wpercentage = currentWeekPercentageWithSeconds()
        let mpercentage = currentMonthPercentageWithSeconds()
        let ypercentage = currentYearPercentageWithSeconds()

        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), hpercentage: hpercentage, wpercentage: wpercentage, mpercentage: mpercentage, ypercentage: ypercentage)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let hpercentage = currentHourPercentageWithSeconds()
        let wpercentage = currentWeekPercentageWithSeconds()
        let mpercentage = currentMonthPercentageWithSeconds()
        let ypercentage = currentYearPercentageWithSeconds()

        return SimpleEntry(date: Date(), configuration: configuration, hpercentage: hpercentage, wpercentage: wpercentage, mpercentage: mpercentage, ypercentage: ypercentage)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 3600 {
            if hourOffset % 30 != 0 {
                continue
            }
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let hpercentage = currentHourPercentageWithSeconds(entryDate)
            let wpercentage = currentWeekPercentageWithSeconds(entryDate)
            let mpercentage = currentMonthPercentageWithSeconds(entryDate)
            let ypercentage = currentYearPercentageWithSeconds(entryDate)

            let entry = SimpleEntry(date: entryDate, configuration: configuration, hpercentage: hpercentage, wpercentage: wpercentage, mpercentage: mpercentage, ypercentage: ypercentage)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
   
    let date: Date
    
    let configuration: ConfigurationAppIntent
    let hpercentage: Double
    let wpercentage: Double
    let mpercentage: Double
    let ypercentage: Double
}







struct HourWidgetEntryView : View {
    var entry: Provider.Entry
//    @State var hpercentage = 10.0
//    @State var wpercentage = 10.0
//    @State var mpercentage = 10.0
//    @State var ypercentage = 10.0
    var body: some View {
        GeometryReader { geometry in
            let widgetSize = min(geometry.size.width, geometry.size.height)
            
            switch widgetSize {
    
            case 0..<200:
                MediumWidgetView(hpercentage: entry.hpercentage, wpercentage: entry.wpercentage, mpercentage: entry.mpercentage, ypercentage: entry.ypercentage, entry: entry)
            default:
                LargeWidgetView(hpercentage: entry.hpercentage, wpercentage: entry.wpercentage, mpercentage: entry.mpercentage, ypercentage: entry.ypercentage, entry: entry)
            }
        }
    }
}
  


struct SmallWidgetView: View {
    var percentage: Double
    
    var body: some View {
        VStack {
            ProgressView(value: percentage / 100,
                         label: { Text("This Hour (\(getCurrentHourRange()))") },
                         currentValueLabel: { Text("\(String(format: "%.2f", percentage)) %") })
        }
        .widgetURL(URL(string: "your-deep-link-url"))
    }
}

struct MediumWidgetView: View {
    var hpercentage: Double
    var wpercentage: Double
    var mpercentage: Double
    var ypercentage: Double
    var entry: SimpleEntry


    var body: some View {
        VStack {
            Text("This year progress").bold()
            Text("Last updated at \(entry.date.toLongString2())").fontWeight(.thin).font(.system(size: 14))
            Spacer(minLength: 5)
                HStack {
                    Text("This hour (\(getCurrentHourRange()))").font(.system(size: 18))
                    Spacer()
                    Text("\(String(format: "%.2f", hpercentage)) %").font(.system(size: 18))
                }
                HStack {
                    Text("This week (\(getCurrentWeekNumber()))").font(.system(size: 18))
                    Spacer()
                    Text("\(String(format: "%.2f", wpercentage)) %").font(.system(size: 18))
                }
                HStack {
                    Text("This month (\(getCurrentMonthFull()))").font(.system(size: 18))
                    Spacer()
                    Text("\(String(format: "%.2f", mpercentage)) %").font(.system(size: 18))
                }
                HStack {
                    Text("This year (\(getCurrentYear()))").font(.system(size: 18))
                    Spacer()
                    Text("\(String(format: "%.2f", ypercentage)) %").font(.system(size: 18))
                }
            
            
        }
        .widgetURL(URL(string: "your-deep-link-url"))
    }
}

struct LargeWidgetView: View {
    var hpercentage: Double
    var wpercentage: Double
    var mpercentage: Double
    var ypercentage: Double
    var entry: SimpleEntry
    
    var body: some View {
        VStack {
            Text("This year progress").bold()
            Text("Last updated at \(entry.date.toLongString())").fontWeight(.thin).font(.system(size: 14)).multilineTextAlignment(.center)
            Spacer(minLength: 5)
           
              ProgressView(value: hpercentage / 100,
                                     label: { Text("This hour (\(getCurrentHourRange()))") },
                                     currentValueLabel: { Text("\(String(format: "%.2f", hpercentage)) %") })
            ProgressView(value: wpercentage / 100,
                         label: { Text("This week (\(getCurrentWeekNumber()))") },
                         currentValueLabel: { Text("\(String(format: "%.2f", wpercentage)) %") })
            
            ProgressView(value: mpercentage / 100,
                         label: { Text("This month (\(getCurrentMonthFull()))") },
                         currentValueLabel: { Text("\(String(format: "%.2f", mpercentage)) %") })
         
            ProgressView(value: ypercentage / 100,
                         label: { Text("This year (\(getCurrentYear()))") },
                         currentValueLabel: { Text("\(String(format: "%.2f", ypercentage)) %") })
        }
        .widgetURL(URL(string: "your-deep-link-url"))
    }
}


struct HourWidget: Widget {
    let kind: String = "HourWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HourWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("Hour Widget")
        .description("Widget to show hourly progress.")
    }
}

//struct HourWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        HourWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: .smiley))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        
//        HourWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: .starEyes))
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//        
//        HourWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: .smiley))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
//    }
//}



extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    HourWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
