import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'produkt.dart';
import 'add_produkt_dialog.dart';
import 'edit_produkt_dialog.dart';  

class LodowkaScreen extends StatefulWidget {
  const LodowkaScreen({super.key});
  @override
  State<LodowkaScreen> createState() => _LodowkaScreenState();
}


class _LodowkaScreenState extends State<LodowkaScreen> {
  List<Produkt> produkty = [];
  String _wyszukiwanaFraza = '';
  bool _sortujPoDacie = true;
 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  List<Produkt> get _widoczneProdukty {
    List<Produkt> lista = produkty.where((p) => 
      p.nazwa.toLowerCase().contains(_wyszukiwanaFraza.toLowerCase())
    ).toList();
    if (_sortujPoDacie) {
      lista.sort((a, b) => a.dniDoWaznosci().compareTo(b.dniDoWaznosci()));
    }
    return lista;
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dane = prefs.getStringList('moje_produkty');
    if (dane != null) setState(() => produkty = dane.map((item) => Produkt.fromSaveString(item)).toList());
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('moje_produkty', produkty.map((p) => p.toSaveString()).toList());
  }

  void _addProdukt(String nazwa, String data, int ilosc, Jednostka jednostka, double cena) {
    setState(() {
      produkty.add(Produkt(nazwa: nazwa, dataWaznosci: data, ilosc: ilosc, jednostka: jednostka, cena: cena));
      _saveData();
    });
  }

  void _removeProdukt(Produkt p) {
    setState(() {
      produkty.remove(p);
      _saveData();
    });
  }

void _editProdukt(Produkt produkt) {
  showDialog(
    context: context,
    builder: (context) => EditProduktDialog(
      produkt: produkt,
      onSave: () {
        _saveData(); // Zapisujemy zmiany do SharedPreferences
        setState(() {}); // Odświeżamy UI
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final widoczne = _widoczneProdukty;
    return Scaffold(
      appBar: AppBar(title: const Text('Moja Lodówka'), actions: [
        IconButton(icon: Icon(_sortujPoDacie ? Icons.sort : Icons.sort_by_alpha), onPressed: () => setState(() => _sortujPoDacie = !_sortujPoDacie)),
      ]),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: TextField(decoration: const InputDecoration(labelText: "Szukaj...", prefixIcon: Icon(Icons.search)), onChanged: (val) => setState(() => _wyszukiwanaFraza = val))),
          Expanded(child: ListView.builder(
            itemCount: widoczne.length,
            itemBuilder: (context, index) {
              final produkt = widoczne[index];
              int dni = produkt.dniDoWaznosci();
              return Card(
                color: dni < 1 ? Colors.red[100] : (dni <= 2 ? Colors.yellow[100] : Colors.white),
                child: ListTile(
                  title: Text(produkt.nazwa),
                  subtitle: Text("Ilość: ${produkt.ilosc} ${produkt.jednostka.name} \nWażne jeszcze: $dni dni \nCena zakupu: ${produkt.cena.toStringAsFixed(2)} zl"),
                  trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => _removeProdukt(produkt)),
                          IconButton(icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)), onPressed: () => _editProdukt(produkt)),
                        ],
                      ), 
                ),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => showDialog(context: context, builder: (context) => AddProduktDialog(onAdd: _addProdukt)), child: const Icon(Icons.add)),
    );
  }
}