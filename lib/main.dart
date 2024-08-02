import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Add your item',
            ),
            MyCustomForm(),
          ],
        ),
      ),
    );
  }
}

//https://docs.flutter.dev/cookbook/forms/validation
//---------------------------- you can add below class in separate file ---------------------------------------------------------

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List _myList = <String>[];
  List _myTempList = <String>[];
  bool isSearchMode = false;

  void onSubmitHandler() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      String myText = "";

      setState(() {
        _myList.add(myController.text.trim()); //add to list

        _myTempList = _myList; //temp ekata assign karanawa current list eka

        _formKey.currentState?.reset(); //clear text box

        //myController.clear();

        isSearchMode = false; //search mode eka off
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(myController.text),
      //     dismissDirection: DismissDirection.horizontal,
      //   ),
      // );
    }
  }

  void onClearAllHandler() {
    setState(() {
      _myList.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      _myList.removeAt(index);
    });
  }

  void onSearchHandler() {
    setState(() {
      //_myList eke thiyena item where loop eken loop karala, api search karana word eka ee item wala thiyenawanan,
      // ee okkoma tika list ekak karala e tika _myTempList ekata assign karanawa.
      _myTempList = _myList
          .where((element) =>
              element.toString().startsWith(myController.text.trim()))
          .toList();

      isSearchMode = true;
    });
  }

  void onSwitchHandler() {
    if (isSearchMode) {
      setState(() {
        //add karapu item list eka temp list ekata assign karanawa.
        _myTempList = _myList;
        //mode eka change karanawa.
        isSearchMode = !isSearchMode;
      });
    } else {
      onSearchHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: myController,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: onSubmitHandler,
                  child: const Text('Add'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: onClearAllHandler,
                  child: const Text('Clear'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: onSearchHandler,
                  child: const Text('Search'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: onSwitchHandler,
                  child: const Text('Switch'),
                ),
              ),
            ],
          ),
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _myTempList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Text(_myTempList[index]),
                  Container(
                    child: !isSearchMode
                        ? ElevatedButton(
                            onPressed: () {
                              removeItem(index);
                            },
                            child: const Text('Remove'),
                          )
                        : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
