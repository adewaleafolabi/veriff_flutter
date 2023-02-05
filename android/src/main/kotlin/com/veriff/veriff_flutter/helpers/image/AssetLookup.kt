package com.veriff.veriff_flutter.helpers.image

import io.flutter.embedding.engine.loader.FlutterLoader

interface AssetLookup {
    fun getLookupKeyForAsset(assetName: String): String
}

class FlutterAssetLookup(private val flutterLoader: FlutterLoader) : AssetLookup {
    override fun getLookupKeyForAsset(assetName: String): String {
        return flutterLoader.getLookupKeyForAsset(assetName)
    }
}
