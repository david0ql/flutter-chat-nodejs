import 'package:flutter/material.dart';
import 'package:band_names/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Rammstein', votes: 2),
    Band(id: '3', name: 'Linkin Park', votes: 1),
    Band(id: '5', name: 'PXNDX', votes: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          "BandNames",
          style: TextStyle(color: Colors.black87),
        )),
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print(direction.index);
        //TODO Llamar el borrado en el server
      },
      background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(color: Colors.white),
            ),
          )),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(band.name!.substring(0, 2))),
        title: Text(band.name!),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Bandname"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
              textColor: Colors.blue,
              elevation: 5,
              child: const Text("Add"),
              onPressed: () {
                addBandToList(textController.text);
              })
        ],
      ),
    );
  }

  void addBandToList(String name) {
    print(name);

    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
      Navigator.pop(context);
    }
  }
}
