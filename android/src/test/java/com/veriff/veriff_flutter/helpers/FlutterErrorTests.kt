package com.veriff.veriff_flutter.helpers

import com.google.common.truth.Truth.assertThat
import com.veriff.Result.Error.*
import com.veriff.veriff_flutter.toFlutterError
import org.junit.Test

class FlutterErrorTests {

    @Test
    fun `test that errors are mapped correctly`() {
        assertThat(DEVICE_HAS_NO_NFC.toFlutterError()).isEqualTo("nfcError")
        assertThat(NFC_DISABLED.toFlutterError()).isEqualTo("nfcError")

        assertThat(UNABLE_TO_ACCESS_CAMERA.toFlutterError()).isEqualTo("cameraUnavailable")
        assertThat(UNABLE_TO_START_CAMERA.toFlutterError()).isEqualTo("cameraUnavailable")

        assertThat(MIC_UNAVAILABLE.toFlutterError()).isEqualTo("microphoneUnavailable")
        assertThat(UNABLE_TO_RECORD_AUDIO.toFlutterError()).isEqualTo("microphoneUnavailable")

        assertThat(UNABLE_TO_RECORD_AUDIO.toFlutterError()).isEqualTo("microphoneUnavailable")

        assertThat(UNSUPPORTED_SDK_VERSION.toFlutterError()).isEqualTo("deprecatedSDKVersion")
        assertThat(SESSION_ERROR.toFlutterError()).isEqualTo("sessionError")
        assertThat(NETWORK_ERROR.toFlutterError()).isEqualTo("networkError")
        assertThat(SETUP_ERROR.toFlutterError()).isEqualTo("setupError")
        assertThat(UNKNOWN_ERROR.toFlutterError()).isEqualTo("unknown")
    }
}
