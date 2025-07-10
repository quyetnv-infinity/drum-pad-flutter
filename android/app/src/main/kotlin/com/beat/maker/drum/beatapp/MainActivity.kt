package com.beat.maker.drum.beatapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import com.infinity.ads_tracking_plugin.NavtiveAdLayouts.LayoutAdTextFirst
import com.infinity.ads_tracking_plugin.NavtiveAdLayouts.LayoutAdSmall
import com.infinity.ads_tracking_plugin.NavtiveAdLayouts.LayoutMediumCtaFullBottom

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "layoutAdTextFirst",
            LayoutAdTextFirst(layoutInflater)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "layoutAdSmall",
            LayoutAdSmall(layoutInflater)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "layoutMediumCtaFullBottom",
            LayoutMediumCtaFullBottom(layoutInflater)
        )

        flutterEngine.plugins.add(MediaRecorderPlugin())
        flutterEngine.plugins.add(AudioCapturePlugin())
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "layoutAdTextFirst")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "layoutAdSmall")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "layoutMediumCtaFullBottom")
    }
}
