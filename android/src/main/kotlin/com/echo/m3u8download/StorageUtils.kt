package com.echo.m3u8download

import android.content.Context
import android.content.pm.PackageManager
import android.os.Environment
import java.io.File
import java.io.IOException

 /**
 * ================================================
 * 作    者：JayGoo
 * 版    本：1.0
 * 创建日期：16/9/19
 * 描    述:文件操作,文件夹、文件处理、图片选择
 * 类    型:工具类
 * 修订历史：
 * ================================================
 */
/**
 * @author Sergey Tarasevich (nostra13[at]gmail[dot]com)
 * @created : JayGoo
 * @Description: Provides application storage paths
 *
 *
 * Methods get storage path samples:
 *
 *
 * getCacheDirectory: /storage/emulated/0/Android/data/com.example.google_acmer.asimplecachedemo/cache
 * getCacheDirectory true: /storage/emulated/0/Android/data/com.example.google_acmer.asimplecachedemo/cache
 * getCacheDirectory false: /data/user/0/com.example.google_acmer.asimplecachedemo/cache
 * getIndividualCacheDirectory:/storage/emulated/0/Android/data/com.example.google_acmer.asimplecachedemo/cache/uil-images
 * getOwnCacheDirectory:/storage/emulated/0/JayGoo
 */
object StorageUtils {
    private const val EXTERNAL_STORAGE_PERMISSION = "android.permission.WRITE_EXTERNAL_STORAGE"
    private const val INDIVIDUAL_DIR_NAME = "uil-images"

    /**
     * Returns application cache directory. Cache directory will be created on SD card
     * *("/Android/data/[app_package_name]/cache")* if card is mounted and app has appropriate permission. Else -
     * Android defines cache directory on device's file system.
     *
     * @param context Application context
     * @return Cache [directory][File].<br></br>
     * **NOTE:** Can be null in some unpredictable cases (if SD card is unmounted and
     * [Context.getCacheDir()][Context.getCacheDir] returns null).
     */
    fun getCacheDirectory(context: Context): File {
        return getCacheDirectory(context, true)
    }

    /**
     * Returns application cache directory. Cache directory will be created on SD card
     * *("/Android/data/[app_package_name]/cache")* (if card is mounted and app has appropriate permission) or
     * on device's file system depending incoming parameters.
     *
     * @param context        Application context
     * @param preferExternal Whether prefer external location for cache
     * @return Cache [directory][File].<br></br>
     * **NOTE:** Can be null in some unpredictable cases (if SD card is unmounted and
     * [Context.getCacheDir()][Context.getCacheDir] returns null).
     */
    fun getCacheDirectory(context: Context, preferExternal: Boolean): File {
        var appCacheDir: File? = null
        val externalStorageState: String
        externalStorageState = try {
            Environment.getExternalStorageState()
        } catch (e: NullPointerException) { // (sh)it happens (Issue #660)
            ""
        }
        if (preferExternal && Environment.MEDIA_MOUNTED == externalStorageState && hasExternalStoragePermission(context)) {
            appCacheDir = getExternalCacheDir(context)
        }
        if (appCacheDir == null) {
            appCacheDir = context.cacheDir
        }
        if (appCacheDir == null) {
            val cacheDirPath = "/data/data/" + context.packageName + "/cache/"
            appCacheDir = File(cacheDirPath)
        }
        return appCacheDir
    }

    /**
     * Returns individual application cache directory (for only image caching from ImageLoader). Cache directory will be
     * created on SD card *("/Android/data/[app_package_name]/cache/uil-images")* if card is mounted and app has
     * appropriate permission. Else - Android defines cache directory on device's file system.
     *
     * @param context Application context
     * @return Cache [directory][File]
     */
    fun getIndividualCacheDirectory(context: Context): File {
        val cacheDir = getCacheDirectory(context)
        var individualCacheDir = File(cacheDir, INDIVIDUAL_DIR_NAME)
        if (!individualCacheDir.exists()) {
            if (!individualCacheDir.mkdir()) {
                individualCacheDir = cacheDir
            }
        }
        return individualCacheDir
    }

    /**
     * Returns specified application cache directory. Cache directory will be created on SD card by defined path if card
     * is mounted and app has appropriate permission. Else - Android defines cache directory on device's file system.
     *
     * @param context  Application context
     * @param cacheDir Cache directory path (e.g.: "AppCacheDir", "AppDir/cache/images")
     * @return Cache [directory][File]
     */
    fun getOwnCacheDirectory(context: Context, cacheDir: String?): File? {
        var appCacheDir: File? = null
        if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState() && hasExternalStoragePermission(context)) {
            appCacheDir = File(Environment.getExternalStorageDirectory(), cacheDir)
        }
        if (appCacheDir == null || !appCacheDir.exists() && !appCacheDir.mkdirs()) {
            appCacheDir = context.cacheDir
        }
        return appCacheDir
    }

    private fun getExternalCacheDir(context: Context): File? {
        val dataDir = File(File(Environment.getExternalStorageDirectory(), "Android"), "data")
        val appCacheDir = File(File(dataDir, context.packageName), "cache")
        if (!appCacheDir.exists()) {
            if (!appCacheDir.mkdirs()) {
                return null
            }
            try {
                File(appCacheDir, ".nomedia").createNewFile()
            } catch (e: IOException) {
            }
        }
        return appCacheDir
    }

    private fun hasExternalStoragePermission(context: Context): Boolean {
        val perm = context.checkCallingOrSelfPermission(EXTERNAL_STORAGE_PERMISSION)
        return perm == PackageManager.PERMISSION_GRANTED
    }

    fun makeDir(dirPath: String?): Boolean {
        val fileDir = File(dirPath)
        if (!fileDir.exists()) {
            try {
                fileDir.mkdirs()
                return true
            } catch (e: Exception) {
            }
        }
        return false
    }

    fun fileIsExists(filePath: String?): Boolean {
        val f = File(filePath)
        return if (!f.exists()) {
            false
        } else true
    }

    /**
     * 是否有sd卡
     *
     * @return
     */
    fun hasSdcard(): Boolean {
        return if (Environment.getExternalStorageState() ==
                Environment.MEDIA_MOUNTED) {
            true
        } else {
            false
        }
    }
}