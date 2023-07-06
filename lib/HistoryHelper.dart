double calculateTotalWeight(List<Map<String, dynamic>> recycleHistory) {
  double totalWeight = 0;
  for (Map<String, dynamic> historyEntry in recycleHistory) {
    double weight = historyEntry['weight'];
    totalWeight += weight;
  }
  return totalWeight;
}

double calculateTotalMoney(List<Map<String, dynamic>> recycleHistory) {
  double totalMoney = 0;
  for (Map<String, dynamic> historyEntry in recycleHistory) {
    double money = historyEntry['money'];
    totalMoney += money;
  }
  return totalMoney;
}
