import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(home: LodowkaScreen()));

class LodowkaScreen extends StatefulWidget {
  const LodowkaScreen({super.key});
  @override
  State<LodowkaScreen> createState() => _LodowkaScreenState();
}

class _LodowkaScreenState extends State<LodowkaScreen> {
  List<String> produkty = [];

 
 @override
  void initState() {
    super.initState();
    _loadData(); // Wywołaj wprost
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dane = prefs.getStringList('moje_produkty');
    debugPrint("ŁADOWANIE: Odczytano z dysku: $dane");
    
    if (dane != null) {
      setState(() {
        produkty = dane;
      });
      debugPrint("ŁADOWANIE: Ustawiono listę produktów na: $produkty");
    } else {
      debugPrint("ŁADOWANIE: Lista jest pusta (null)");
    }
  }
 Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setStringList('moje_produkty', produkty);
    debugPrint("Zapisano dane: $success, lista: $produkty");
  }



  void _addProdukt(String nazwa) {
    if (nazwa.isNotEmpty) {
      setState(() {
        produkty.add(nazwa);
        _saveData();
      });
    }
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
        itemBuilder: (context, index) => ListTile(
          title: Text(produkty[index]),
          leading: const Icon(Icons.fastfood),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeProdukt(index),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Dodaj produkt'),
              content: TextField(controller: controller, autofocus: true),
              actions: [
                TextButton(
                  onPressed: () {
                    _addProdukt(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Dodaj'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}