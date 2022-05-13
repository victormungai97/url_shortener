import 'package:equatable/equatable.dart';

/// Model class to represent a shortened link

class Link extends Equatable {
  final String? alias;
  final String? original;
  final String? shortened;

  const Link._({this.alias = "", this.original = "", this.shortened = ""});

  factory Link({String? alias, String? original, String? shortened}) => Link._(
        alias: alias ?? "",
        original: original ?? "",
        shortened: shortened ?? "",
      );

  @override
  List<Object?> get props => [alias, original, shortened];

  static Link? fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return null;
    final _links = json["_links"] ?? {};
    return Link(
      alias: json["alias"] ?? "",
      original: _links?["self"] ?? "",
      shortened: _links?["short"] ?? "",
    );
  }

  static Map<String, dynamic>? toJson(Link? link) {
    if (link == null) return {};
    return <String, dynamic>{
      "alias": link.alias,
      "_links": {
        "self": link.original,
        "short": link.shortened,
      },
    };
  }

  @override
  String toString() => 'URL `$original` shortened to `$shortened`';
}
