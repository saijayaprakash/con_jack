package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import sk.fourq.calllog.CallLogPlugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import com.notrait.deviceid.DeviceIdPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    CallLogPlugin.registerWith(registry.registrarFor("sk.fourq.calllog.CallLogPlugin"));
    CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    DeviceIdPlugin.registerWith(registry.registrarFor("com.notrait.deviceid.DeviceIdPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
