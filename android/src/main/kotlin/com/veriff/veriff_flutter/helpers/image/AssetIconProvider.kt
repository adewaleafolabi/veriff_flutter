package com.veriff.veriff_flutter.helpers.image

import android.content.Context
import android.graphics.BitmapFactory.decodeStream
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Parcel
import android.os.Parcelable
import androidx.annotation.WorkerThread
import com.veriff.Branding
import java.io.IOException
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicReference


data class AssetIconProvider(
    private val assetKey: String?
) : Branding.DrawableProvider, Parcelable {

    @WorkerThread
    override fun loadImage(context: Context): Drawable {
        if (assetKey != null) {
            val imageResult = AtomicReference<Drawable>(null)
            val countDownLatch = CountDownLatch(1)
            try {
                Thread {
                    val inStream = context.assets.open(assetKey)
                    imageResult.set(BitmapDrawable(context.resources, decodeStream(inStream)))
                    countDownLatch.countDown()
                }.start()
                countDownLatch.await()
                return imageResult.get()
                    ?: throw throw IOException("Unable to load asset - $assetKey")
            } catch (ex: Exception) {
                throw throw IOException("Unable to load asset - $assetKey")
            }
        } else {
            throw throw IOException("Asset key cannot be null")
        }
    }


    //parcelable stuff
    private constructor(parcel: Parcel) : this(
        assetKey = parcel.readString()
    )

    override fun describeContents(): Int {
        return 0
    }

    override fun writeToParcel(dest: Parcel?, flags: Int) {
        dest?.writeString(assetKey)
    }

    companion object {
        @JvmField
        val CREATOR = object : Parcelable.Creator<AssetIconProvider> {
            override fun createFromParcel(parcel: Parcel) = AssetIconProvider(parcel)
            override fun newArray(size: Int) = arrayOfNulls<AssetIconProvider>(size)
        }
    }
}
