package m3u8download;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;

import jaygoo.library.m3u8downloader.bean.M3U8Task;

public class MyM3u8 {


    /**
     * url : url
     * state : state
     * speed : speed
     * progress : progress
     * m3u8FilePath : m3u8FilePath
     */

    @SerializedName("url")
    public String url;
    @SerializedName("state")
    public String state;
    @SerializedName("speed")
    public String speed;
    @SerializedName("progress")
    public String progress;
    @SerializedName("m3u8FilePath")
    public String m3u8FilePath;

    //下载的时候才有的数据
    @SerializedName("itemFileSize")
    public String itemFileSize;
    @SerializedName("totalTs")
    public String totalTs;
    @SerializedName("curTs")
    public String curTs;

    public static MyM3u8 build(M3U8Task m3U8Task) {
        MyM3u8 myM3u8 = new MyM3u8();
        myM3u8.url = m3U8Task.getUrl();
        myM3u8.state = "" + m3U8Task.getState();
        myM3u8.speed = "" + m3U8Task.getSpeed();
        myM3u8.progress = "" + m3U8Task.getProgress();
        myM3u8.m3u8FilePath = m3U8Task.getM3U8().getM3u8FilePath();
        return myM3u8;
    }

    public static String buildGson(M3U8Task m3U8Task) {
        return new Gson().toJson(build(m3U8Task));
    }
}
