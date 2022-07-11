final _manufacturers = [
  "Volkswagen",
  "Audi",
  "BMW",
  "Mercedes-Benz",
  "Škoda",
  "Ford",
  "Pontiac",
  "Opel",
  "Porsche",
  "Seat",
  "Peugeot",
  "Citroën",
];

List<String> getManufacturers() {
  _manufacturers.sort();
  return _manufacturers;
}

/// Generate model years from 1950 to current year
final modelYears = List.generate(DateTime.now().year - 1949, (index) {
  return (1950 + index).toString();
});

List<String> getModelYears() {
  modelYears.sort((b, a) => a.compareTo(b));
  return modelYears;
}

List<String> getEngineDisplacements() => engineDisplacements;

const engineDisplacements = [
  "1.0",
  "1.1",
  "1.2",
  "1.3",
  "1.4",
  "1.5",
  "1.6",
  "1.7",
  "1.8",
  "1.9",
  "2.0",
  "2.1",
  "2.2",
  "2.3",
  "2.4",
  "2.5",
  "2.6",
  "2.7",
  "2.8",
  "2.9",
];
