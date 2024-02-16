import 'package:flutter/material.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/cart_content.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isDone = false, _loading = false;

  void popup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: _isDone ? const Text('Réussite') : const Text('Erreur'),
          content: _isDone
              ? const Text('Commande enregistrée !')
              : const Text('Erreur lors de l\'enregistrement de la commande'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                context.goNamed('home');
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
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
                          setState(() => _loading = true);
                          _isDone = await cart.launchOrder();
                          setState(() => _loading = false);

                          popup();
                        },
                        icon: _loading
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(
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
    });
  }
}
