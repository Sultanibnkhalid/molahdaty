import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:molahdaty/cubit/cubit.dart';
import 'package:molahdaty/cubit/states.dart';
import 'package:molahdaty/layouts/about_layout.dart';
import 'package:molahdaty/layouts/settings_layout.dart';
import 'package:molahdaty/models/note_model.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NoteApp()..getNotes(),
      child: BlocConsumer<NoteApp, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            List<NoteModele> notes = NoteApp.notes;
            int sc = NoteApp.selectedScreen;
            return sc != 0
                ? NoteApp.screens[sc]
                : Scaffold(
                    appBar: AppBar(
                      title: Center(
                          child: Text(
                        "MY NOTES".tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )),
                    ),
                    drawer: Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Colors.cyan,
                            ),
                            child: Text(
                              'My Notes'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('Home').tr(),
                            onTap: () {
                              // Close the drawer
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('Add Note').tr(),
                            onTap: () {
                              NoteApp.get(context).newNote();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Settings').tr(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Settings()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text('About').tr(),
                            onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const About()
                              ));
                            },
                          ),
                        ],
                      ),
                    ),

                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        NoteApp.get(context).newNote();
                      },
                      mini: true,
                      hoverColor: Colors.cyanAccent,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.add),
                    ),
                    //body
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>
                              buildItems(notes[index], context, index),
                          separatorBuilder: (context, index) => const Gap(5),
                          itemCount: notes.length),
                    ),
                  );
          }),
    );
  }
}

//build list view item
Widget buildItems(NoteModele note, context, index) => Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: HexColor(note.color),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.cyanAccent,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.0,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: () => NoteApp.get(context).openNote(index),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.cyanAccent,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 8),
                              child: Text(
                                "${note.date}",
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${note.content}',
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          IconButton(
            onPressed: () {
              final noteApp1 = BlocProvider.of<NoteApp>(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Note').tr(),
                  content:
                      const Text('Are you sure you want to delete this note?')
                          .tr(),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel').tr(),
                    ),
                    TextButton(
                      onPressed: () async {
                        await noteApp1.deleteNote(note.id, context);

                        Navigator.pop(context);
                      },
                      child: const Text('Delete').tr(),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
