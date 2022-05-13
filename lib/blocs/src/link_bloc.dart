import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import 'package:url_shortener/models/model.dart';
import 'package:url_shortener/controllers/controller.dart';

part 'link_event.dart';

part 'link_state.dart';

class LinkBloc extends Bloc<LinkEvent, LinkState> {
  final LinkController _linkController;

  LinkBloc(this._linkController) : super(LinkInitial()) {
    on<LinkEvent>((event, emit) async {
      if (event is ShortenUrlEvent) {
        try {
          emit(LinkLoading());

          final res = await _linkController.shortenURL(event.url);
          if (res == null) {
            emit(const LinkException("No response found"));
          } else if (res is String) {
            emit(LinkException(res));
          } else if (res is Link) {
            emit(ShortenURLDone(res));
          } else {
            emit(const LinkException("Invalid response found"));
          }
        } catch (err, stackTrace) {
          debugPrint("ERROR SHORTEN Url:\t$err\n---\nStackTrace:\t$stackTrace");
          emit(const LinkException("Error shortening URL"));
        }
      }
      if (event is RetrieveLinkEvent) {
        try {
          emit(LinkLoading());

          final res = await _linkController.retrieveLink(event.alias);
          if (res == null) {
            emit(const LinkException("No response found"));
          } else if (res is String) {
            emit(LinkException(res));
          } else if (res is Link) {
            emit(RetrieveLinkDone(res.original));
          } else {
            emit(const LinkException("Invalid response found"));
          }
        } catch (e, stackTrace) {
          debugPrint("ERROR RETRIEVE LINK:\t$e\n---\nStackTrace:\t$stackTrace");
          emit(const LinkException("Error retrieving link"));
        }
      }
    });
  }
}
