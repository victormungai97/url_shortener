part of 'controller.dart';

class LinkController extends HTTPController {
  LinkController({Dio? dio}) : super(dio: dio);

  Future<dynamic> shortenURL(String? url) async {
    try {
      if (StringUtils.isNullOrEmpty(url)) return "Please enter URL to shorten";

      if (!isURL(url)) return "Provide valid URL to shorten";

      final result = await baseRequest(
        '/api-create.php/',
        queryParameters: {"url": url},
      );

      if (result is String) {
        if (isURL(result)) {
          return Link(
            original: url,
            shortened: result,
            alias: result.split('/').last,
          );
        }
        return result;
      }
      if (result is Map<String, dynamic>) return Link.fromJson(result);
      return "Invalid response found";
    } catch (err, stackTrace) {
      debugPrint("EXCEPTION:\t$err\n---\nSTACKTRACE:\t$stackTrace");
      return "Something went wrong. Try again later";
    }
  }

  Future<dynamic> retrieveLink(String? alias) async {
    try {
      if (StringUtils.isNullOrEmpty(alias)) {
        return "Please enter alias for retrieving link";
      }

      final result = await baseRequest(
        "${URLController.apiAliasURL}/$alias",
        method: "GET",
      );

      if (result is String) return result;
      if (result is Map<String, dynamic>) return Link(original: result["url"]);
      return "Invalid response found";
    } catch (err, stackTrace) {
      debugPrint("EXCEPTION:\t$err\n---\nSTACKTRACE:\t$stackTrace");
      return "Something went wrong. Try again later";
    }
  }
}
