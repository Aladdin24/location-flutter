import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/utils/utils.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'modifier.dart';
import 'TypeVoiture.dart';
import 'voiture.dart';

class AllPersonData extends StatefulWidget {
  @override
  _AllPersonDataState createState() => _AllPersonDataState();
}

class _AllPersonDataState extends State<AllPersonData> {
  Future allPerson() async {
    var url = "http://192.168.43.245/location/viewAll.php";
    var response = await http.get(Uri.parse(url));

    var jsonData = json.decode(response.body);

    List<Voiture> voitures = [];

    for (var v in jsonData) {
      Voiture voiture = Voiture(
          int.parse(v["id_voiture"]),
          v["Marque"],
          v["image"],
          v["Modele"],
          v["vitesses"],
          v["nbr_places"],
          v["Prix"],
          v["Couleur"],
          v["Disponibilite"],
          v["Code"]);

      voitures.add(voiture);
    }
    print(voitures.length);

    return voitures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Center(child: Text('VOITURES')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade900,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DemoUploadImage(),
            ),
          );
          debugPrint('Clicked FloatingActionButton Button');
        },
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () {
          return Navigator.pushReplacement(context,
              PageRouteBuilder(pageBuilder: (a, b, c) => AllPersonData()));
        },
        child: FutureBuilder(
          future: allPerson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int id) {
                      return Card(
                        elevation: 20,
                        child: ListTile(
                          title: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                child: Image.network(
                                    "http://192.168.43.245/location/uploads/${snapshot.data[id].image}"),
                              ),
                              InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  setState(() {
                                    var url = Uri.parse(
                                        'http://192.168.43.245/location/delete.php');
                                    http.post(url, body: {
                                      'id_voiture': snapshot.data[id].id_voiture
                                          .toString(),
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Center(
                              child: Text(
                            snapshot.data[id].Marque,
                            style: MainHeading,
                          )),
                          trailing: GestureDetector(
                            child: Icon(Icons.edit),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllModifier(
                                    id_voiture: snapshot.data[id].id_voiture,
                                    Marque: snapshot.data[id].Marque,
                                    image: snapshot.data[id].image,
                                    Modele: snapshot.data[id].Modele,
                                    vitesses: snapshot.data[id].vitesses,
                                    nbr_places: snapshot.data[id].nbr_places,
                                    Prix: snapshot.data[id].Prix,
                                    Couleur: snapshot.data[id].Couleur,
                                    Disponibilite:
                                        snapshot.data[id].Disponibilite,
                                    Code: snapshot.data[id].Code,
                                  ),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TypeVoiture(
                                    id_voiture: snapshot.data[id].id_voiture,
                                    Marque: snapshot.data[id].Marque,
                                    image: snapshot.data[id].image,
                                    Modele: snapshot.data[id].Modele,
                                    vitesses: snapshot.data[id].vitesses,
                                    nbr_places: snapshot.data[id].nbr_places,
                                    Prix: snapshot.data[id].Prix,
                                    Couleur: snapshot.data[id].Couleur,
                                    Disponibilite:
                                        snapshot.data[id].Disponibilite,
                                    Code: snapshot.data[id].Code,
                                  ),
                                ));
                          },
                        ),
                      );
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
