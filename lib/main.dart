import 'package:flutter/material.dart';
import 'package:flutterbook/notes/Notes.dart';
import 'package:path_provider/path_provider.dart';
import 'appointments/Appointments.dart';
import 'contacts/Avatar.dart';
import 'contacts/Contacts.dart';
import 'tasks/Tasks.dart';
import 'links/Links.dart';

/// Serves as the entry-point to run the [FlutterBook] application
void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Avatar.docsDir = await getApplicationDocumentsDirectory();
    runApp(FlutterBook());
  }
  startMeUp();
}
/// This is the main widget that will be shown through the execution of the app.
/// it hosts instances of [Appointments] , [Contacts], [Links], [Notes] and
/// [Tasks] to create the agenda-like application.
class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Book',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DefaultTabController(
            length: 5,
            child: Scaffold(
                appBar: AppBar(
                    title: Text('Flutter Book'),
                    bottom: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.date_range), text: 'Appointments'),
                          Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                          Tab(icon: Icon(Icons.note), text: 'Notes'),
                          Tab(icon: Icon(Icons.assignment_turned_in), text: 'Tasks'),
                          Tab(icon: Icon(Icons.settings_overscan), text: 'QR Reader')
                        ]
                    )
                ),
                body: TabBarView(
                    children: [
                      Appointments(),
                      Contacts(),
                      Notes(),
                      Tasks(),
                      Links()
                    ]
                )
            )
        )
    );
  }
}