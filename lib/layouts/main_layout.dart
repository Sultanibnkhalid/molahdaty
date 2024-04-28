import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/cubit/cubit.dart';
import 'package:my_notes/cubit/states.dart';
import 'package:my_notes/models/note_model.dart';
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
            // Toast.show(NoteApp.get(context).color, duration: Toast.lengthLong);
            List<NoteModele> notes = NoteApp.notes;
            int sc = NoteApp.selectedScreen;
            return sc != 0
                ? NoteApp.screens[sc]
                : Scaffold(
                    appBar: AppBar(
                      // bottomOpacity: 20,
                      // shadowColor: Colors.black,
                      // systemOverlayStyle: SystemUiOverlayStyle.light,
                      title: const Center(
                          child: Text(
                        "MY NOTES",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                      leading: const Center(
                        child: Text(
                          "change",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    //floating button
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        //go to add not screen
                        NoteApp.get(context).newNote();
                      },
                      mini: true,
                      hoverColor: Colors.yellow,
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
                          separatorBuilder: (context, index) => Container(
                                width: double.infinity,
                                height: 3,
                                color: Colors.white,
                              ),
                          itemCount: notes.length),
                    ),
                  );
          }),
    );
  }
}

//build list view item
Widget buildItems(NoteModele note, context, index) => Container(
      width: double.infinity,
      height: 70,
      color: HexColor(note.color).withOpacity(0.5),
      child: GestureDetector(
        onTap: () => NoteApp.get(context).openNote(index),
        child: Row(
          children: [
            Container(
              width: 15,
              decoration: BoxDecoration(
                color: HexColor(note.color).withOpacity(1),
                border: const BorderDirectional(
                  end: BorderSide(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  child: Container(
                    // color: Colors.yellow.shade200,
                    decoration: const BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: Text(
                              "${note.date}",
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          child: note.isLiked > 0
                              ? const Icon(
                                  Icons.favorite,
                                  size: 10,
                                )
                              : null,
                        ),
                      ],
                    ),
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
          ],
        ),
      ),
    );
