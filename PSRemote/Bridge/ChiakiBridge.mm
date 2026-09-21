#import "ChiakiBridge.h"

@implementation ChiakiDiscovery

- (void)start {
    NSLog(@"[ChiakiBridge] Discovery start (stub)");
    // TODO: podlaczyc chiaki-ng discovery
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        if (self.onConsoleFound) {
            self.onConsoleFound(@{
                @"name": @"PS5-Stub",
                @"host": @"192.168.1.100",
                @"port": @(9295),
                @"isPS5": @(YES)
            });
        }
    });
}

- (void)stop {
    NSLog(@"[ChiakiBridge] Discovery stop (stub)");
}

@end

@implementation ChiakiSession

- (instancetype)initWithHost:(NSString *)host port:(uint16_t)port {
    if (self = [super init]) {
        _host = [host copy];
        _port = port;
    }
    return self;
}

- (void)startPairingWithPin:(NSString *)pin {
    NSLog(@"[ChiakiBridge] Pairing stub z %@ PIN=%@", self.host, pin);
    // TODO: podlaczyc chiaki-ng session
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        if (self.onPaired) self.onPaired();
    });
}

- (void)startStreaming {
    NSLog(@"[ChiakiBridge] Start streaming stub");
}

- (void)stop {
    NSLog(@"[ChiakiBridge] Stop stub");
}

@end
