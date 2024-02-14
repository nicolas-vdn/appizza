import 'package:flutter/material.dart';

import '../components/cart_content.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    // onSaved: (String? value) {
                    //   _address = value!;
                    // },
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
                      onPressed: () {},
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
}
