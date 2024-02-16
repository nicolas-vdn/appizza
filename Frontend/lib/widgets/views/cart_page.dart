import 'package:flutter/material.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../components/cart_content.dart';

class CartPage extends StatefulWidget {
  
  const CartPage({super.key});

  
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isDone = false;

  void popup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isDone ? const Text('Réussite') : const Text('Erreur'),
          content: isDone ? const Text('Commande enregistrée !')
          : const Text('Erreur lors de l\'enregistrement de la commande'),
          actions: [TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
            )],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const CartContent(),
              Expanded(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Adresse',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Entrez une adresse valide';
                          }
                          return null;
                        },
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 204, 0, 0),
                            Color.fromARGB(255, 153, 0, 51),
                          ]),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            isDone = await cart.launchOrder();
                            popup();
                          },
                          icon: const Icon(
                            Icons.paypal,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Commander",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );    
  }
}
