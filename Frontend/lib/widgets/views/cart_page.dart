import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';

import '../components/cart_content.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // Google Map
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

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
              child: Consumer<MapProvider>(
                builder: (context, map, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton(
                          items: map.places.map((place) {
                            return DropdownMenuItem(
                              value: place["name"],
                              child: Text(place["name"]),
                            );
                          }).toList(),
                          onChanged: (selectedPlace) => map.onChangedAddress(selectedPlace)
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        constraints: const BoxConstraints(maxWidth: 750),
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: map.pickedPlace,
                                zoom: 11.0
                            )
                        ),
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
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
