 enum Jednostka { gram, sztuka, ml }
class Produkt {
  String nazwa;
  String dataWaznosci;
  int ilosc;
  Jednostka jednostka;
  double cena;

  Produkt({required this.nazwa, required this.dataWaznosci, required this.ilosc, required this.jednostka, required this.cena});
// Dodaj to:
  int dniDoWaznosci() {
    DateTime dataProduktu = DateTime.parse(dataWaznosci);
    DateTime dzisiaj = DateTime.now();
    
    // Tworzymy daty bez godzin, minut i sekund (ustawiamy na północ)
    DateTime dataP = DateTime(dataProduktu.year, dataProduktu.month, dataProduktu.day);
    DateTime dataD = DateTime(dzisiaj.year, dzisiaj.month, dzisiaj.day);
    
    return dataP.difference(dataD).inDays;
  }
  // To pozwoli nam łatwo zamieniać produkt na tekst (do zapisu w SharedPreferences)
  String toSaveString() => "$nazwa|$dataWaznosci|$ilosc|$jednostka|$cena";
  
  // To pozwoli odczytać tekst z dysku i zrobić z niego obiekt Produkt
  factory Produkt.fromSaveString(String data) {
    final parts = data.split('|');
    return Produkt(nazwa: parts[0], dataWaznosci: parts[1], ilosc: int.parse(parts[2]), jednostka: Jednostka.values.byName(parts[3]), cena: double.parse(parts[4]));
}}