import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // final Key key;
  // SettingsPage({this.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // create a back button that goes back to the main.dart page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // pop the current route from the Navigator stack
            Navigator.pop(context);
          },
        ),
      ),
      body: _SettingsBody(), // remove the const keyword
    );
  }
}

class _SettingsBody extends StatefulWidget {
  // final Key key;
  // _SettingsBody({this.key}); // remove the const keyword
  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  // create a list of names and numbers as the state
  List<Map<String, String>> namesAndNumbers = [];

  // create a function to show a dialog to add a new name and number
  void showAddDialog(BuildContext context) {
    // create controllers for the name and number input
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    // create a dialog widget
    final dialog = AlertDialog(
      title: const Text('Add a new name and number'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // create a text field for the name input
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          // create a text field for the number input
          TextFormField(
            controller: numberController,
            decoration: const InputDecoration(
              labelText: 'Number',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        // create a cancel button that pops the dialog
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        // create a confirm button that validates the input and adds the new name and number to the list
        ElevatedButton(
          onPressed: () {
            // get the input values
            final name = nameController.text;
            final number = numberController.text;

            // validate the input
            if (name.isNotEmpty && number.isNotEmpty) {
              // add the new name and number to the list
              setState(() {
                namesAndNumbers.add({'name': name, 'number': number});
              });
              // pop the dialog
              Navigator.pop(context);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );

    // show the dialog using the Navigator widget
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // use the WidgetsBinding.instance.addPostFrameCallback method to call the showAddDialog function after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAddDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // override the build method and return a widget that contains the content of the settings page
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // create a list view widget that has a list tile for each name and number pair
          Expanded(
            child: ListView.builder(
              // set the scroll direction to vertical
              scrollDirection: Axis.vertical,
              // set the item count to the length of the list
              itemCount: namesAndNumbers.length,
              // set the item builder to return a list tile widget
              itemBuilder: (context, index) {
                // get the name and number at the current index
                final name = namesAndNumbers[index]['name'];
                final number = namesAndNumbers[index]['number'];

                // return a list tile widget that displays the name and number
                return ListTile(
                  title: Text(name!),
                  subtitle: Text(number!),
                  // create a floating action button that shows the dialog to add a new name and number
                  trailing: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showAddDialog(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
