import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';
import 'AjouterVoiture.dart';

class AllModifier extends StatefulWidget {
  final int id_voiture;
  final String Marque;
  final String image;
  final String Modele;
  final String vitesses;
  final String nbr_places;
  final String Prix;
  final String Couleur;
  final String Disponibilite;

  AllModifier(
      { required this.id_voiture,
        required this.Marque,
        required this.image,
        required this.Modele,
        required this.vitesses,
        required this.nbr_places,
        required this.Prix,
        required this.Couleur,
        required this.Disponibilite,});
  @override
  _AllModifier createState() => _AllModifier();
}

class _AllModifier extends State<AllModifier> {
  late File _image;

  final picker = ImagePicker();
  TextEditingController marqueController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController vitesseController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController couleurController = TextEditingController();
  TextEditingController disponibleController = TextEditingController();
  bool editMode = false;

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  Future modifier() async {
      var uri = Uri.parse("http://192.168.181.11/location/edit.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields['id_voiture'] = widget.id_voiture.toString();
      request.fields['marque'] = marqueController.text;
      request.fields['Modele'] = modelController.text;
      request.fields['vitesses'] = vitesseController.text;
      request.fields['nbr_places'] = placeController.text;
      request.fields['Prix'] = prixController.text;
      request.fields['Couleur'] = couleurController.text;
      request.fields['Disponibilite'] = disponibleController.text;
      var pic = await http.MultipartFile.fromPath("image", _image.path);
      request.files.add(pic);
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image Uploaded');
      } else {
        print('Image Not Uploaded');
      }

  }

  @override
  void initState() {
    super.initState();

    if (widget.id_voiture != null) {
      editMode = true;
      marqueController.text = widget.Marque;
      modelController.text = widget.Modele;
      vitesseController.text = widget.vitesses;
      placeController.text = widget.nbr_places;
      prixController.text = widget.Prix;
      couleurController.text = widget.Couleur;
      disponibleController.text = widget.Disponibilite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade900,
          title: Center(child: Text('Modifier')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: marqueController,
                  decoration: InputDecoration(labelText: 'Marque'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: 'Modele'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  hint: "Type de Moteur",
                  controller: vitesseController,
    suggestions: [
    'Gasoil',
    'Essence',
    'Hybride',
    
    ],
),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: placeController,
                  decoration: InputDecoration(labelText: 'Nomber Place'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  SearchField(
                  hint: "Couleur",
                  controller: couleurController,
    suggestions: [
    'Noir',
    'Rouge',
    'Jaune',
    'Blanc',
    'Bleu',
    'Gris',
    'Violet',
    'Orange',
    'Vert',
    
    ],
),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: disponibleController,
                  decoration: InputDecoration(labelText: 'Disponibilite'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  choiceImage();
                },
              ),
              Container(
                // child: _image == null
                //     ? Text('No Image Selected')
                //     : Image.file(_image),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.black54,
                child: Text('upload Image'),
                onPressed: () {
                  modifier();
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