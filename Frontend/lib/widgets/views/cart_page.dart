import 'package:flutter/material.dart';
import 'package:frontend/api/network_utility.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/classes/models/auto_complete_prediction.dart';
import 'package:frontend/classes/models/place_auto_complete_response.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/widgets/components/location_list_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/map_provider.dart';
import '../components/list_tile_item.dart';
import '../utils/gradient_card.dart';

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

  bool _isDone = false, _loading = false;

  List<AutoCompletePrediction> placePredictions = [];

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": "AIzaSyCeByGeg-TQvA81HK_1oS2CqpPhZ_Bx1Tc"
      });
    
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutoCompleteResponse result = 
        PlaceAutoCompleteResponse.parseAutoCompleteResult(response);
      if (result.predictions != null) {
        placePredictions = result.predictions!;
      }
    }
  }

  void popup() {
    DateTime now = DateTime.now().toLocal();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: _isDone ? const Icon(Icons.flatware) : const Icon(Icons.sentiment_dissatisfied),
          title: _isDone ? const Text('Réussite') : const Text('Erreur'),
          content: _isDone
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Commande en préparation !"),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: "Livraison prévue entre "),
                          TextSpan(
                              text: DateFormat.Hm().format(now.add(const Duration(minutes: 30))),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " et "),
                          TextSpan(
                              text: "${DateFormat.Hm().format(now.add(const Duration(hours: 2)))}.",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const CartContent(),
            const SizedBox(
              height: 16.0,
            ),
            Consumer<MapProvider>(
              builder: (context, map, child) {
                return Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        placeAutoComplete(value);
                      },
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Recherchez votre localisation',
                        prefixIcon: Icon(Icons.pin_drop),
                      ),
                    ),
                    const Divider(
                      height: 4,
                      thickness: 4
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: placePredictions.length,
                        itemBuilder: (context, index) => LocationListTile(
                          press: () {},
                          location: placePredictions[index].description!,
                        ),
                      )
                    ),
                    
                    
                    // DropdownMenu(
                    //     dropdownMenuEntries: map.places.map<DropdownMenuEntry>((Map<String, dynamic> place) {
                    //       return DropdownMenuEntry(
                    //         value: place["name"] as String,
                    //         label: place["name"] as String,
                    //       );
                    //     }).toList(),
                    //     initialSelection: map.pickedPlace["name"],
                    //     onSelected: (selectedPlaceName) {
                    //       map.onChangedAddress(selectedPlaceName);
                    //       mapController.moveCamera(CameraUpdate.newLatLng(map.pickedPlace["LatLng"]));
                    //     }),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width - 50,
                      constraints:
                          BoxConstraints(maxWidth: Breakpoints.tablet.size, maxHeight: Breakpoints.mobileL.size),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(target: map.pickedPlace["LatLng"], zoom: 11.0)),
                      ),
                    ),
                  ],
                );
              },
            ),
            Consumer<CartProvider>(builder: (context, cart, child) {
              return DecoratedBox(
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
                    if (cart.list.isEmpty) return;

                    setState(() => _loading = true);
                    _isDone = await cart.createOrder();
                    setState(() => _loading = false);
                    _isDone = true;

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
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardGradient(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Container(
            width: MediaQuery.of(context).size.width - 50,
            constraints: BoxConstraints(maxWidth: Breakpoints.tablet.size),
            child: ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              shape: const Border(),
              title: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${cart.total.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(color: Colors.white, indent: 16, endIndent: 16),
                Container(
                  constraints: BoxConstraints(maxHeight: Breakpoints.mobileS.size),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.list.length,
                    itemBuilder: (context, index) {
                      return ListTileItem(
                        item: cart.list.entries.toList()[index],
                        constant: true,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
