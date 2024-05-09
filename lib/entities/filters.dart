class BaseFilter {
  int skip;
  int take;

  BaseFilter({this.skip = 0, this.take = 10});
}

class IdFilter extends BaseFilter {
  int? equal;
  int? notEqual;
}

class DateFilter extends BaseFilter {
  DateTime? less;
  DateTime? lessEqual;
  DateTime? greater;
  DateTime? greaterEqual;
}
