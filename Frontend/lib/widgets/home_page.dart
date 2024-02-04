import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Command {
  int count;
  String name;
  double price;

  Command(this.count, this.name, this.price);
}

class _HomePageState extends State<HomePage> {
  List<Command> commandList = [
    Command(2, "Reine", 10.0),
    Command(1, "4 Fromages", 20.0),
    // Command(1, "Bolognaise", 15.5),
    // Command(4, "Test", 9.3),
  ];

  double getTotalPrice() {
    double total = 0;
    for (Command elem in commandList) {
      total += elem.count * elem.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Theme.of(context).cardColor,

            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: commandList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Text('${commandList[index].count} x'),
                          ),
                          Center(
                            child: Text(commandList[index].name),
                          ),
                          Center(
                            child: Text('${commandList[index].price} €'),
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
                        child: Text('${getTotalPrice()} €'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Expanded(
          child: Card(
            color: Colors.transparent,
            child: Center(
              child: Text(
                "Bonjour",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
