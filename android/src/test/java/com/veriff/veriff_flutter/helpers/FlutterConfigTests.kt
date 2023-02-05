package com.veriff.veriff_flutter.helpers

import android.content.Context
import com.google.common.truth.Truth.assertThat
import com.nhaarman.mockitokotlin2.mock
import com.veriff.veriff_flutter.helpers.image.AssetLookup
import org.junit.Test

class FlutterConfigTests {

    private val sessionUrl = "session url"
    private val languageLocale = "en"

    private val context = mock<Context>()
    private val assetLookup = mock<AssetLookup>()

    @Test
    fun `test flutter config conversion with only session url`() {
        val map = mapOf<String, Any>(
            "sessionUrl" to sessionUrl
        )
        val flutterConfig = map.toFlutterConfig(context, assetLookup)

        assertThat(flutterConfig?.sessionUrl).isEqualTo(sessionUrl)
        assertThat(flutterConfig?.branding).isEqualTo(null)
        assertThat(flutterConfig?.languageLocale).isEqualTo(null)
    }

    @Test
    fun `test flutter config conversion without session url`() {
        val map = mapOf(
            "languageLocale" to languageLocale
        )
        val flutterConfig = map.toFlutterConfig(context, assetLookup)

        assertThat(flutterConfig).isEqualTo(null)
    }

    @Test
    fun `test flutter config conversion for languageLocale`() {
        val map = mapOf(
            "sessionUrl" to sessionUrl,
            "languageLocale" to languageLocale
        )
        val flutterConfig = map.toFlutterConfig(context, assetLookup)

        assertThat(flutterConfig?.sessionUrl).isEqualTo(sessionUrl)
        assertThat(flutterConfig?.languageLocale?.language).isEqualTo(languageLocale)
        assertThat(flutterConfig?.branding?.primaryTextColor).isEqualTo(null)
    }

    @Test
    fun `test flutter config conversion for useCustomIntroScreen false`() {
        val map = mapOf(
            "sessionUrl" to sessionUrl,
            "useCustomIntroScreen" to false
        )
        val flutterConfig = map.toFlutterConfig(context, assetLookup)
        assertThat(flutterConfig?.sessionUrl).isEqualTo(sessionUrl)
        assertThat(flutterConfig?.useCustomIntroScreen).isEqualTo(false)
    }

    @Test
    fun `test flutter config conversion for useCustomIntroScreen true`() {
        val map = mapOf(
            "sessionUrl" to sessionUrl,
            "useCustomIntroScreen" to true
        )
        val flutterConfig = map.toFlutterConfig(context, assetLookup)
        assertThat(flutterConfig?.sessionUrl).isEqualTo(sessionUrl)
        assertThat(flutterConfig?.useCustomIntroScreen).isEqualTo(true)
    }

}
