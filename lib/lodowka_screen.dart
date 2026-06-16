import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'produkt.dart';
import 'add_produkt_dialog.dart'; // Importujemy nowe okienko

class LodowkaScreen extends StatefulWidget {
  const LodowkaScreen({super.key});
  @override
  State<LodowkaScreen> createState() => _LodowkaScreenState();
}

class _LodowkaScreenState extends State<LodowkaScreen> {
  List<Produkt> produkty = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dane = prefs.getStringList('moje_produkty');
    if (dane != null) {
      setState(() {
        produkty = dane.map((item) => Produkt.fromSaveString(item)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> daneDoZapisu = produkty.map((p) => p.toSaveString()).toList();
    await prefs.setStringList('moje_produkty', daneDoZapisu);
  }

  void _addProdukt(String nazwa, String data, int ilosc, Jednostka jednostka) {
    setState(() {
      produkty.add(Produkt(nazwa: nazwa, dataWaznosci: data, ilosc: ilosc, jednostka: jednostka));
      _saveData();
    });
  }

  void _removeProdukt(int index) {
    setState(() {
      produkty.removeAt(index);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moja Lodówka')),
      body: ListView.builder(
        itemCount: produkty.length,
        itemBuilder: (context, index) {
          final produkt = produkty[index];
          int dni = produkt.dniDoWaznosci();
          
          return Card(
            color: dni < 1 ? Colors.red[100] : (dni <= 2 ? Colors.yellow[100] : Colors.white),
            child: ListTile(
              title: Text(produkt.nazwa),
              subtitle: Text("Ilość: ${produkt.ilosc} ${produkt.jednostka.name} \nKoniec ważności: ${dni} dni"),
              trailing: IconButton(
                icon: const Icon(Icons.clear, color: Colors.red),
                onPressed: () => _removeProdukt(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wywołujemy nasz nowy, wydzielony dialog
          showDialog(
            context: context,
            builder: (context) => AddProduktDialog(onAdd: _addProdukt),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}