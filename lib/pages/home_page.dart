import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedSurveyType;

  final user = FirebaseAuth.instance.currentUser!;

//signing the user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Map<String, Widget> _surveyTypes = {
    "Class": ActivitiesSurvey(globalKey: GlobalKey<FormState>()),
    "Food": FoodSurvey(globalKey: GlobalKey<FormState>()),
    "Safety": SafetySurvey(globalKey: GlobalKey<FormState>()),
    "Sports": SportsSurvey(globalKey: GlobalKey<FormState>()),
  };
  Map<String, GlobalKey<FormState>> _formKeys = {
    "Class": GlobalKey<FormState>(),
    "Food": GlobalKey<FormState>(),
    "Safety": GlobalKey<FormState>(),
    "Sports": GlobalKey<FormState>(),
  };

  void _submitSurveyResponses() {
    bool isValid = true;
    Map<String, dynamic> responses = {};

    // Loop through all survey types and collect the responses
    _surveyTypes.forEach((key, value) {
      GlobalKey<FormState> formKey = _formKeys[key]!;
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        isValid = false;
        return;
      }
      responses[key] = formKey.currentState!.validate();
    });

    if (isValid) {
      // TODO: Send the responses to the admin
      print(responses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
        backgroundColor: Color(0xffb41428),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose the survey type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: _selectedSurveyType,
                        hint: const Text("Select Survey Type"),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSurveyType = newValue;
                          });
                        },
                        items: _surveyTypes.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedSurveyType != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _surveyTypes[_selectedSurveyType]!,
              ),
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? _selectedSurveyType; // Define selected survey type

  Map<String, Widget> _surveyTypes = {
    "Activities": ActivitiesSurvey(globalKey: GlobalKey<FormState>()),
    "Food": FoodSurvey(globalKey: GlobalKey<FormState>()),
    "Safety": SafetySurvey(globalKey: GlobalKey<FormState>()),
    "Courses": CoursesSurvey(globalKey: GlobalKey<FormState>()),
    "Sports": SportsSurvey(globalKey: GlobalKey<FormState>()),
  };
  Map<String, GlobalKey<FormState>> _formKeys = {
    "Activities": GlobalKey<FormState>(),
    "Food": GlobalKey<FormState>(),
    "Safety": GlobalKey<FormState>(),
    "Courses": GlobalKey<FormState>(),
    "Sports": GlobalKey<FormState>(),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose the survey type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black54,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: _selectedSurveyType, // Use selected survey type
                      hint: const Text("Select Survey Type"),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSurveyType =
                              newValue; // Update selected survey type
                        });
                      },
                      items: _surveyTypes.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedSurveyType != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getSurveyWidget(_selectedSurveyType!),
            ),
        ],
      ),
    );
  }

  Widget _getSurveyWidget(String surveyType) {
    switch (surveyType) {
      case 'Activities':
        return ActivitiesSurvey(globalKey: GlobalKey<FormState>());
      case 'Food':
        return FoodSurvey(globalKey: GlobalKey<FormState>());
      case 'Safety':
        return SafetySurvey(globalKey: GlobalKey<FormState>());
      case 'Courses':
        return CoursesSurvey(globalKey: GlobalKey<FormState>());
      case 'Sports':
        return SportsSurvey(globalKey: GlobalKey<FormState>());
      default:
        return Container();
    }
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Logout Page',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class ActivitiesSurvey extends StatefulWidget {
  const ActivitiesSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _ActivitiesSurveyState createState() => _ActivitiesSurveyState();
}

