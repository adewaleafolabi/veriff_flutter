package com.veriff.veriff_flutter.helpers

import com.veriff.Branding
import java.util.Locale

data class FlutterConfiguration(
    val sessionUrl: String,
    val branding: Branding?,
    val languageLocale: Locale?,
    val useCustomIntroScreen: Boolean?
)
