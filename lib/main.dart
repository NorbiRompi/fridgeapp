import 'package:flutter/material.dart';
import 'lodowka_screen.dart'; // Importujemy główny widok

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false, // Opcjonalnie, usuwa pasek "debug"
  home: LodowkaScreen(),
));