import 'package:flutter/material.dart';
import 'produkt.dart';

class EditProduktDialog extends StatefulWidget {
  final Produkt produkt;
  final VoidCallback onSave;
  const EditProduktDialog({super.key, required this.produkt, required this.onSave});

  @override
  State<EditProduktDialog> createState() => _EditProduktDialogState();
}

class _EditProduktDialogState extends State<EditProduktDialog> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: widget.produkt.ilosc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edytuj: ${widget.produkt.nazwa}'),
      content: TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Nowa ilość"), keyboardType: TextInputType.number),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
        ElevatedButton(
          onPressed: () {
            widget.produkt.ilosc = int.tryParse(quantityController.text) ?? widget.produkt.ilosc;
            widget.onSave();
            Navigator.pop(context);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}