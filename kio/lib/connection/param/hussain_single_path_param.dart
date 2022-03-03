import 'hussain_param.dart';

class HussainPathParam extends HussainParam {
  final List<String> param;

  HussainPathParam(this.param);

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<String> pathParam() => param??[];
}
