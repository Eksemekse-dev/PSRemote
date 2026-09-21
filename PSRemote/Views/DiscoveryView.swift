import SwiftUI

struct DiscoveryView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLog = false

    var body: some View {
        List {
            Section("Znalezione konsole") {
                if appState.discoveredConsoles.isEmpty {
                    Text(appState.isDiscovering ? "Szukam..." : "Brak konsol")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(appState.discoveredConsoles) { console in
                        Button {
                            appState.activeConsole = console
                            appState.stopDiscovery()
                        } label: {
                            HStack {
                                Image(systemName: console.isPS5 ? "gamecontroller.fill" : "gamecontroller")
                                VStack(alignment: .leading) {
                                    Text(console.name).font(.headline)
                                    Text(console.host).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("PS Remote")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.isDiscovering ? appState.stopDiscovery() : appState.startDiscovery()
                } label: {
                    Image(systemName: appState.isDiscovering ? "stop.circle" : "magnifyingglass")
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("Logi") { showLog = true }
            }
        }
        .sheet(isPresented: $showLog) {
            LogView()
        }
        .sheet(item: $appState.activeConsole) { console in
            PairingView(console: console)
        }
    }
}

private struct LogView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(appState.logLines, id: \.self) { line in
                        Text(line).font(.system(.caption, design: .monospaced))
                    }
                }
                .padding()
            }
            .navigationTitle("Logi")
            .toolbar {
                Button("Zamknij") { dismiss() }
            }
        }
    }
}
