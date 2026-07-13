import 'package:flutter/material.dart';
import 'produkt.dart';

class AddProduktDialog extends StatefulWidget {
  final void Function(String nazwa, String data, int ilosc, Jednostka jednostka, double cena) onAdd;
  const AddProduktDialog({super.key, required this.onAdd});

  @override
  State<AddProduktDialog> createState() => _AddProduktDialogState();
}

class _AddProduktDialogState extends State<AddProduktDialog> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  DateTime wybranaData = DateTime.now();
  Jednostka wybranaJednostka = Jednostka.gram;

  double get cena => double.tryParse(priceController.text.replaceAll(',', '.')) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dodaj produkt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nazwa")),
          TextField(controller: priceController, decoration: const InputDecoration(labelText: "Cena zakupu"), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Ilość"), keyboardType: TextInputType.number),
          DropdownButton<Jednostka>(
            value: wybranaJednostka,
            onChanged: (val) => setState(() => wybranaJednostka = val!),
            items: Jednostka.values.map((j) => DropdownMenuItem(value: j, child: Text(j.name))).toList(),
          ),
          TextButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
              if (picked != null) setState(() => wybranaData = picked);
            },
            child: Text("Data ważności: ${wybranaData.toString().split(' ')[0]}"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              widget.onAdd(nameController.text, wybranaData.toString().split(' ')[0], int.tryParse(quantityController.text) ?? 0, wybranaJednostka, cena);
              Navigator.pop(context);
            }
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}