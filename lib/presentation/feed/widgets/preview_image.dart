import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PreviewImage extends Equatable {
  const PreviewImage({
    required this.id,
    required this.uri,
    this.decryptSecret,
    this.decryptNonce,
  });

  final String id;

  final String uri;

  final String? decryptSecret;
  final String? decryptNonce;

  @override
  List<Object> get props => [id, uri];
}
