//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <call_log/CallLogPlugin.h>
#import <cloud_firestore/CloudFirestorePlugin.h>
#import <device_id/DeviceIdPlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CallLogPlugin registerWithRegistrar:[registry registrarForPlugin:@"CallLogPlugin"]];
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [DeviceIdPlugin registerWithRegistrar:[registry registrarForPlugin:@"DeviceIdPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
}

@end
