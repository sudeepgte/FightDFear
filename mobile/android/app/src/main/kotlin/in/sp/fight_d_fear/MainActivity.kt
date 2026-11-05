package `in`.sp.fight_d_fear

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val isEmulator: Boolean
        get() = (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_gphone")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")

    override fun getRenderMode(): RenderMode {
        if (isEmulator) {
            Log.i(TAG, "Flutter render mode = texture (emulator)")
            return RenderMode.texture
        }
        Log.i(TAG, "Flutter render mode = default surface (physical device)")
        return super.getRenderMode()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            if (!flutterEngine.plugins.has(com.razorpay.razorpay_flutter.RazorpayFlutterPlugin::class.java)) {
                flutterEngine.plugins.add(com.razorpay.razorpay_flutter.RazorpayFlutterPlugin())
                Log.i(TAG, "Explicitly registered RazorpayFlutterPlugin")
            }
        } catch (e: Throwable) {
            Log.i(TAG, "RazorpayFlutterPlugin already handled", e)
        }
    }

    companion object {
        private const val TAG = "FightDFearMain"
    }
}

