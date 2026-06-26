import 'package:zana_shop/common/http_client.dart';

class Banner {
  final String image;
  final String text;
  final String url;

  Banner.fromJson(Map<String, dynamic> json)
    : image = '${httpClient.options.baseUrl}${json['image']}'.replaceAll('/api', ''),
      text = json['text'],
      url = json['url'];
}
