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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: () => context.goNamed("home"), icon: const Icon(Icons.arrow_back)),
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
                      DropdownMenu(
                          dropdownMenuEntries: map.places.map<DropdownMenuEntry>((Map<String, dynamic> place) {
                            return DropdownMenuEntry(
                              value: place["name"] as String, // Explicitly cast to String
                              label: place["name"] as String, // Explicitly cast to String
                            );
                          }).toList(),
                          initialSelection: map.pickedName,
                          onSelected: (selectedPlaceName) {
                            map.onChangedAddress(selectedPlaceName);
                            mapController.moveCamera(CameraUpdate.newLatLng(map.pickedPlace));
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 300,
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(target: map.pickedPlace, zoom: 11.0)),
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.surfaceTint),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
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
