import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

//signing the user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
      ]),
      body: Center(child: Text("LOGGED IN AS: " + user.email!)),
    );
    */


    return MaterialApp(
      title: 'CUA Survey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Color(0xFF1E215D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E215D),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: Scaffold(
        
        appBar:
        AppBar(
        title: Text('Cua Survey'),
        
      ),
        body: Container(
          alignment: Alignment.center,
          child: const MyHomePage(title: "title"),
        ),
      ),
    );
  }
}
*/
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
    "Activities": ActivitiesSurvey(globalKey: GlobalKey<FormState>()),
    "Food": FoodSurvey(globalKey: GlobalKey<FormState>()),
    "Safety": SafetySurvey(globalKey: GlobalKey<FormState>()),
  };
  Map<String, GlobalKey<FormState>> _formKeys = {
    "Activities": GlobalKey<FormState>(),
    "Food": GlobalKey<FormState>(),
    "Safety": GlobalKey<FormState>(),
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
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
      ]),
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

////////////////////////////////////////////////////////////////////////////////
class ActivitiesSurvey extends StatefulWidget {
  const ActivitiesSurvey({Key? key, required this.globalKey}) : super(key: key);

  final GlobalKey<FormState> globalKey;

  @override
  _ActivitiesSurveyState createState() => _ActivitiesSurveyState();
}

