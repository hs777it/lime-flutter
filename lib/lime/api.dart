import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/services.dart';


class LimeApi {
  final Client client = createHttpClient();
  final String server = "https://lime.fablue.org";


  Future <List<Map<String, String>>> getTrends() async {
    String url = "$server/trend?latitude=$latitude&longitude=$longitude";
    url = Uri.encodeFull(url);
    Response response = await client.get(
        url, headers: {"token": token}
    );

    print("[API getTrends] ${response.statusCode}");
    List<Map<String, String>> objects = JSON.decode(response.body);
    return objects.reversed.toList();
  }

  /// Get all posts nearby
  Future <List<Map<String, dynamic>>> getFeed({
    String channel: null,
    int paginationIndex: 0,
    int paginationSize: 50,
    int parentId: null,
    bool onlyImages: false,
    bool onlyFriends: false
  }) async {
    String url = "$server/message?latitude=$latitude"
        "&longitude=$longitude&distance=$distance"
        "&pagination_index=$paginationIndex"
        "&pagination_size=$paginationSize"
        + (channel != null ? "&channel=$channel" : "")
        + (parentId != null ? "&parentId=$parentId" : "")
        + (onlyImages ? "&only_images=$onlyImages" : "")
        + (onlyFriends ? "&only_follows=$onlyFriends" : "");

    print(url);

    url = Uri.encodeFull(url);
    Response response = await client.get(url,
        headers: {
          "token": token
        }
    );

    print("[API getFeed] ${response.statusCode} | pageIndex: $paginationIndex");
    List<Map<String, dynamic>> objects = JSON.decode(response.body);
    return objects.reversed.toList();
  }


  Future<Map> getMessage(int messageId) async{
    String url = "$server/message/$messageId";
    url = Uri.encodeFull(url);
    Response response =  await client.get(url,
    headers: {"token": token});

    print("[API getMessage] ${response.statusCode} | id: $messageId");
    Map post = JSON.decode(response.body);
    return post;
  }

  Future<Response> putVote(int messageId) async {
    String url = "$server/message/$messageId/vote";
    url = Uri.encodeFull(url);
    Response response = await client.put(
        url,
        headers: {"token": token}
    );

    print("[API putVote] ${response.statusCode} | id: $messageId");
    return response;
  }

  Future<Response> deleteVote(int messageId) async {
    String url = "$server/message/$messageId/vote";
    url = Uri.encodeFull(url);
    Response response = await client.delete(url,
        headers: {"token": token}
    );

    print("[API deleteVote] ${response.statusCode} | id: $messageId");
    return response;
  }



  Future<List<Map>> getChannels({int page: 0, int pageSize:50}) async{
    String url = "$server/channels?latitude=$latitude&longitude=$longitude&distance=$distance"
        "&pagination_index=$page&pagination_size=$pageSize";
    url = Uri.encodeFull(url);
    Response response = await client.get(url,
    headers: {"token":token});
    print("[API getChannels] ${response.statusCode}  page: $page, pageSize: $pageSize");
    return JSON.decode(response.body);
  }



  String getMediaUrl(String url,{int inScale:null}) {
    return Uri.encodeFull("$server/media/$url");
  }

  String getChannelImage(String channel) {
    return Uri.encodeFull("$server/channel/$channel/image?token=$token");
  }

  String getLatestImage(String channel){
    return Uri.encodeFull("$server/channel/$channel/latest?distance=$distance&latitude=$latitude"
        "&longitude=$longitude");
  }

  double get latitude {
    return 50.0;
  }

  double get longitude {
    return 13.0;
  }

  double get distance {
    return 9.0;
  }

  String get token {
    return "fluttertesttoken";
  }

  String get channel {
    return "fablue";
  }

  String get name {
    return "Sebastian Sellmair";
  }

  String get lastImage {
    return null;
  }
}