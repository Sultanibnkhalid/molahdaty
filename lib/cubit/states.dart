import 'package:my_notes/models/note_model.dart';

abstract class AppStates {}

class InitialState extends AppStates {}

class AddNoteState extends AppStates {}

class GetNotesFromDBState extends AppStates {}

class NewNoteState extends AppStates {}

class NoteNotSavedState extends AppStates {}

class SaveNoteState extends AppStates {}

class DeleteNoteState extends AppStates {}

class BottomSheetStateChanged extends AppStates {}

class ChangedItemColorState extends AppStates {}

class OpenNoteState extends AppStates {}
// class EditNoteState extends AppStates {}
