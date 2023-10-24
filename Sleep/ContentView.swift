import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showAddSleepModal = false
    @State  var ipAddress: String? = nil
    @State private var isLoadingIP = true

    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                if isLoadingIP {
                    ProgressView("Loading IP...")
                } else if let ip = ipAddress {
                    Text("Your IP: \(ip)")
                } else {
                    Text("Failed to load IP")
                }

                // Display sleep image
                Image("sleepImage") // Name of the image in Assets.xcassets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200) // Adjust size as needed
                    .clipped()
                    .padding()

                Button(action: {
                    showAddSleepModal = true
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .onAppear(perform: fetchIPAddress)
            .tabItem {
                Image(systemName: "moon.fill")
                Text("Stats")
            }
            .tag(0)

            SleepReportView()
                .tabItem {
                    Image(systemName: "doc.fill")
                    Text("Report")
                }
                .tag(1)
        }
        .sheet(isPresented: $showAddSleepModal) {
            AddSleepDataView(isPresented: $showAddSleepModal)
        }
    }
    
    // Function to fetch IP address
    func fetchIPAddress() {
        let url = URL(string: "https://api.ipify.org?format=json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                self.isLoadingIP = false
                return
            }
            
            if let decodedData = try? JSONDecoder().decode(IPResponse.self, from: data) {
                self.ipAddress = decodedData.ip
                self.isLoadingIP = false
            }
        }.resume()
    }
}

struct IPResponse: Decodable {
    let ip: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
