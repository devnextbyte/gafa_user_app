

import 'package:kio/connection/param/hussain_param.dart';

class HussainListParam extends HussainParam {
  DateTime from;
  DateTime to;
  String search;
  bool isDescending;
  int page;
  int pageSize;
  String orderBy;

  HussainListParam({
    this.from,
    this.to,
    this.search,
    this.isDescending = true,
    this.page = 1,
    this.pageSize = 20,
    this.orderBy,
  });

  @override
  toJson() {
    final param = {
      "From": from?.toIso8601String(),
      "To": to?.toIso8601String(),
      "Search": search,
      "IsDescending": isDescending,
      "Page": page,
      "PageSize": pageSize,
      "OrderBy": orderBy,
    };
    param.removeWhere((key, value) => value==null);
    return param;
  }
}
