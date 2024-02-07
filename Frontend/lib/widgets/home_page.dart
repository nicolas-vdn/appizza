import 'package:flutter/material.dart';
import 'package:frontend/api/pizza_api.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../interfaces/pizza.dart';
import '../providers/cart_provider.dart';
import 'components/cart_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Pizza> _pizzaList = [];

  @override
  initState() {
    super.initState();
    fetchPizza();
  }

  fetchPizza() async {
    var pizzaList = await PizzaApi.getCollection();
    setState(() {
      _pizzaList = pizzaList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return CarouselSlider(
                        options: CarouselOptions(
                          height: 500.0,
                          enlargeCenterPage: true,
                        ),
                        items: _pizzaList.map((pizza) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: AlignmentDirectional.topCenter,
                                    children: [
                                      Positioned(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              stops: [0.1, 0.9],
                                              colors: [
                                                Color.fromARGB(255, 204, 0, 0),
                                                Color.fromARGB(255, 153, 0, 51),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 2.0),
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 32.0, top: 128, right: 32, bottom: 32),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          pizza.name,
                                                          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                          softWrap: true,
                                                        ),
                                                        Text(
                                                          "${pizza.price} €",
                                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    ),
                                                    const Card(
                                                      color: Colors.transparent,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [Text("4.3"), Icon(Icons.star)],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 32,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () => cart.removePizza(pizza),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white,
                                                        padding: const EdgeInsets.all(20),
                                                        shape: const CircleBorder(),
                                                      ),
                                                      child: const Icon(Icons.remove),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${cart.quantityOf(pizza)}',
                                                        style: const TextStyle(fontSize: 25),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () => cart.addPizza(pizza),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white,
                                                        padding: const EdgeInsets.all(20),
                                                        shape: const CircleBorder(),
                                                      ),
                                                      child: const Icon(Icons.add),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -100,
                                        child: SizedBox(
                                          width: 200,
                                          height: 200,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0), // Ajustez la valeur du border radius selon vos besoins
                                            child: Image.network(
                                              pizza.url, // Remplacez l'URL par l'URL de votre image
                                              width: 200.0, // Ajustez la largeur de l'image selon vos besoins
                                              height: 200.0, // Ajustez la hauteur de l'image selon vos besoins
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
              const Positioned(
                bottom: 0,
                child: CartContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
