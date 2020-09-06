package com.echo.m3u8download

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import jaygoo.library.m3u8downloader.M3U8Downloader
import jaygoo.library.m3u8downloader.M3U8DownloaderConfig
import jaygoo.library.m3u8downloader.OnM3U8DownloadListener
import jaygoo.library.m3u8downloader.bean.M3U8Task
import jaygoo.library.m3u8downloader.server.EncryptM3U8Server
import m3u8download.MyM3u8

/** M3u8downloadPlugin */
public class M3u8downloadPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "m3u8download")
        channel.setMethodCallHandler(this)
        EventChannel(flutterPluginBinding.binaryMessenger, "m3u8download_event").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                theEvents = events;

            }

            override fun onCancel(arguments: Any?) {
                theEvents = null
            }
        })
        init(flutterPluginBinding.applicationContext)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {

            val channel = MethodChannel(registrar.messenger(), "m3u8download")
            channel.setMethodCallHandler(M3u8downloadPlugin())
            EventChannel(registrar.messenger(), "m3u8download_event").setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    theEvents = events;
                }

                override fun onCancel(arguments: Any?) {
                    theEvents = null
                }
            })
            init(registrar.context())

        }

        fun buildResult(type: String, data: Any?): Map<String, Any> {
            val map = mutableMapOf<String, Any>()
            map["type"] = type
            data?.run {
                if (data is M3U8Task) {
                    map["data"] = MyM3u8.buildGson(data as M3U8Task)
                } else {
                    map["data"] = this
                }
            }
            return map
        }

        var theEvents: EventChannel.EventSink? = null

        fun init(context: Context) {
            var handler = Handler(Looper.getMainLooper())
            var dirPath = StorageUtils.getCacheDirectory(context).path.toString() + "/m3u8Downloader"
            M3U8DownloaderConfig
                    .build(context.applicationContext)
                    .setSaveDir(dirPath)
                    .setDebugMode(true)
            M3U8Downloader.getInstance().setOnM3U8DownloadListener(object : OnM3U8DownloadListener() {
                override fun onDownloadPause(task: M3U8Task?) {
                    super.onDownloadPause(task)
                    Log.e("M3U8Downloader", "onDownloadPause" + task.toString());
                    handler.post { theEvents?.success(buildResult("onDownloadPause", task)) }

                }

                override fun onDownloadError(task: M3U8Task?, errorMsg: Throwable?) {
                    super.onDownloadError(task, errorMsg)
                    Log.e("M3U8Downloader", "onDownloadError" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadError", task)) }
                }

                override fun onDownloadPrepare(task: M3U8Task?) {
                    super.onDownloadPrepare(task)
                    Log.e("M3U8Downloader", "onDownloadPrepare" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadPrepare", task)) }
                }

                override fun onDownloadItem(task: M3U8Task?, itemFileSize: Long, totalTs: Int, curTs: Int) {
                    super.onDownloadItem(task, itemFileSize, totalTs, curTs)
                    var my = MyM3u8.build(task)
                    my.itemFileSize = itemFileSize.toString()
                    my.totalTs = totalTs.toString()
                    my.curTs = curTs.toString()
                    Log.e("M3U8Downloader", "onDownloadItem" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadItem", Gson().toJson(my))) }
                }

                override fun onDownloadSuccess(task: M3U8Task?) {
                    super.onDownloadSuccess(task)
                    Log.e("M3U8Downloader", "onDownloadSuccess" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadSuccess", task)) }
                }

                override fun onDownloadPending(task: M3U8Task?) {
                    super.onDownloadPending(task)
                    Log.e("M3U8Downloader", "onDownloadPending" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadPending", task)) }
                }

                override fun onDownloadProgress(task: M3U8Task?) {
                    super.onDownloadProgress(task)
                    Log.e("M3U8Downloader", "onDownloadProgress" + task.toString());

                    handler.post { theEvents?.success(buildResult("onDownloadProgress", task)) }
                }
            })

        }
    }

    private val m3u8Server = EncryptM3U8Server();
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.e("onMethodCall", call.method + call.arguments);

        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
            result.success("Aaaandroid ${android.os.Build.VERSION.RELEASE}")
        }
        when (call.method) {
            "cancel" -> {
                M3U8Downloader.getInstance().cancel(call.argument<String>("url"))
            }
            "download" -> {
                M3U8Downloader.getInstance().download(call.argument<String>("url"))
            }
            "pause" -> {
                M3U8Downloader.getInstance().pause(call.argument<String>("url"))
            }
            "checkM3U8IsExist" -> {
                result.success(M3U8Downloader.getInstance().checkM3U8IsExist(call.argument<String>("url")))
            }
            "getM3U8Path" -> {
                android.util.Log.e("M3U8Downloader", M3U8Downloader.getInstance().getM3U8Path(call.argument<String>("url")))
                result.success(M3U8Downloader.getInstance().getM3U8Path(call.argument<String>("url")))
            }
            "isCurrentTask" -> {
                result.success(M3U8Downloader.getInstance().isCurrentTask(call.argument<String>("url")))
            }
            "setEncryptKey" -> {
                M3U8Downloader.getInstance().encryptKey = call.argument<String>("encryptKey")
            }
            "getEncryptKey" -> {
                result.success(M3U8Downloader.getInstance().encryptKey)
            }
            "cancelAndDelete" -> {
                M3U8Downloader.getInstance().cancelAndDelete(call.argument<String>("url"), null)
            }
            "encrypt" -> {
                m3u8Server.encrypt()
            }
            "decrypt" -> {
                m3u8Server.decrypt()
            }
            "finish" -> {
                m3u8Server.finish()
            }
            "execute" -> {
                m3u8Server.execute()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