class _ActivitiesSurveyState extends State<ActivitiesSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _classNum;
  String? _courseSection;
  String? _professorName;
  bool? _courseSatisfied;
  String? _whatChanges;
  bool? _attendEvents;
  String? _eventsPreference;
  bool? _additionalQuestion;
  int? _classRating;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendActivitySurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'courseSection': _courseSection,
      'professorName': _professorName,
      'courseSatisfied': _courseSatisfied,
      'whatChanges': _whatChanges,
      'attendEvents': _attendEvents,
      'eventsPreference': _eventsPreference,
      'additionalQuestion': _additionalQuestion,
      'classRating': _classRating,
    };
    /* _classNum = null;
                  _courseSection = null;
                  _professorName = null;
                  _courseSatisfied = null;
                  _whatChanges = null;
                  _attendEvents = null;
                  _eventsPreference = null;
                  _additionalQuestion = null;
                  _classRating = null;
                  */

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Food Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1
        .dispose(); //this line to clean Q1 field after click on submit button
    _textEditingController2
        .dispose(); //this line to clean Q2 field after click on submit button
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'What course is the survey for? (Ex. CSC121)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your response here',
                      ),
                      onChanged: (value) {
                        _classNum = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            //this will give a space between each question card
            //////////////////////////////////// END Q1/////////////////////////////////
            /////////////////////////////////Start Q2///////////////////////////////////
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Which course section are you in?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your response here',
                      ),
                      onChanged: (value) {
                        _courseSection = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Who is the professor? (First and Last Name)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your response here',
                      ),
                      onChanged: (value) {
                        _professorName = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            //this will give a space between each question card
            //////////////////////////// End Q3/////////////////////////////////////////
            /////////////////////////// Start Q4////////////////////////////////////////
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        text:
                            'Were you satisfied with what you learned within the course?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _courseSatisfied,
                        onChanged: (bool? value) {
                          setState(() {
                            _courseSatisfied = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('Yes'),
                      Radio<bool>(
                        value: false,
                        groupValue: _courseSatisfied,
                        onChanged: (bool? value) {
                          setState(() {
                            _courseSatisfied = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('No'),
                    ],
                  ),
                  if (_courseSatisfied == false)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'What needs to be changed?',
                        ),
                        onChanged: (value) {
                          _whatChanges = value;
                        },
                        validator: _mandatoryValidator,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            //this will give a space between each question card
            //////////////////////////// End Q4/////////////////////////////////////////
            ////////////////////////////// Start Q5/////////////////////////////////////
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Would you be interested in attending similar courses after your experience with this one?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _attendEvents,
                        onChanged: (bool? value) {
                          setState(() {
                            _attendEvents = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('Yes'),
                      Radio<bool>(
                        value: false,
                        groupValue: _attendEvents,
                        onChanged: (bool? value) {
                          setState(() {
                            _attendEvents = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('No'),
                    ],
                  ),
                  if (_attendEvents == false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Why not?',
                        ),
                        onChanged: (value) {
                          _eventsPreference = value;
                        },
                        validator: _mandatoryValidator,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ///////////////////////////// End Q5////////////////////////////////////////
            ////////////////////////////// Start Q6/////////////////////////////////////
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Rate your experience with this class 1-10',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        10,
                        (i) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _classRating = i + 1;
                            });
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: _classRating == i + 1
                                  ? Colors.redAccent
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _classRating == i + 1
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ////////////////////////////// End Q6///////////////////////////////////////
            ////////////////////////////// Start Q7/////////////////////////////////////
            Card(
              color: Color(0xFFFBF8F6),
              margin: EdgeInsets.all(8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Are there any questions you would want to add to this course survey?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _additionalQuestion,
                        onChanged: (bool? value) {
                          setState(() {
                            _additionalQuestion = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('Yes'),
                      Radio<bool>(
                        value: false,
                        groupValue: _additionalQuestion,
                        onChanged: (bool? value) {
                          setState(() {
                            _additionalQuestion = value;
                          });
                        },
                        activeColor: Color(
                            0xFFA94021), //this for coloring the answer circle
                      ),
                      Text('No'),
                    ],
                  ),
                  if (_additionalQuestion == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter your question here',
                        ),
                        onChanged: (value) {
                          _additionalQuestion = value as bool?;
                        },
                        validator: _mandatoryValidator,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 15),
            ////////////////////////////// End Q6///////////////////////////////////////
            ElevatedButton(
              onPressed: () {
                if (_classNum == null ||
                    _courseSection == null ||
                    _courseSatisfied == null ||
                    (_courseSatisfied == false && _whatChanges == null) ||
                    _attendEvents == null ||
                    (_attendEvents == true && _eventsPreference == null) ||
                    _additionalQuestion == null ||
                    (_additionalQuestion == true && _classRating == null)) {
                  setState(() {
                    _formInvalid = true;
                  });
                } else {
                  setState(() {
                    _formInvalid = false;
                  });
                  if (_formKey.currentState!.validate()) {
                    //sendActivitiesSurveyResponses();
                    setState(() {
                      _classNum = null;
                      _courseSection = null;
                      _professorName = null;
                      _courseSatisfied = null;
                      _whatChanges = null;
                      _attendEvents = null;
                      _eventsPreference = null;
                      _additionalQuestion = null;
                      _classRating = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for completing the survey!'),
                      ),
                    );
                  }
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF262525),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Color(0xFFA19999), width: 2),
                ),
              ),
            ),
            if (_formInvalid)
              Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Please complete all mandatory questions.',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
          ],
        ));
  }
}

String? _mandatoryValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

////////////////////////////////////////////////////////////////////////////////
class FoodSurvey extends StatefulWidget {
  const FoodSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _FoodSurveyState createState() => _FoodSurveyState();
}

class _FoodSurveyState extends State<FoodSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _improveFood;
  String? _DiningCustomerServices;
  bool? _enoughRestaurants;
  String? _foodPreferences;
  int? _tasteRating;
  bool? _additionalQuestion;
  String? _additionalFoodQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendFoodSurveyResponses() async {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'ImproveFood': _improveFood,
      'DiningCustomerServices': _DiningCustomerServices,
      'EnoughRestaurant': _enoughRestaurants,
      'FoodPreferences': _foodPreferences,
      'TasteRating': _tasteRating,
      'additionalQuestion': _additionalQuestion,
      'UserAdditionFoodQuestion': _additionalFoodQuestion,
    };

    // Convert the map of responses to a JSON string
    final String jsonBody = json.encode(responses);

    // Send the responses to the server using HTTP POST
    final url = Uri.parse('https://surveyapp-f64f6-default-rtdb.firebaseio.com/food-survey-responses.json');
    final response = await http.post(url, body: jsonBody);

    // Check the response status code to see if the request was successful
    if (response.statusCode == 200) {
      // Print the response body
      print(response.body);
    } else {
      // Handle the error
      print('Error sending survey responses: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1
        .dispose(); //this line to clean Q1 field after click on submit button
    _textEditingController2
        .dispose(); //this line to clean Q2 field after click on submit button
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'What does CUA need to do to improve the dining experience on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _improveFood = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Describe your last dining experience in a short sentence',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _DiningCustomerServices = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Are there enough food options on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _enoughRestaurants,
                      onChanged: (bool? value) {
                        setState(() {
                          _enoughRestaurants = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _enoughRestaurants,
                      onChanged: (bool? value) {
                        setState(() {
                          _enoughRestaurants = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_enoughRestaurants == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText:
                            'What other kind of food would you like to see?',
                      ),
                      onChanged: (value) {
                        _foodPreferences = value;
                      },
                      validator:
                          _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate Garvey Halls food taste From 1 - 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _tasteRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _tasteRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _tasteRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Are there any questions you want to add to this dining survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalFoodQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_improveFood == null ||
                  _DiningCustomerServices == null ||
                  _enoughRestaurants == null ||
                  _tasteRating == null ||
                  _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendFoodSurveyResponses();
                  setState(() {
                    _improveFood = null;
                    _DiningCustomerServices = null;
                    _enoughRestaurants = null;
                    _tasteRating = null;
                    _additionalQuestion = null;
                    _additionalFoodQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class SafetySurvey extends StatefulWidget {
  const SafetySurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _SafetySurveyState createState() => _SafetySurveyState();
}

class _SafetySurveyState extends State<SafetySurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? _feelSafe;
  String? _securityConcerns;
  bool? _goodPlace;
  String? _unsafeReason;
  bool _formInvalid = false;
  int? _safetyRating;
  bool? _additionalQuestion;
  String? _additionalSafetyQuestion;
  TextEditingController _textEditingController = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendSafetySurveyResponses() async {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'feelSafe': _feelSafe,
      'securityConcerns': _securityConcerns,
      'goodPlace': _goodPlace,
      'unsafeReason': _unsafeReason,
      'safetyRating': _safetyRating,
      'additionalQuestion': _additionalQuestion,
      'UserAdditionSafetyQuestion': _additionalSafetyQuestion,
    };

    // Convert the map of responses to a JSON string
    final String jsonBody = json.encode(responses);

    // Send the responses to the server using HTTP POST
    final url = Uri.parse('https://surveyapp-f64f6-default-rtdb.firebaseio.com/safety-survey-responses.json');
    final response = await http.post(url, body: jsonBody);

    // Check the response status code to see if the request was successful
    if (response.statusCode == 200) {
      // Print the response body
      print(response.body);
    } else {
      // Handle the error
      print('Error sending survey responses: ${response.statusCode}');
    }
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text: 'Do you feel safe on campus?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _feelSafe,
                      onChanged: (bool? value) {
                        setState(() {
                          _feelSafe = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _feelSafe,
                      onChanged: (bool? value) {
                        setState(() {
                          _feelSafe = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_feelSafe == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What are your security concerns?',
                      ),
                      onChanged: (value) {
                        _securityConcerns = value;
                      },
                      validator:
                          _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Is CUA a good place for students to live?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _goodPlace,
                      onChanged: (bool? value) {
                        setState(() {
                          _goodPlace = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _goodPlace,
                      onChanged: (bool? value) {
                        setState(() {
                          _goodPlace = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_goodPlace == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText:
                            'What are your concerns about living on campus?',
                      ),
                      onChanged: (value) {
                        _unsafeReason = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate the safety at CUA From 1 - 10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _safetyRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _safetyRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _safetyRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Are there any questions you want to add to this safety survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalSafetyQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_feelSafe == null ||
                  _goodPlace == null ||
                  _safetyRating == null ||
                  _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendSafetySurveyResponses();
                  setState(() {
                    _feelSafe = null;
                    _securityConcerns = null;
                    _goodPlace = null;
                    _unsafeReason = null;
                    _safetyRating = null;
                    _additionalQuestion = null;
                    _textEditingController.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class CoursesSurvey extends StatefulWidget {
  const CoursesSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _CoursesSurveyState createState() => _CoursesSurveyState();
}

class _CoursesSurveyState extends State<CoursesSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _classNum;
  String? _courseSection;
  String? _professorName;
  bool? _courseSatisfied;
  String? _whatChanges;
  int? _classRating;
  bool? _additionalQuestion;
  String? _additionalCoursesQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // Function to send courses survey responses to the admin
  void sendCoursesSurveyResponses() async {
    // Create a map to hold the courses survey responses
    final Map<String, dynamic> responses = {
      'ClassNumber': _classNum,
      'CourseSection': _courseSection,
      'ProfessorName': _professorName,
      'CourseSatisfied': _courseSatisfied,
      'WhatChanges': _whatChanges,
      'ClassRating': _classRating,
      'additionalCourseQuestion': _additionalQuestion,
      'UserAdditionCoursesQuestion': _additionalCoursesQuestion,
    };

    // Convert the map of responses to a JSON string
    final String jsonBody = json.encode(responses);

    // Send the responses to the server using HTTP POST
    final url = Uri.parse('https://surveyapp-f64f6-default-rtdb.firebaseio.com/courses-survey-responses.json');
    final response = await http.post(url, body: jsonBody);

    // Check the response status code to see if the request was successful
    if (response.statusCode == 200) {
      // Print the response body
      print(response.body);
    } else {
      // Handle the error
      print('Error sending survey responses: ${response.statusCode}');
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What course is the survey for? (Ex. CSC121)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _classNum = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Which course section are you in?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _courseSection = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Who is the professor? (First and Last Name)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController3,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _professorName = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      text:
                          'Were you satisfied with what you learned within the course?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _courseSatisfied,
                      onChanged: (bool? value) {
                        setState(() {
                          _courseSatisfied = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _courseSatisfied,
                      onChanged: (bool? value) {
                        setState(() {
                          _courseSatisfied = value;
                        });
                      },
                      activeColor: Color(0xFFA94021),
                    ),
                    Text('No'),
                  ],
                ),
                if (_courseSatisfied == false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'What needs to be changed?',
                      ),
                      onChanged: (value) {
                        _whatChanges = value;
                      },
                      validator:
                          _mandatoryValidator, // pass the validator function here
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Rate your experience with this class 1-10',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _classRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _classRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _classRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Are there any questions you would want to add to this course survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalCoursesQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_classNum == null ||
                  _courseSection == null ||
                  _professorName == null ||
                  _courseSatisfied == null ||
                  _classRating == null ||
                  _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendCoursesSurveyResponses();
                  setState(() {
                    _classNum = null;
                    _courseSection = null;
                    _professorName = null;
                    _courseSatisfied = null;
                    _whatChanges = null;
                    _classRating = null;
                    _additionalQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                    _textEditingController3.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class SportsSurvey extends StatefulWidget {
  const SportsSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _SportsSurveyState createState() => _SportsSurveyState();
}

class _SportsSurveyState extends State<SportsSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _SportPlay;
  String? _Year;
  int? _lockerRating;
  int? _coachesRating;
  int? _knowledgeRating;
  String? _accessibleToTalk;
  int? _trainingStuffRating;
  bool? _additionalQuestion;
  String? _additionalSportsQuestion;
  bool _formInvalid = false;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();

  // Function to send safety survey responses to the admin
  void sendCoursesSurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'SportPlay': _SportPlay,
      'YearGrade': _Year,
      'LockerRating': _lockerRating,
      'CoachesRating': _coachesRating,
      'KnowledgeRating': _knowledgeRating,
      'AccessibleToTalk': _accessibleToTalk,
      'TrainingStuff': _trainingStuffRating,
      'additionalCourseQuestion': _additionalQuestion,
      'UserAdditionSportsQuestion': _additionalSportsQuestion,
    };

    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Sports Survey Responses: $responses');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What sport do you play?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _SportPlay = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'What year are you?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _Year = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How would you rate your locker room (1-10)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _lockerRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _lockerRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _lockerRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How would you rate your coaches?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _coachesRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _coachesRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _coachesRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'How would you rate your coaches knowledge of the game?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _knowledgeRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _knowledgeRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _knowledgeRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Are they accessible to talk?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _textEditingController3,
                    decoration: InputDecoration(
                      hintText: 'Enter your response here',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _accessibleToTalk = value;
                      });
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How is the training staff?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (i) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _trainingStuffRating = i + 1;
                          });
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _trainingStuffRating == i + 1
                                ? Colors.redAccent
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _trainingStuffRating == i + 1
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Card(
            color: Color(0xFFFBF8F6),
            margin: EdgeInsets.all(8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Are there any questions you would want to add to the sports survey?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _additionalQuestion,
                      onChanged: (bool? value) {
                        setState(() {
                          _additionalQuestion = value;
                        });
                      },
                      activeColor: Color(
                          0xFFA94021), //this for coloring the answer circle
                    ),
                    Text('No'),
                  ],
                ),
                if (_additionalQuestion == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your question here',
                      ),
                      onChanged: (value) {
                        _additionalSportsQuestion = value;
                      },
                      validator: _mandatoryValidator,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (_SportPlay == null ||
                  _Year == null ||
                  _accessibleToTalk == null ||
                  _lockerRating == null ||
                  _coachesRating == null ||
                  _knowledgeRating == null ||
                  _trainingStuffRating == null ||
                  _additionalQuestion == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });

                if (_formKey.currentState!.validate()) {
                  sendCoursesSurveyResponses();
                  setState(() {
                    _SportPlay = null;
                    _Year = null;
                    _lockerRating = null;
                    _coachesRating = null;
                    _accessibleToTalk = null;
                    _knowledgeRating = null;
                    _trainingStuffRating = null;
                    _additionalQuestion = null;
                    _textEditingController1.text = '';
                    _textEditingController2.text = '';
                    _textEditingController3.text = '';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for completing the survey!'),
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF262525),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color(0xFFA19999), width: 2),
              ),
            ),
          ),
          if (_formInvalid)
            Column(
              children: [
                SizedBox(height: 16),
                Text(
                  'Please complete all mandatory questions.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
