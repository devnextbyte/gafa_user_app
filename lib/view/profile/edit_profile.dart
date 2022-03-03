import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kio/connection/hussain.dart';
import 'package:kio/connection/kio.dart' as kio;
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  bool loading = false;
  bool loadImage = false;

  @override
  void initState() {
    super.initState();
    fullName.text = context.read<AuthState>().fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // SizedBox(height: 54),
        getHeader(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 54),
              getProfile(context),
              SizedBox(height: 28),
              getForm(context),
              SizedBox(height: 28),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget getHeader(BuildContext context) {
    return HeaderBar(showBackButton: true, title: "Profile");
  }

  Widget getProfile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2,
      height: width / 2,
      child: Stack(
        children: [
          Container(
            width: width / 2,
            height: width / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width / 2),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                width: 8,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width / 2),
              child: Image.network(
                Hussain.prefixBase(onUrl: context.watch<AuthState>().image),
                // loadingBuilder: (a, b, c) =>
                //     CircularProgressIndicator(),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: Builder(
                builder: (context) => loadImage
                    ? Center(child: CircularProgressIndicator())
                    : IconButton(
                        icon: Icon(Icons.camera_alt_rounded,
                            color: Theme.of(context).primaryColor),
                        onPressed: () => showUpdateProfileOptions(context),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: TextEditingController()
                  ..text = context.watch<AuthState>().email,
              ),
              TextFormField(
                enabled: false,
                controller: TextEditingController()
                  ..text = context.watch<AuthState>().phoneNumber,
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                validator: mandatoryValidator,
                decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor)),
                controller: fullName,
                maxLength: 20,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 24),
              Builder(
                builder: (context) => loading
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  updateName(context, fullName.text),
                              child: Text("Update"),
                            ),
                          ),
                        ],
                      ),
              )
            ],
          )),
    );
  }

  void updateName(BuildContext context, String name) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      loading = true;
    });
    final resp = await kio.post(
      token: await context.read<AuthState>().token,
      path: "/api/v1/User/profile",
      bodyParam: () => {"fullName": name},
    );
    if (resp.hasError) {
      setState(() {
        loading = false;
      });
      snack(context, resp.error.errorMessage);
    } else {
      context.read<AuthState>().refresh();
      snack(context, "Name Updated Successfully", info: true);
      setState(() {
        loading = false;
      });
    }
  }

  void showUpdateProfileOptions(BuildContext context) {
    Scaffold.of(context).showBottomSheet((_context) => Container(
          height: MediaQuery.of(context).size.height / 5,
          child: Card(
            elevation: 8,
            child: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  onTap: () =>
                      getImageAndUpdateProfile(context, ImageSource.camera),
                  title: Text("Camera"),
                  trailing: Icon(Icons.camera_alt_outlined,
                      color: Theme.of(context).primaryColor),
                ),
                ListTile(
                  onTap: () =>
                      getImageAndUpdateProfile(context, ImageSource.gallery),
                  title: Text("Gallery"),
                  trailing: Icon(Icons.image_outlined,
                      color: Theme.of(context).primaryColor),
                ),
              ]).toList(),
            ),
          ),
        ));
  }

  void getImageAndUpdateProfile(
      BuildContext context, ImageSource source) async {
    pop(context);
    setState(() {
      loadImage = true;
    });
    final image =
        await ImagePicker().getImage(source: source, imageQuality: 20);
    final base64 = base64Encode(await image.readAsBytes());
    final resp = await kio.post(
      path: "/api/v1/User/image",
      bodyParam: () => {"image": base64},
      token: await context.read<AuthState>().token,
    );
    if (resp.hasError) {
      setState(() {
        loadImage = false;
      });
      snack(context, resp.error.errorMessage);
    } else {
      await context.read<AuthState>().refresh();
      setState(() {
        loadImage = false;
      });
    }
  }
}
