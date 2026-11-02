package `in`.sp.fight_d_fear

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

/**
 * Use TextureView instead of the default SurfaceView.
 *
 * On some Android emulators (ranchu / virtgpu), Flutter's SurfaceView can
 * leave a black screen even though the Dart widget tree is alive
 * (accessibility nodes present). TextureView + optional software rendering
 * (see AndroidManifest meta-data) restores visible pixels.
 */
class MainActivity : FlutterActivity() {
    override fun getRenderMode(): RenderMode {
        Log.i(TAG, "Flutter render mode = texture")
        return RenderMode.texture
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            GeneratedPluginRegistrant.registerWith(flutterEngine)
            Log.i(TAG, "GeneratedPluginRegistrant registered successfully")
        } catch (e: Throwable) {
            Log.e(TAG, "GeneratedPluginRegistrant registration warning", e)
        }
        try {
            if (!flutterEngine.plugins.has(com.razorpay.razorpay_flutter.RazorpayFlutterPlugin::class.java)) {
                flutterEngine.plugins.add(com.razorpay.razorpay_flutter.RazorpayFlutterPlugin())
                Log.i(TAG, "Explicitly registered RazorpayFlutterPlugin")
            }
        } catch (e: Throwable) {
            Log.e(TAG, "RazorpayFlutterPlugin explicit registration info", e)
        }
    }

    companion object {
        private const val TAG = "FightDFearMain"
    }
}