class _ActivitiesSurveyState extends State<ActivitiesSurvey> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _favoriteActivity;
  String? _activityImprovement;
  bool? _moreClubs;
  String? _newClubs;
  bool? _attendEvents;
  String? _eventsPreference;
  bool? _additionalQuestion;
  int? _soccerRating;
  bool _formInvalid = false;

  void sendActivitiesSurveyResponses() {
    // Create a map to hold the activities survey responses
    final Map<String, dynamic> responses = {
      'favoriteActivity': _favoriteActivity,
      'activityImprovement': _activityImprovement,
      'moreClubs': _moreClubs,
      'newClubs': _newClubs,
      'attendEvents': _attendEvents,
      'eventsPreference': _eventsPreference,
      'additionalQuestion': _additionalQuestion,
      'soccerRating': _soccerRating,
    };
    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Activities Survey Responses: $responses');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //////////////////////////////////////Start Q1//////////////////////////////
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
                    text: 'What is your favorite on-campus activity?',
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
                    _favoriteActivity = value;
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
                    text:
                        'Which activity do you think needs improvement? Please provide suggestions.',
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
                    _activityImprovement = value;
                  },
                  validator: _mandatoryValidator,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        //this will give a space between each question card
        //////////////////////////// End Q2/////////////////////////////////////////
        /////////////////////////// Start Q3////////////////////////////////////////
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
                        'Do you believe there should be more clubs and organizations on campus?',
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
                    groupValue: _moreClubs,
                    onChanged: (bool? value) {
                      setState(() {
                        _moreClubs = value;
                      });
                    },
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
                  ),
                  Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: _moreClubs,
                    onChanged: (bool? value) {
                      setState(() {
                        _moreClubs = value;
                      });
                    },
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
                  ),
                  Text('No'),
                ],
              ),
              if (_moreClubs == true)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'What does CUA need to add?',
                    ),
                    onChanged: (value) {
                      _newClubs = value;
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 20),
        //this will give a space between each question card
        //////////////////////////// End Q3/////////////////////////////////////////
        ////////////////////////////// Start Q4/////////////////////////////////////
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
                            'Would you be interested in attending more events or workshops related to personal and professional development?',
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
                  ),
                  Text('No'),
                ],
              ),
              if (_attendEvents == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText:
                          'What type of events or workshops would you like to attend?',
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
        ///////////////////////////// End Q4////////////////////////////////////////
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Rate the activity at CUA From 1 - 10',
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
                          _soccerRating = i + 1;
                        });
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: _soccerRating == i + 1
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
                              color: _soccerRating == i + 1
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

        ////////////////////////////// End Q5///////////////////////////////////////
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Is there any question you want to add to this activity survey?',
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
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
            if (_favoriteActivity == null ||
                _activityImprovement == null ||
                _moreClubs == null ||
                (_moreClubs == true && _newClubs == null) ||
                _attendEvents == null ||
                (_attendEvents == true && _eventsPreference == null) ||
                _additionalQuestion == null ||
                (_additionalQuestion == true && _soccerRating == null)) {
              setState(() {
                _formInvalid = true;
              });
            } else {
              setState(() {
                _formInvalid = false;
              });
              if (_formKey.currentState!.validate()) {
                sendActivitiesSurveyResponses();
                setState(() {
                  _favoriteActivity = null;
                  _activityImprovement = null;
                  _moreClubs = null;
                  _newClubs = null;
                  _attendEvents = null;
                  _eventsPreference = null;
                  _additionalQuestion = null;
                  _soccerRating = null;
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
    );
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
  String? _improveFood;
  bool? _enoughRestaurants;
  String? _restaurantSuggestions;
  bool? _interestedInFood;
  bool? _foodPreferences;
  int? _tasteRating;
  bool? _additionalQuestion;

  String? _mandatoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //////////////////////////////Start Q1//////////////////////////////////////
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
                child: RichText(
                  text: TextSpan(
                    text:
                        'What things does CUA need to improve the food at the campus?',
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
                    _improveFood = value;
                  },
                  validator: _mandatoryValidator,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        ///////////////////////////////Start Q2/////////////////////////////////////
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
                child: RichText(
                  text: TextSpan(
                    text:
                        'What things does CUA need to improve the food at the campus?',
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
                    _improveFood = value;
                  },
                  validator: _mandatoryValidator,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        ////////////////////////////////Start Q3////////////////////////////////////
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
                child: RichText(
                  text: TextSpan(
                    text:
                        'Would you be interested in purchasing food from a group of students who make their own food and sell it on campus once a week?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '*',
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
                    groupValue: _interestedInFood,
                    onChanged: (bool? value) {
                      setState(() {
                        _interestedInFood = value;
                      });
                    },
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
                  ),
                  Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: _interestedInFood,
                    onChanged: (bool? value) {
                      setState(() {
                        _interestedInFood = value;
                      });
                    },
                    activeColor: Color(0xFFA94021),
                  ),
                  Text('No'),
                ],
              ),
              if (_interestedInFood == true)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'What type of food would you like to see?',
                    ),
                    onChanged: (value) {
                      _foodPreferences = value as bool?;
                    },
                    validator: _mandatoryValidator,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 15),

        ////////////////////////////////Start Q4////////////////////////////////////
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
                    text: 'Rate the food taste at CUA',
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

        /////////////////////////////////Start Q6///////////////////////////////////
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
                            'Is there any question you want to add to this activity survey?',
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
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
                    activeColor:
                        Color(0xFFA94021), //this for coloring the answer circle
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
        SizedBox(height: 30),
      ],
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

  // Function to send safety survey responses to the admin
  void sendSafetySurveyResponses() {
    // Create a map to hold the safety survey responses
    final Map<String, dynamic> responses = {
      'feelSafe': _feelSafe,
      'securityConcerns': _securityConcerns,
    };
    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Safety Survey Responses: $responses');
  }

  // Function to send personal and professional development survey responses to the admin
  void sendPersonalProfessionalDevSurveyResponses() {
    // Create a map to hold the personal and professional development survey responses
    final Map<String, dynamic> responses = {
      'attendEvents': _unsafeReason,
      'eventsPreference': _goodPlace,
    };
    // Send the responses to the admin using a method like HTTP POST or Firebase
    // For the sake of simplicity, we'll just print the responses here
    print('Personal and Professional Development Survey Responses: $responses');
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
          ElevatedButton(
            onPressed: () {
              if (_feelSafe == null ||
                  _goodPlace == null ||
                  _safetyRating == null) {
                setState(() {
                  _formInvalid = true;
                });
              } else {
                setState(() {
                  _formInvalid = false;
                });
                if (_formKey.currentState!.validate()) {
                  sendSafetySurveyResponses();
                  sendPersonalProfessionalDevSurveyResponses();
                  setState(() {
                    _feelSafe = null;
                    _securityConcerns = null;
                    _goodPlace = null;
                    _unsafeReason = null;
                    _safetyRating = null;
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
