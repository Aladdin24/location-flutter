import 'dart:io';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'AjouterVoiture.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AllPersonData(),
    );
  }
}

class DemoUploadImage extends StatefulWidget {
  @override
  _DemoUploadImage createState() => _DemoUploadImage();
}

class _DemoUploadImage extends State<DemoUploadImage> {
  File? _image;

  final picker = ImagePicker();
  TextEditingController marqueController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController vitesseController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController couleurController = TextEditingController();
  TextEditingController disponibleController = TextEditingController();
  TextEditingController CodeController = TextEditingController();
  bool editMode = false;

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  Future upload() async {
    final uri = Uri.parse("http://192.168.43.245/location/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['marque'] = marqueController.text;
    request.fields['Modele'] = modelController.text;
    request.fields['vitesses'] = vitesseController.text;
    request.fields['nbr_places'] = placeController.text;
    request.fields['Prix'] = prixController.text;
    request.fields['Couleur'] = couleurController.text;
    request.fields['Disponibilite'] = 'DISPONIBLE';
    request.fields['Code'] = CodeController.text;
    var pic = await http.MultipartFile.fromPath("image", _image!.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploaded');
    } else {
      print('Image Not Uploaded');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade900,
          title: Center(child: Text('AJOUTER')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: marqueController,
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: modelController,
                  decoration: InputDecoration(
                    labelText: 'Modele',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: placeController,
                  decoration: InputDecoration(
                    labelText: 'Nomber Place',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: prixController,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: CodeController,
                  decoration: InputDecoration(
                    labelText: 'Code Voiture',
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownField(
                  controller: vitesseController,
                  hintText: "Type de Moteur",
                  enabled: true,
                  items: moteur,
                  onValueChanged: (value) {
                    setState(() {
                      selectMoteur = value;
                    });
                  },
                ),
                // SearchField(
                //   hint: "Type de Moteur",
                //   controller: vitesseController,
                //   suggestions: [
                //     'Gasoil',
                //     'Essence',
                //     'Hybride',
                //   ],
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownField(
                  controller: couleurController,
                  hintText: "Couleurs",
                  enabled: true,
                  items: couleurs,
                  onValueChanged: (value) {
                    setState(() {
                      selectCouleur = value;
                    });
                  },
                ),

                // SearchField(
                //   hint: "Couleur",
                //   controller: couleurController,
                //   suggestions: [
                //     'Noir',
                //     'Rouge',
                //     'Jaune',
                //     'Blanc',
                //     'Bleu',
                //     'Gris',
                //     'Violet',
                //     'Orange',
                //     'Vert',
                //   ],
                // ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextField(
              //     controller: disponibleController,
              //     decoration: InputDecoration(labelText: 'Disponibilite'),
              //   ),
              // ),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  choiceImage();
                },
              ),
              Container(
                child: _image == null
                    ? Text('Aucune Image Selectionnee')
                    : Image.file(_image!),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.purple.shade900,
                child: Text('Ajoute'),
                onPressed: () {
                  upload();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllPersonData(),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}

String selectCouleur = "";
String selectMoteur = "";

List<String> couleurs = [
  'Noir',
  'Blanc',
  'Jaune',
  'Vert',
  'Bleu',
  'Rouge',
  'Gris',
  'Brun',
  'Orange',
  'Violet'
];

List<String> moteur = [
  'Gasoil',
  'Essence',
  'Hybride',
];
