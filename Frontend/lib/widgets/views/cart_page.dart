import 'package:flutter/material.dart';
import 'package:frontend/widgets/components/cart_content.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back)),
        const CartContent(),
        Expanded(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.surfaceTint),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                    ),
                    onPressed: null,
                    child: const Text('Commander'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
