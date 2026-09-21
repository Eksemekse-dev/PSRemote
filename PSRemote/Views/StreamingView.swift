import SwiftUI

struct StreamingView: View {
    let session: ChiakiSession
    @State private var showingOverlay = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VideoSurfaceView(session: session)
                .ignoresSafeArea()

            if showingOverlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            session.stop()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .onTapGesture { showingOverlay.toggle() }
        .statusBarHidden()
    }
}
