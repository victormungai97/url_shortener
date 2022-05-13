part of 'link_bloc.dart';

abstract class LinkEvent extends Equatable {
  const LinkEvent();

  @override
  List<Object?> get props => [];
}

class ShortenUrlEvent extends LinkEvent {
  final String? url;

  const ShortenUrlEvent(this.url);
}

class RetrieveLinkEvent extends LinkEvent {
  final String? alias;

  const RetrieveLinkEvent(this.alias);
}
