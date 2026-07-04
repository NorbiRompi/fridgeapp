import 'package:flutter/material.dart';
import 'produkt.dart';

class EditProduktDialog extends StatefulWidget {
  final Produkt produkt;
  final VoidCallback onSave; // Funkcja do odświeżenia ekranu po zapisie

  const EditProduktDialog({super.key, required this.produkt, required this.onSave});

  @override
  State<EditProduktDialog> createState() => _EditProduktDialogState();
}

class _EditProduktDialogState extends State<EditProduktDialog> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    // Inicjalizujemy pole tekstowe aktualną ilością produktu
    quantityController = TextEditingController(text: widget.produkt.ilosc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edytuj: ${widget.produkt.nazwa}'),
      content: TextField(
        controller: quantityController,
        decoration: InputDecoration(labelText: "Nowa ilość w ${widget.produkt.jednostka.name}"),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.produkt.ilosc = int.tryParse(quantityController.text) ?? widget.produkt.ilosc;
            });
            widget.onSave(); // Wywołujemy funkcję zapisu w LodowkaScreen
            Navigator.pop(context);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}