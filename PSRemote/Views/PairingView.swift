import SwiftUI

struct PairingView: View {
    let console: Console
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var pin: String = ""
    @State private var isPairing = false
    @State private var session: ChiakiSession?
    @State private var navigateToStream = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Konsola") {
                    LabeledContent("Nazwa", value: console.name)
                    LabeledContent("Host", value: console.host)
                }

                Section("Kod PIN z konsoli") {
                    TextField("00000000", text: $pin)
                        .keyboardType(.numberPad)
                        .font(.system(.title3, design: .monospaced))
                }

                Section {
                    Button {
                        pair()
                    } label: {
                        if isPairing {
                            ProgressView()
                        } else {
                            Text("Sparuj")
                        }
                    }
                    .disabled(pin.count < 8 || isPairing)
                }
            }
            .navigationTitle("Parowanie")
            .toolbar {
                Button("Anuluj") {
                    session?.stop()
                    dismiss()
                }
            }
            .navigationDestination(isPresented: $navigateToStream) {
                if let s = session {
                    StreamingView(session: s)
                }
            }
        }
    }

    private func pair() {
        isPairing = true
        appState.log("Proba parowania z \(console.host), PIN: \(pin)")
        let s = ChiakiSession(host: console.host, port: console.port)
        s.onPaired = { [weak appState] in
            Task { @MainActor in
                appState?.log("Sparowano pomyslnie.")
                isPairing = false
                s.startStreaming()
                navigateToStream = true
            }
        }
        s.onError = { [weak appState] error in
            Task { @MainActor in
                appState?.log("Blad parowania: \(error)")
                isPairing = false
            }
        }
        s.startPairing(withPin: pin)
        session = s
    }
}
