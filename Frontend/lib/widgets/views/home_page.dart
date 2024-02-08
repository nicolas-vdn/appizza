import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/widgets/components/card_gradient.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../api/pizza_api.dart';
import '../../classes/interfaces/pizza.dart';
import '../../providers/cart_provider.dart';
import '../components/cart_content.dart';
import '../components/loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pizza>> _pizzaList;

  @override
  initState() {
    super.initState();
    _pizzaList = PizzaApi.getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pizza>>(
      future: _pizzaList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loader();
          default:
            if (snapshot.hasData) {
              return Stack(
                alignment: AlignmentDirectional.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  PizzaCarousel(pizzaList: snapshot.data!),
                  const Positioned(
                    top: 16,
                    child: CartContent(),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
        }
        return const Loader();
      },
    );
  }
}

class PizzaCarousel extends StatefulWidget {
  const PizzaCarousel({super.key, required this.pizzaList});

  final List<Pizza> pizzaList;

  @override
  State<PizzaCarousel> createState() => _PizzaCarouselState();
}

class _PizzaCarouselState extends State<PizzaCarousel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: MediaQuery.of(context).size.height,
            autoPlayInterval: const Duration(seconds: 10),
            enlargeCenterPage: true,
          ),
          items: widget.pizzaList.map((pizza) {
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
                          child: SlideLowerPart(pizza: pizza),
                        ),
                        Positioned(
                          top: -100,
                          child: SlideUpperPart(pizza: pizza),
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
    );
  }
}

class SlideUpperPart extends StatefulWidget {
  const SlideUpperPart({super.key, required this.pizza});

  final Pizza pizza;

  @override
  State<SlideUpperPart> createState() => _SlideUpperPartState();
}

class _SlideUpperPartState extends State<SlideUpperPart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          widget.pizza.url,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class SlideLowerPart extends StatefulWidget {
  const SlideLowerPart({super.key, required this.pizza});

  final Pizza pizza;

  @override
  State<SlideLowerPart> createState() => _SlideLowerPartState();
}

class _SlideLowerPartState extends State<SlideLowerPart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return CardGradient(
          borderRadius: const BorderRadius.all(Radius.circular(32.0)),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 128, right: 32, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Text(
                                widget.pizza.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${widget.pizza.price} €",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Card(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "4.3",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            )
                          ],
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
                      onPressed: () => cart.removePizza(widget.pizza),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${cart.quantityOf(widget.pizza)}',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => cart.addPizza(widget.pizza),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
