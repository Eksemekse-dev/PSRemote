import SwiftUI
import AVFoundation

struct VideoSurfaceView: UIViewRepresentable {
    let session: ChiakiSession

    func makeUIView(context: Context) -> VideoSurfaceUIView {
        let view = VideoSurfaceUIView()
        session.onVideoFrame = { pixelBuffer, pts in
            view.enqueue(pixelBuffer: pixelBuffer, pts: pts)
        }
        return view
    }

    func updateUIView(_ uiView: VideoSurfaceUIView, context: Context) {}
}

final class VideoSurfaceUIView: UIView {
    override class var layerClass: AnyClass { AVSampleBufferDisplayLayer.self }

    var displayLayer: AVSampleBufferDisplayLayer {
        layer as! AVSampleBufferDisplayLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        displayLayer.videoGravity = .resizeAspect
        displayLayer.flushAndRemoveImage()
    }

    required init?(coder: NSCoder) { fatalError() }

    func enqueue(pixelBuffer: CVPixelBuffer, pts: CMTime) {
        var format: CMVideoFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescriptionOut: &format
        )
        guard let fmt = format else { return }

        var timing = CMSampleTimingInfo(
            duration: .invalid,
            presentationTimeStamp: pts,
            decodeTimeStamp: .invalid
        )
        var sampleBuffer: CMSampleBuffer?
        CMSampleBufferCreateReadyWithImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescription: fmt,
            sampleTiming: &timing,
            sampleBufferOut: &sampleBuffer
        )
        guard let sb = sampleBuffer else { return }

        DispatchQueue.main.async {
            if self.displayLayer.status == .failed {
                self.displayLayer.flush()
            }
            self.displayLayer.enqueue(sb)
        }
    }
}
