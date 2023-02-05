package com.veriff.veriff_flutter.helpers

import android.content.Context
import android.graphics.Color.parseColor
import com.veriff.Branding
import com.veriff.veriff_flutter.helpers.image.AssetIconProvider
import com.veriff.veriff_flutter.helpers.image.AssetLookup
import com.veriff.veriff_flutter.helpers.image.NetworkIconProvider
import java.util.*


private const val KEY_SESSION_URL = "sessionUrl"
private const val KEY_LOCALE = "languageLocale"
private const val KEY_BRANDING = "branding"
private const val KEY_CUSTOM_INTRO = "useCustomIntroScreen"

private const val KEY_THEME = "themeColor"
private const val KEY_BACKGROUND = "backgroundColor"
private const val KEY_STATUS_BAR_COLOR = "statusBarColor"
private const val KEY_PRIMARY_TEXT_COLOR = "primaryTextColor"
private const val KEY_SECONDARY_TEXT_COLOR = "secondaryTextColor"
private const val KEY_BUTTON_CORNER_RADIUS = "buttonCornerRadius"
private const val KEY_PRIMARY_BUTTON_BACKGROUND_COLOR = "primaryButtonBackgroundColor"
private const val KEY_LOGO = "logo"
private const val KEY_NOTIFICATION_ICON = "androidNotificationIcon"

fun <V> Map<String, V>.toFlutterConfig(
    context: Context,
    assetLookup: AssetLookup
): FlutterConfiguration? {
    val sessionUrl: String
    if (this.containsKey(KEY_SESSION_URL) && this[KEY_SESSION_URL] is String)
        sessionUrl = this[KEY_SESSION_URL] as String
    else
        return null

    var locale: Locale? = null
    if (this[KEY_LOCALE] != null && this[KEY_LOCALE] is String) {
        locale = Locale(this[KEY_LOCALE] as String)
    }

    var branding: Map<String, Any>? = null
    if (this.containsKey(KEY_BRANDING) && this[KEY_BRANDING] is Map<*, *>) {
        branding = this[KEY_BRANDING] as Map<String, Any>
    }

    var useCustomIntro = false
    if (this[KEY_CUSTOM_INTRO] != null && this[KEY_CUSTOM_INTRO] is Boolean) {
        useCustomIntro = this[KEY_CUSTOM_INTRO] as Boolean
    }


    return FlutterConfiguration(
        sessionUrl = sessionUrl,
        branding = branding?.toVeriffBranding(context, assetLookup),
        languageLocale = locale,
        useCustomIntroScreen = useCustomIntro
    )
}

private fun <V> Map<String, V>.toVeriffBranding(
    context: Context,
    assetLookup: AssetLookup
): Branding? {
    val builder = Branding.Builder()

    if (this.containsKey(KEY_THEME) && this[KEY_THEME].isStringAndNotEmpty()) {
        builder.themeColor(parseColor(this[KEY_THEME] as String))
    }

    if (this.containsKey(KEY_BACKGROUND) && this[KEY_BACKGROUND].isStringAndNotEmpty()) {
        builder.backgroundColor(parseColor(this[KEY_BACKGROUND] as String))
    }

    if (this.containsKey(KEY_STATUS_BAR_COLOR) && this[KEY_STATUS_BAR_COLOR].isStringAndNotEmpty()) {
        builder.statusBarColor(parseColor(this[KEY_STATUS_BAR_COLOR] as String))
    }

    if (this.containsKey(KEY_PRIMARY_TEXT_COLOR) && this[KEY_PRIMARY_TEXT_COLOR].isStringAndNotEmpty()) {
        builder.primaryTextColor(parseColor(this[KEY_PRIMARY_TEXT_COLOR] as String))
    }

    if (this.containsKey(KEY_SECONDARY_TEXT_COLOR) && this[KEY_SECONDARY_TEXT_COLOR].isStringAndNotEmpty()) {
        builder.secondaryTextColor(parseColor(this[KEY_SECONDARY_TEXT_COLOR] as String))
    }

    if (this.containsKey(KEY_BUTTON_CORNER_RADIUS) && this[KEY_BUTTON_CORNER_RADIUS] is Float) {
        builder.buttonCornerRadius(this[KEY_BUTTON_CORNER_RADIUS] as Float)
    }

    if (this.containsKey(KEY_LOGO) && this[KEY_LOGO].isStringAndNotEmpty()) {
        val url = this[KEY_LOGO] as String
        if (isNetworkAsset(url = url)) {
            //this is not used as long as we only support AssetImage from flutter side
            builder.toolbarIconProvider(NetworkIconProvider(url))
        } else {
            builder.toolbarIconProvider(AssetIconProvider(assetLookup.getLookupKeyForAsset(url)))
        }
    }

    if (this.containsKey(KEY_PRIMARY_BUTTON_BACKGROUND_COLOR) &&
        this[KEY_PRIMARY_BUTTON_BACKGROUND_COLOR].isStringAndNotEmpty()
    ) {
        val color = parseColor(this[KEY_PRIMARY_BUTTON_BACKGROUND_COLOR] as String)
        builder.primaryButtonBackgroundColor(color)
    }

    if (this.containsKey(KEY_NOTIFICATION_ICON) && this[KEY_NOTIFICATION_ICON].isStringAndNotEmpty()) {
        val drawableRes = getDrawableId(context, this[KEY_NOTIFICATION_ICON] as String)
        if (drawableRes != 0) {
            builder.notificationIcon(drawableRes)
        }
    }

    return builder.build()
}

private fun Any?.isStringAndNotEmpty(): Boolean {
    return this is String && this.isNotBlank() && this.isNotEmpty()
}

private fun isNetworkAsset(url: String): Boolean {
    return url.startsWith("https://") || url.startsWith("http://") || url.startsWith("file://")
}

private fun getDrawableId(context: Context, name: String): Int {
    return context.resources.getIdentifier(name, "drawable", context.packageName)
}

