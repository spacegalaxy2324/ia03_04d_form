// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ColorScheme appColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp(
      title: 'M08 - Form (C)',
      theme: ThemeData(
        colorScheme: appColorScheme,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.all(10)),
        chipTheme: ChipThemeData(
            backgroundColor: appColorScheme.primary,
            labelStyle: TextStyle(color: appColorScheme.onPrimary),
            secondaryLabelStyle: TextStyle(color: appColorScheme.onSecondary),
            showCheckmark: false,
            selectedColor: appColorScheme.secondary,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Adrián López Villalba';
  final _formKey = GlobalKey<FormBuilderState>();
  var _curLength = 0;
  final _maxLength = 7;

  static const allCountries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'American Samoa',
    'Andorra',
    'Angola',
    'Anguilla',
    'Antarctica',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Aruba',
    'Australia',
    'Austria',
    'Azerbaijan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      //-------------------------------------------------
                      SizedBox(height: 20),
                      FormBuilderTypeAhead<String>(
                        decoration: const InputDecoration(
                          labelText: 'Autocomplete',
                          hintText: 'Start typing country name',
                        ),
                        name: 'autocomplete',
                        onChanged: (value) {
                          debugPrint(value.toString());
                        },
                        itemBuilder: (context, country) {
                          return ListTile(title: Text(country));
                        },
                        controller: TextEditingController(text: ''),
                        suggestionsCallback: (query) {
                          if (query.isNotEmpty) {
                            var lowercaseQuery = query.toLowerCase();
                            return allCountries.where((country) {
                              return country
                                  .toLowerCase()
                                  .contains(lowercaseQuery);
                            }).toList(growable: false);
                          } else {
                            return allCountries;
                          }
                        },
                      ),
                      //-------------------------------------------------
                      SizedBox(height: 20),
                      FormBuilderDateTimePicker(
                        decoration: const InputDecoration(
                            labelText: 'Date Picker',
                            hintText: 'Day, Month 1, 20XX',
                            suffixIcon: Icon(Icons.calendar_month)),
                        name: 'date',
                        inputType: InputType.date,
                        format: DateFormat("EEEE, MMMM d, yyyy"),
                      ),
                      //-------------------------------------------------
                      SizedBox(height: 20),
                      FormBuilderDateRangePicker(
                        name: 'date_range',
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2030),
                        format: DateFormat('yyyy-MM-dd'),
                        onChanged: (value) {
                          debugPrint(value.toString());
                        },
                        decoration: InputDecoration(
                          labelText: 'Date Range',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['date_range']
                                  ?.didChange(null);
                            },
                          ),
                        ),
                      ),
                      //-------------------------------------------------
                      SizedBox(height: 20),
                      FormBuilderDateTimePicker(
                        decoration: const InputDecoration(
                            labelText: 'Time Picker',
                            hintText: 'XX:YY AM',
                            suffixIcon: Icon(Icons.access_time)),
                        name: 'time',
                        inputType: InputType.time,
                        format: DateFormat("hh:mm a"),
                      ),
                      //-------------------------------------------------
                      SizedBox(height: 20),
                      FormBuilderFilterChip(
                        alignment: WrapAlignment.spaceEvenly,
                        decoration: const InputDecoration(
                            labelText: 'Input Chips (Filter Chip)',
                            contentPadding: EdgeInsets.all(20.0)),
                        name: 'filter_chip',
                        options: const [
                          FormBuilderChipOption(value: 'HTML'),
                          FormBuilderChipOption(value: 'CSS'),
                          FormBuilderChipOption(value: 'React'),
                          FormBuilderChipOption(value: 'Dart'),
                          FormBuilderChipOption(value: 'TypeScript'),
                          FormBuilderChipOption(value: 'Angular'),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload),
          onPressed: () {
            _formKey.currentState?.saveAndValidate();
            String? formString = _formKey.currentState?.value.toString();
            alertDialog(context, formString!);
          }),
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: Icon(Icons.check_circle),
      title: const Text('Submission complete'),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Tancar'),
          child: const Text('Tancar'),
        ),
      ],
    ),
  );
}
