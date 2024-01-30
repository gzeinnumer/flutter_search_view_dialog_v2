// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.highContrastLight(primary: Colors.red, onPrimary: Colors.red),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          backgroundColor: Colors.red,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var list = <ItemOptionModel>[
    ItemOptionModel(unique: 1, text: "Data 1 Data 1 Data 1 Data1 Data 1 Data 1 Data 1 Data 1 ", fullData: ""),
    ItemOptionModel(unique: 2, text: "Data 2", fullData: ""),
    ItemOptionModel(unique: 3, text: "Data 3", fullData: ""),
    ItemOptionModel(unique: 4, text: "Data 4", fullData: ""),
    ItemOptionModel(unique: 5, text: "Data 5", fullData: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Dialog Select Example'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          color: Colors.red.withOpacity(0.3),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  optionDialog(
                      context: context,
                      title: "Title",
                      subtitle: "Subtitle",
                      enableFilter: true,
                      list: list,
                      singleSelect: false,
                      action: Icon(Icons.file_copy_sharp, color: Theme.of(context).primaryColor),
                      actionOnTap: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(value.text.toString()),
                        ));
                      }).then((value) {
                    if (value != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(value.length.toString()),
                      ));
                    }
                  });
                },
                child: const Text('Open Dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<ItemOptionModel>?> optionDialog({
    required BuildContext context,
    double padding = 10,
    String title = "This is title",
    String subtitle = "This is subtitle",
    bool enableFilter = true,
    bool enableCounter = false,
    bool singleSelect = true,
    List<ItemOptionModel> list = const [],
    Widget? action,
    required Null Function(ItemOptionModel value) actionOnTap,
  }) async {
    final TextEditingController searchController = TextEditingController();
    List<ItemOptionModel> filteredOptions = List.from(list);
    list.insert(0, ItemOptionModel());
    return showDialog<List<ItemOptionModel>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: title.isNotEmpty || subtitle.isNotEmpty || enableFilter
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty) Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                        if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 12),
                        if (enableFilter)
                          TextFormField(
                            controller: searchController,
                            onChanged: (query) {
                              setState(() {
                                filteredOptions = list.where((option) => option.text.toLowerCase().contains(query.toLowerCase())).toList();
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Search...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: BorderSide.none),
                              prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Container(height: 2, color: Theme.of(context).primaryColor.withOpacity(0.3)),
                        if (enableCounter == false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${filteredOptions.length} / ${list.length}", textAlign: TextAlign.end, style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                      ],
                    )
                  : null,
              content: SizedBox(
                width: double.maxFinite,
                child: filteredOptions.isEmpty
                    ? Container(
                        width: double.maxFinite,
                        height: 40,
                        padding: EdgeInsets.all(padding),
                        margin: EdgeInsets.only(bottom: padding / 2, top: padding / 2),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        ),
                        child: const Center(child: Text('No data found')),
                      )
                    : ListView.builder(
                        itemCount: filteredOptions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(padding),
                              margin: EdgeInsets.only(
                                bottom: index == filteredOptions.length - 1 ? 0 : padding / 2,
                                top: index > 0 ? padding / 2 : 0,
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              ),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (singleSelect) Icon(filteredOptions[index].selected ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).primaryColor) else Icon(filteredOptions[index].selected ? Icons.check_box : Icons.check_box_outline_blank, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: Text(filteredOptions[index].text, maxLines: 100, overflow: TextOverflow.ellipsis),
                                  ),
                                  if (action != null) const SizedBox(width: 8),
                                  if (action != null)
                                    GestureDetector(
                                      child: action,
                                      onTap: () {
                                        actionOnTap(filteredOptions[index]);
                                      },
                                    ),
                                  if (action != null) const SizedBox(width: 2)
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (singleSelect) {
                                  for (int i = 0; i < filteredOptions.length; i++) {
                                    filteredOptions[i].selected = false;
                                  }
                                }
                                filteredOptions[index].selected = !filteredOptions[index].selected;
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    List<ItemOptionModel> selectedOptions = filteredOptions.where((option) => option.selected).toList();
                    Navigator.pop(context, selectedOptions);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ItemOptionModel {
  final unique;
  final text;
  final fullData;
  var selected;

  ItemOptionModel({
    this.unique = 0,
    this.text = "",
    this.fullData,
    this.selected = false,
  });
}
