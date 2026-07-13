enum Jednostka { gram, sztuka, ml }

class Produkt {
  String nazwa;
  String dataWaznosci;
  int ilosc;
  Jednostka jednostka;
  double cena;

  Produkt({required this.nazwa, required this.dataWaznosci, required this.ilosc, required this.jednostka, required this.cena});

  int dniDoWaznosci() {
    DateTime dataProduktu = DateTime.parse(dataWaznosci);
    DateTime dzisiaj = DateTime.now();
    DateTime dataP = DateTime(dataProduktu.year, dataProduktu.month, dataProduktu.day);
    DateTime dataD = DateTime(dzisiaj.year, dzisiaj.month, dzisiaj.day);
    return dataP.difference(dataD).inDays;
  }

  String toSaveString() => "$nazwa|$dataWaznosci|$ilosc|${jednostka.name}|$cena";

  factory Produkt.fromSaveString(String data) {
    final parts = data.split('|');
    return Produkt(
      nazwa: parts[0],
      dataWaznosci: parts[1],
      ilosc: int.parse(parts[2]),
      jednostka: Jednostka.values.byName(parts[3]),
      cena: double.parse(parts[4]),
    );
  }
}