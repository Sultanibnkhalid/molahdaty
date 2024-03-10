import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_notes/cubit/cubit.dart';
import 'package:my_notes/cubit/states.dart';
import 'package:sqflite/utils/utils.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //controoler
  var noteConteroller = TextEditingController();
  //key
  //var ScffoldKey = GlobalKey<ScaffoldState>();
  //
  // var showColors = false;
  // var isShowBottomSheet = true;

  var colors = [
    // ColorToHex(Colors.pink.shade100).toString(),
    ColorToHex(Colors.red.shade100).toString(),
    ColorToHex(Colors.orange.shade100).toString(),
    ColorToHex(Colors.amber.shade100).toString(),
    ColorToHex(Colors.pink.shade100).toString(),
    ColorToHex(Colors.blue.shade100).toString(),
    ColorToHex(Colors.green.shade100).toString(),
    ColorToHex(Colors.lime.shade100).toString(),
    ColorToHex(Colors.teal.shade100).toString(),
    ColorToHex(Colors.lightBlueAccent.shade100).toString(),
    ColorToHex(Colors.cyan.shade100).toString(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NoteApp(),
      child: BlocConsumer<NoteApp, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            // key: ScffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.yellow.shade100,
              bottomOpacity: 20,
              leading: IconButton(
                onPressed: () async {
                  await NoteApp.get(context).addNote(noteConteroller.text,
                      NoteApp.get(context).color, context);
                  //not this is first
                  //second step add check for the navigator
                  //when return to save the note
                },
                icon: const Icon(Icons.keyboard_arrow_left),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      //show option mene
                    },
                    icon: const Icon(Icons.menu))
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.yellow.shade400,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                //handel the event
                //  NoteApp.get(context).isShowBottomSheet?false:true;
                if (value == 3) {
                  NoteApp.get(context).changeBottomSheetState();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera),
                  label: "camera",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: "picture",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.alarm),
                  label: "alarm",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields),
                  label: "color",
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: noteConteroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'new note'),
                      textInputAction: TextInputAction.newline,
                      // style: TextStyle(lain),
                    ),
                  ),
                  // Container(
                  //   child: Row(children: [buildColorsItems(Colors.amber.shade700)]),
                  // ),
                ],
              ),
            ),

            bottomSheet: NoteApp.get(context).isShowBottomSheet
                ? BottomSheet(
                    elevation: 10,
                    backgroundColor: Colors.yellow.shade200,
                    enableDrag: false,

                    onClosing: () {
                      NoteApp.get(context).changeBottomSheetState();
                    },
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                colorItem(colors[index], context),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 20,
                                ),
                            itemCount: colors.length),
                      ),
                    ),
                    // Container(
                    //       width: double.infinity,
                    //       height: 250,
                    //       alignment: Alignment.center,
                    //       child: ElevatedButton(
                    //         child: const Text(
                    //           'Close this bottom sheet',
                    //         ),
                    //         onPressed: () {
                    //           setState(() {
                    //             isShowBottomSheet = false;
                    //           });
                    //         },
                    //       ),
                    //     ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

Widget colorItem(String color, context) => GestureDetector(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          shape: BoxShape.circle,
          color: Colors.redAccent.shade200,
        ),
      ),
      onTap: () {
        NoteApp.get(context).setColor(color);
        //handel color
      },
    );

//build color items
Widget buildColorsItems(Color color) => Container(
      height: 40,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
              ),
              onTap: () {
                //handel color
              },
            ),
            GestureDetector(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
              ),
              onTap: () {
                //handel color
              },
            ),
            GestureDetector(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
              ),
              onTap: () {
                //handel color
              },
            ),
            GestureDetector(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
              ),
              onTap: () {
                //handel color
              },
            ),
            GestureDetector(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
              ),
              onTap: () {
                //handel color
              },
            ),
          ],
        ),
      ),
    );

//builds icone widgets
Widget buildOpionsItems() => Container(
      height: 30,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              //get imge from camera
            },
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () {
              //get imge from image viewer
            },
            icon: const Icon(Icons.image),
          ),
          // const SizedBox(
          //   width: 15,
          // ),
          IconButton(
            onPressed: () {
              //set alert
            },
            icon: const Icon(Icons.alarm_add),
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () {
              //set the back ground color
            },
            icon: const Icon(Icons.texture),
          ),
        ],
      ),
    );
