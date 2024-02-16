import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/enums/breakpoints.dart';
import 'package:frontend/widgets/utils/gradient_card.dart';
import 'package:provider/provider.dart';

import '../../api/pizza_api.dart';
import '../../classes/models/pizza.dart';
import '../../providers/cart_provider.dart';
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
              return SingleChildScrollView(child: PizzaCarousel(pizzaList: snapshot.data!));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
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
  late CarouselController _controller;

  @override
  void initState() {
    _controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32.0),
              constraints: BoxConstraints(maxWidth: Breakpoints.tablet.size),
              child: TextFormField(
                onChanged: (String? value) {
                  try {
                    Pizza pizza = widget.pizzaList
                        .singleWhere((Pizza element) => element.name.toLowerCase().contains("${value?.toLowerCase()}"));
                    _controller.jumpToPage(widget.pizzaList.indexOf(pizza));
                  } catch (e) {}
                },
                decoration: const InputDecoration(
                  hintText: 'Très faim ? Recherchez votre pizza',
                  icon: Icon(Icons.local_pizza),
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                height: 550,
                autoPlayInterval: const Duration(seconds: 10),
                enlargeCenterPage: true,
              ),
              carouselController: _controller,
              items: widget.pizzaList.map((pizza) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
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
      child: ClipOval(
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
                            "${widget.pizza.price.toStringAsFixed(2)} €",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.pizza.note.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
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
                      onPressed: () => cart.removePizza(widget.pizza.id),
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
                        '${cart.quantityOf(widget.pizza.id)}',
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
