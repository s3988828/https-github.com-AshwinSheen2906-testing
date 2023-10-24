//
//  AddSleepDataView.swift
//  SleepTracker
//
//  Created by apple on 24/10/23.
//
import SwiftUI
import Foundation

struct AddSleepDataView: View {
    @Binding var isPresented: Bool
    @State private var date = Date()
    @State private var sleepTime = Date()
    @State private var wakeTime = Date()

    var body: some View {
        VStack(spacing: 20) {
            DatePicker("Date", selection: $date, displayedComponents: .date)
            DatePicker("Time of sleep", selection: $sleepTime, displayedComponents: .hourAndMinute)
            DatePicker("Wake up time", selection: $wakeTime, displayedComponents: .hourAndMinute)
            
            HStack {
                Button("Reset") {
                    // Reset action
                    date = Date()
                    sleepTime = Date()
                    wakeTime = Date()
                }
                .padding()
                
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                
                Button("Save") {
                    saveData()
                    isPresented = false
                }
                .padding()
            }
        }.padding()
    }

    func saveData() {
        let newEntry = SleepData(date: date, sleepTime: sleepTime, wakeTime: wakeTime)

        // Fetch data from file and update
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = urls[0].appendingPathComponent("user_report.json")
        
        do {
            var currentData: [SleepData] = []

            // Fetch existing data if any
            if let savedData = try? Data(contentsOf: filename) {
                currentData = try JSONDecoder().decode([SleepData].self, from: savedData)
            }

            // Append new entry
            currentData.append(newEntry)
            
            // Save updated data to file
            let encoder = JSONEncoder()
            let data = try encoder.encode(currentData)
            try data.write(to: filename)
        } catch {
            print("Error saving sleep data: \(error)")
        }
    }
}
