import 'package:flutter/material.dart';
import 'package:band_names/src/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on(
        'active-bands',
        (data) => {
              bands.clear(),
              (data as List<dynamic>),
              for (var element in data) {bands.add(Band.fromMap(element))},
              setState(() {})
            });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.close();
    super.dispose();
  }

  _handleActiveBands(dynamic data) {}

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          "BandNames",
          style: TextStyle(color: Colors.black87),
        )),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.online)
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : const Icon(Icons.offline_bolt, color: Colors.red))
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) =>
                    _bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        socketService.socket.emit('delete-band', {'id': band.id});
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
          socketService.socket.emit('vote-band', {'id': band.id});
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
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('create-band', {'name': name});
      Navigator.pop(context);
    }
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var element in bands) {
      dataMap.putIfAbsent(element.name!, () => element.votes!.toDouble());
    }
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}
