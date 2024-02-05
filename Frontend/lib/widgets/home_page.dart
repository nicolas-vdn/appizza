import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Pizza {
  String name;
  // String image;
  double price;

  Pizza(this.name, this.price);
}

class OrderLine {
  String pizzaName;
  double pizzaPrice;
  int count;

  OrderLine(this.pizzaName, this.pizzaPrice, this.count);
}

class Order{
  List<OrderLine> commandList = [];

  double getTotalPrice() {
    double total = 0;
    for (OrderLine elem in commandList) {
      total += elem.count * elem.pizzaPrice;
    }
    return total;
  }

  // void addPizza(Pizza pizzaToAdd){
  //   bool hasPassed = false;
  //
  //   // Check if pizza already in order to increment its counter
  //   for(OrderLine elem in commandList){
  //     if(elem.pizzaName == pizzaToAdd.name) {
  //       setState(() {
  //         elem.count += 1;
  //       });
  //       hasPassed = !hasPassed;
  //     }
  //   }
  //
  //   // If the pizza is not found in the order add it
  //   if(!hasPassed){
  //     commandList.add(OrderLine(pizzaToAdd.name, pizzaToAdd.price, 1));
  //   }
  // }

  // void removePizza(Pizza pizzaToAdd){
  //
  //   // Search for the pizza to decrease the counter
  //   for(OrderLine elem in commandList){
  //     if(elem.pizzaName == pizzaToAdd.name) {
  //       elem.count -= 1;
  //
  //       // If the counter is 0 then delete the item from the order (to remove it from the recap of the order)
  //       if(elem.count == 0){
  //         commandList.remove(elem);
  //       }
  //     }
  //   }
  // }

  int getCounterOfPizza(Pizza givenPizza){
    OrderLine? tmpCounter = commandList.firstWhereOrNull((element) => element.pizzaName == givenPizza.name);
    return tmpCounter != null ? tmpCounter.count : 0;
  }
}



class _HomePageState extends State<HomePage> {

  List<Pizza> pizzaList = [Pizza("Reine", 12.5), Pizza("4 Fromages", 10.5), Pizza("Bolognaise", 9.5), Pizza("Cannibale", 13.2)];
  Order newOrder = Order();

  // List<Pizza> getAllPizza(){
  //   Waiting for API
  //   return [Pizza("Reine", 12.5), Pizza("4 Fromages", 10.5), Pizza("Bolognaise", 9.5), Pizza("Cannibale", 13.2)];
  // }
  void addPizza(Pizza pizzaToAdd) {
    bool hasPassed = false;

    // Check if pizza already in order to increment its counter
    for (OrderLine elem in newOrder.commandList) {
      if (elem.pizzaName == pizzaToAdd.name) {
        setState(() {
          elem.count += 1;
        });
        hasPassed = !hasPassed;
      }
    }

    if(!hasPassed){
      setState(() {
        newOrder.commandList.add(OrderLine(pizzaToAdd.name, pizzaToAdd.price, 1));
      });
    }
  }
  void removePizza(Pizza pizzaToAdd){

    // Search for the pizza to decrease the counter
    for(OrderLine elem in newOrder.commandList){
      if(elem.pizzaName == pizzaToAdd.name) {
        setState(() {
          elem.count -= 1;
        });

        // If the counter is 0 then delete the item from the order (to remove it from the recap of the order)
        if(elem.count == 0){
          setState(() {
            newOrder.commandList.remove(elem);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        newOrder.commandList.isNotEmpty ?
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Theme.of(context).cardColor,

              child: ExpandablePanel(
                header: Padding(
                  padding: const EdgeInsets.only(bottom : 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Center(
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Center(
                        child: Text(''),
                      ),
                      Center(
                        child: Text('${newOrder.getTotalPrice()} €'),
                      ),
                    ],
                  ),
                ),
                collapsed: const SizedBox(height: 1,),
                expanded: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: newOrder.commandList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                child: Text('${newOrder.commandList[index].count} x'),
                              ),
                              Center(
                                child: Text(newOrder.commandList[index].pizzaName),
                              ),
                              Center(
                                child: Text('${newOrder.commandList[index].pizzaPrice} €'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Divider(color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom : 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Center(
                            child: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Center(
                            child: Text(''),
                          ),
                          Center(
                            child: Text('${newOrder.getTotalPrice()} €'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          )
          : const SizedBox(height: 10)
        ,
        Expanded(
          child: Card(
            color: Colors.transparent,
            child: Center(
              child: ListView.builder(
                itemCount: pizzaList.length,
                itemBuilder: (context, index) {
                  final pizza = pizzaList[index];
                  return ListTile(
                    title: Text(pizza.name),
                    subtitle: Text('USD ${pizza.price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            onPressed: () => removePizza(pizza),
                            icon: const Icon(Icons.remove)),
                        const SizedBox(width: 15),
                        Text('${newOrder.getCounterOfPizza(pizza)}'),
                        const SizedBox(width: 15),
                        IconButton(
                            onPressed: () => addPizza(pizza),
                            icon: const Icon(Icons.add)),
                      ],
                    ),);
                  // return Container(
                  //   margin: const EdgeInsets.only(top: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Center(
                  //         child: Text(pizzaList[index].name),
                  //       ),
                  //       Center(
                  //         child: Text('${pizzaList[index].price} €'),
                  //       ),
                  //       Center(
                  //         child: IconButton(
                  //           style: ButtonStyle(
                  //             backgroundColor: MaterialStatePropertyAll<Color>(
                  //                 Theme.of(context).colorScheme.secondary),
                  //             shape: MaterialStateProperty.all(
                  //                 RoundedRectangleBorder(
                  //                     borderRadius:
                  //                     BorderRadius.circular(1.0))),
                  //           ),
                  //           onPressed: () => newOrder.addPizza(pizzaList[index]),
                  //           icon: const Icon(Icons.remove),
                  //         ),
                  //       ),
                  //       Center(
                  //         child: Text('${newOrder.getCounterOfPizza(pizzaList[index])}'),
                  //       ),
                  //       Center(
                  //         child: IconButton(
                  //           style: ButtonStyle(
                  //             backgroundColor: MaterialStatePropertyAll<Color>(
                  //                 Theme.of(context).colorScheme.primary),
                  //             shape: MaterialStateProperty.all(
                  //                 RoundedRectangleBorder(
                  //                     borderRadius:
                  //                     BorderRadius.circular(1.0))),
                  //           ),
                  //           onPressed: () => newOrder.addPizza(pizzaList[index]),
                  //           icon: const Icon(Icons.add),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
