import 'package:flutter/material.dart';

import '../data/link.dart';

class Links extends ChangeNotifier {
  List<Link?> _links = [];

  List<Link?> get links => _links;

  set links(List<Link?> links) {
    _links = links;
    notifyListeners();
  }

  void add(Link? link) {
    _links.add(link);
    notifyListeners();
  }

  void remove(int index) {
    _links.removeAt(index);
    notifyListeners();
  }
}