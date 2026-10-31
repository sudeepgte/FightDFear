package `in`.sp.fight_d_fear

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

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

    companion object {
        private const val TAG = "FightDFearMain"
    }
}
