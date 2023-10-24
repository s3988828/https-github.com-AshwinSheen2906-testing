//
//  SleepReportView.swift
//  SleepTracker
//
//  Created by apple on 24/10/23.
//

import SwiftUI
import Foundation

struct SleepReportView: View {
    @State private var sleepDataArray: [SleepData] = []
    @State private var showSuccessMessage = false

    var body: some View {
        VStack {
            List {
                ForEach(sleepDataArray, id: \.date) { sleepData in
                    HStack {
                        Text(sleepData.date, style: .date)
                        Spacer()
                        Text("Duration: \(sleepData.duration / 3600, specifier: "%.1f") HRS")
                    }
                }
            }
            
            Button("Save to JSON") {
                saveToJSON()
            }
            .padding()
            
            if showSuccessMessage {
                Text("Data saved successfully!")
                    .foregroundColor(.green)
            }
        }
        .onAppear(perform: loadFromJSON)
    }
    
    func saveToJSON() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(sleepDataArray) {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filename = urls[0].appendingPathComponent("user_report.json")
            try? data.write(to: filename)
            
            // Display success message
            showSuccessMessage = true
            
            // Auto-hide success message after few seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSuccessMessage = false
            }
        }
    }
    
    func loadFromJSON() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = urls[0].appendingPathComponent("user_report.json")
        
        do {
            let data = try Data(contentsOf: filename)
            sleepDataArray = try JSONDecoder().decode([SleepData].self, from: data)
        } catch {
            print("Error loading data: \(error)")
        }
    }
}
