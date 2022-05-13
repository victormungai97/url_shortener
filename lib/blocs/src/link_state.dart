part of 'link_bloc.dart';

abstract class LinkState extends Equatable {
  const LinkState();

  @override
  List<Object> get props => [];
}

class LinkInitial extends LinkState {}

class LinkLoading extends LinkState {}

class ShortenURLDone extends LinkState {
  final Link? link;

  const ShortenURLDone(this.link);
}

class RetrieveLinkDone extends LinkState {
  final String? link;

  const RetrieveLinkDone(this.link);
}

class LinkException extends LinkState {
  final String? message;

  const LinkException(this.message);
}
