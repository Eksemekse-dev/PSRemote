import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var discoveredConsoles: [Console] = []
    @Published var isDiscovering: Bool = false
    @Published var activeConsole: Console?
    @Published var logLines: [String] = []

    private var discovery: ChiakiDiscovery?

    func startDiscovery() {
        guard !isDiscovering else { return }
        isDiscovering = true
        discoveredConsoles.removeAll()
        log("Uruchamiam discovery...")

        discovery = ChiakiDiscovery()
        discovery?.onConsoleFound = { [weak self] info in
            guard let self else { return }
            Task { @MainActor in
                guard let console = Console(info: info) else { return }
                if !self.discoveredConsoles.contains(where: { $0.host == console.host }) {
                    self.discoveredConsoles.append(console)
                    self.log("Znaleziono: \(console.name) @ \(console.host)")
                }
            }
        }
        discovery?.onError = { [weak self] error in
            Task { @MainActor in
                self?.log("Blad discovery: \(error)")
            }
        }
        discovery?.start()
    }

    func stopDiscovery() {
        discovery?.stop()
        discovery = nil
        isDiscovering = false
        log("Zatrzymano discovery.")
    }

    func log(_ message: String) {
        let ts = ISO8601DateFormatter().string(from: Date())
        logLines.append("[\(ts)] \(message)")
        print("[PSRemote] \(message)")
    }
}
