class StatisticData {
  final String dataName;
  final double data;
  final List<double> dataList;
  final Map<double, double> dataMap;

  const StatisticData(
    this.dataName,
    this.data,
    this.dataList,
    this.dataMap,
  );

  factory StatisticData.dataMap(
    String dataName,
    Map<double, double> dataMap,
  ) {
    return StatisticData(
      dataName,
      0.0,
      [],
      dataMap,
    );
  }

  factory StatisticData.data({
    String dataName = "",
    double data = 0.0,
  }) {
    return StatisticData(
      dataName,
      data,
      [],
      {},
    );
  }

  factory StatisticData.dataList(
    String dataName,
    List<double> dataList,
  ) {
    return StatisticData(
      dataName,
      0.0,
      dataList,
      {},
    );
  }
}
