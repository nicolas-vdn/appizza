import 'package:flutter/material.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/classes/models/place_search.dart';
import 'package:frontend/providers/cart_provider.dart';
import 'package:frontend/services/places_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../classes/models/place.dart';
import '../components/list_tile_cart.dart';
import '../utils/gradient_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isDone = false, _loading = false;

  void popup() {
    DateTime now = DateTime.parse("${DateTime.now().toLocal()}Z");

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
                              text: DateFormat.Hm('fr_FR')
                                  .format(now.add(const Duration(minutes: 30))),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " et "),
                          TextSpan(
                              text:
                                  "${DateFormat.Hm('fr_FR').format(now.add(const Duration(hours: 2)))}.",
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
            const MapSection(),
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
                      return ListTileCart(
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

class MapSection extends StatefulWidget {
  const MapSection({
    super.key,
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  late Iterable<PlaceSearch> _lastOptions = [];

  // Google Map
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<PlaceSearch> placePredictions = [];
  bool mapInteract = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: Breakpoints.tablet.size),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: Autocomplete<PlaceSearch>(
            fieldViewBuilder: ((context, textEditingController, focusNode, onFieldSubmitted) {
              //On implémente nous même le builder du textField pour pouvoir ajouter un hintText
              return TextFormField(
                onTap: () => setState(() => mapInteract = false),
                onTapOutside: (e) => setState(() => mapInteract = true),
                controller: textEditingController,
                focusNode: focusNode,
                onEditingComplete: onFieldSubmitted,
                decoration: const InputDecoration(hintText: 'Où devons nous vous livrer ?'),
              );
            }),
            displayStringForOption: (PlaceSearch option) => option.description!,
            optionsBuilder: (TextEditingValue textEditingValue) async {
              String? query = textEditingValue.text;
              final Iterable<PlaceSearch>? options = await PlacesService.getAutoComplete(query);

              if (options == null) {
                return _lastOptions;
              } else {
                _lastOptions = options;
              }

              // If another search happened after this one, throw away these options. use the previous options instead and wait for the newer request to finish.
              if (query != textEditingValue.text) {
                return _lastOptions;
              }

              return options;
            },
            optionsViewBuilder: (BuildContext context, onSelected, Iterable<PlaceSearch> options) {
              //On implémente nous même le builder sinon la width des options n'a pas de limite (issue connue flutter)
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    //On enlève le padding de la page et du autcomplete
                    width: MediaQuery.of(context).size.width - 128,
                    //On enlève le padding du autcomplete
                    constraints: BoxConstraints(maxWidth: Breakpoints.tablet.size - 64),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PlaceSearch option = options.elementAt(index);

                        return ListTile(
                          onTap: () {
                            onSelected(option);
                            setState(() => mapInteract = true);
                          },
                          title: Text("${option.description}"),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            onSelected: (PlaceSearch selection) async {
              Place? place = await PlacesService.getPlace(selection.placeId!);

              if (place != null) {
                mapController.moveCamera(CameraUpdate.newLatLng(LatLng(place.lat, place.lng)));
                setState(() => placePredictions = []);
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width - 50,
          constraints: BoxConstraints(
              maxWidth: Breakpoints.tablet.size, maxHeight: Breakpoints.mobileL.size),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: GoogleMap(
                webGestureHandling: mapInteract ? WebGestureHandling.auto : WebGestureHandling.none,
                zoomControlsEnabled: mapInteract,
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(48.856478593796744, 2.3394743644570393), zoom: 11.0)),
          ),
        ),
      ],
    );
  }
}
