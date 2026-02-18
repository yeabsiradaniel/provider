package com.example.mobile

import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.security.MessageDigest

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        logSignature()
    }

    private fun logSignature() {
        try {
            val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            packageInfo.signatures?.let {
                for (signature in it) {
                    val md = MessageDigest.getInstance("SHA")
                    md.update(signature.toByteArray())
                    val sha1 = Base64.encodeToString(md.digest(), Base64.NO_WRAP)
                    Log.e("APP_SIGNATURE", "SHA-1 Signature: $sha1")
                }
            }
        } catch (e: Exception) {
            Log.e("APP_SIGNATURE", "Error getting signature", e)
        }
    }
}

