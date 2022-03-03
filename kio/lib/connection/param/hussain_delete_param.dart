import 'package:flutter/foundation.dart';
import 'package:kio/connection/param/hussain_param.dart';

class HussainDeleteParam extends HussainParam {
  final String id;

  HussainDeleteParam({@required this.id});

  @override
  Map<String, String> toJson() => null;

  @override
  List<String> pathParam() => [id];
}
