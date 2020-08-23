/// @author dongjunjie
/// @Email  dongjunjie.mail@qq.com
/// @time 2020/8/23 0023 23:56
/// @ui
/// @Interaction Design
/// @api
/// @describe
/// {
//"url":"url",
//"state":"state",
//"speed":"speed",
//"progress":"progress",
//"m3u8FilePath":"m3u8FilePath"
//}
//@SerializedName("itemFileSize")
//public String itemFileSize;
//@SerializedName("totalTs")
//public String totalTs;
//@SerializedName("curTs")
//public String curTs;
class M3U8Task {
  String url;
  String state;
  String speed;
  String progress;
  String m3u8FilePath;
  String itemFileSize;
  String totalTs;
  String curTs;

  M3U8Task({
    this.url,
    this.state,
    this.speed,
    this.progress,
    this.m3u8FilePath,
    this.itemFileSize,
    this.totalTs,
    this.curTs,
  });

  M3U8Task.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    state = json['state'];
    speed = json['speed'];
    progress = json['progress'];
    m3u8FilePath = json['m3u8FilePath'];
    itemFileSize = json['itemFileSize'];
    totalTs = json['totalTs'];
    curTs = json['curTs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['state'] = this.state;
    data['speed'] = this.speed;
    data['progress'] = this.progress;
    data['m3u8FilePath'] = this.m3u8FilePath;
    data['itemFileSize'] = this.itemFileSize;
    data['totalTs'] = this.totalTs;
    data['curTs'] = this.curTs;
    return data;
  }
}
