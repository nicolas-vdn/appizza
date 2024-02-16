import 'package:flutter/material.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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


  bool _isDone = false,
      _loading = false;

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
    return Consumer<CartProvider>(
      builder: (context, cart, child){
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const CartContent(),
              Expanded(
                child: Form(
                  child: Consumer<MapProvider>(
                    builder: (context, map, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: DropdownMenu(
                                dropdownMenuEntries: map.places.map<
                                    DropdownMenuEntry>((
                                    Map<String, dynamic> place) {
                                  return DropdownMenuEntry(
                                    value: place["name"] as String,
                                    // Explicitly cast to String
                                    label: place["name"] as String, // Explicitly cast to String
                                  );
                                }).toList(),
                                initialSelection: map.pickedName,
                                onSelected: (selectedPlaceName) {
                                  map.onChangedAddress(selectedPlaceName);
                                  mapController.moveCamera(
                                      CameraUpdate.newLatLng(map.pickedPlace));
                                }),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                      target: map.pickedPlace, zoom: 11.0)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(255, 204, 0, 0),
                                  Color.fromARGB(255, 153, 0, 51),
                                ]),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
