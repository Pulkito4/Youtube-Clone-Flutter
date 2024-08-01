import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YtServices {
  dynamic apiKey = dotenv.env['API_KEY'];

  final dio = Dio();

  Future<dynamic> getPopularVideos(regionCode) async {
    String path =
        "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics%2C%20player&chart=mostPopular&maxResults=100&regionCode=$regionCode&key=$apiKey";
    final response = await dio.get(path);
    return response.data;
  }

  Future<dynamic> getVideoDetails(id) async {
    String path =
        "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=$id&key=$apiKey";
    final response = await dio.get(path);
    return response.data;
  }

  Future<dynamic> getChannelDetails(id) async {
    dynamic videoDetails = await getVideoDetails(id);
    dynamic channelId = videoDetails["items"][0]["snippet"]["channelId"];
    String path =
        "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=$channelId&key=$apiKey";
    final response = await dio.get(path);
    return response.data;
  }

  Future<dynamic> getVideoComments(id) async {
    String path =
        "https://youtube.googleapis.com/youtube/v3/commentThreads?part=snippet%2Creplies&videoId=$id&key=$apiKey";
    final response = await dio.get(path);
    return response.data;
  }

  Future<dynamic> searchVideos(query) async {
    String path =
        "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10000&q=$query&type=video&key=$apiKey";
    final response = await dio.get(path);
    

    return response.data;
  }
}
