#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChiakiConsoleFoundBlock)(NSDictionary *consoleInfo);
typedef void (^ChiakiErrorBlock)(NSString *message);
typedef void (^ChiakiPairedBlock)(void);
typedef void (^ChiakiVideoFrameBlock)(CVPixelBufferRef pixelBuffer, CMTime pts);
typedef void (^ChiakiAudioBlock)(NSData *opusPacket, CMTime pts);

@interface ChiakiDiscovery : NSObject
@property (nonatomic, copy, nullable) ChiakiConsoleFoundBlock onConsoleFound;
@property (nonatomic, copy, nullable) ChiakiErrorBlock onError;
- (void)start;
- (void)stop;
@end

@interface ChiakiSession : NSObject
@property (nonatomic, readonly) NSString *host;
@property (nonatomic, readonly) uint16_t port;
@property (nonatomic, copy, nullable) ChiakiPairedBlock onPaired;
@property (nonatomic, copy, nullable) ChiakiErrorBlock onError;
@property (nonatomic, copy, nullable) ChiakiVideoFrameBlock onVideoFrame;
@property (nonatomic, copy, nullable) ChiakiAudioBlock onAudioPacket;

- (instancetype)initWithHost:(NSString *)host port:(uint16_t)port;
- (void)startPairingWithPin:(NSString *)pin;
- (void)startStreaming;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
