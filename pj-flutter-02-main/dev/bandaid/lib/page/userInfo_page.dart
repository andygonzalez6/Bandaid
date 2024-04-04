import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/components/input_field.dart';
import 'package:bandaid/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/utils/user_functions.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<UserInfoPage> createState() {
    return _UserInfoPageState();
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController preferenceController = TextEditingController();

  int currentStep = 0;
  List<String> genres = [];
  List<String> instruments = [];

  Color bordertextColor = const Color(0xff6D28D9);
  Color selectedColor = const Color.fromARGB(232, 228, 54, 205);
  Color stepperColor = const Color(0xff6D28D9);

  @override
  void initState() {
    super.initState();
    _fetchGenres();
    _fetchInstruments();
  }

  void _fetchGenres() async {
    List<String> fetchedGenres = await getData("genres");
    setState(() {
      genres = fetchedGenres;
    });
  }

  void _fetchInstruments() async {
    List<String> fetchedInstruments = await getData("instruments");
    setState(() {
      instruments = fetchedInstruments;
    });
  }

  List<bool> isGenreSelected = List.filled(15, false);
  List<bool> isInstrumentSelected = List.filled(13, false);

  List<Step> steps() => [
        Step(
            isActive: currentStep >= 0,
            title: const Text(""),
            content: Wrap(
              children: [
                Text("Let's Get Started!", style: TextStyle(fontSize: 20.sp)),
                TextInputField(
                  inputController: nameController,
                  obscureText: false,
                  hintText: "Enter your first name...",
                  labelText: "First Name",
                ),
                TextInputField(
                  inputController: lastnameController,
                  obscureText: false,
                  hintText: "Enter your last name...",
                  labelText: "Last Name",
                ),
              ],
            )),
        Step(
            isActive: currentStep >= 1,
            title: const Text(""),
            content: Wrap(
              children: [
                Text("Where are you located?", style: TextStyle(fontSize: 20.sp)),
                TextInputField(
                  inputController: addressController,
                  obscureText: false,
                  hintText: "Enter your address",
                  labelText: "Address",
                ),
              ],
            )),
        Step(
            isActive: currentStep >= 2,
            title: const Text(""),
            content: Wrap(children: [
              Text("What's your title?", style: TextStyle(fontSize: 20.sp)),
              TextInputField(
                inputController: titleController,
                obscureText: false,
                hintText: "eg. Producer, Guitarist..",
                labelText: "Title",
              ),
            ])),
        Step(
            isActive: currentStep >= 3,
            title: const Text(""),
            content: Wrap(
              children: [
                Text("Tell us about yourself!", style: TextStyle(fontSize: 20.sp)),
                TextInputField(
                  inputController: descriptionController,
                  obscureText: false,
                  hintText: "I am...",
                  labelText: "Description",
                ),
              ],
            )),
        Step(
          isActive: currentStep >= 4,
          title: const Text(''),
          content: Column(
            children: [
               SizedBox(
                height: 1.h,
              ),
              Text("Select your favorite genres!", style: TextStyle(fontSize: 20.sp)),
              SizedBox(
                height: 3.h,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(genres.length, (index) {
                  return InputChip(
                    showCheckmark: false,
                    label: Text(genres[index]),
                    selected: isGenreSelected[index],
                    onSelected: (selected) {
                      setState(() {
                        isGenreSelected[index] = selected;
                      });
                    },
                    pressElevation: 0, // Disable elevation when pressed
                    backgroundColor: Colors.transparent,
                    selectedColor: selectedColor,
                    selectedShadowColor: selectedColor,
                    labelStyle: TextStyle(
                      color:
                          isGenreSelected[index] ? Colors.white : bordertextColor,
                      fontSize: 17.sp,
                    ),
                    shadowColor: isGenreSelected[index]
                        ? bordertextColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: bordertextColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    
                  );
                }),
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 5,
          title: const Text(''),
          content: Column(
            children: [
                SizedBox(
                height: 1.h,
              ),
              Text("Select your favorite instruments!", style: TextStyle(fontSize: 20.sp)),
              SizedBox(
                height: 3.h,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<Widget>.generate(instruments.length, (index) {
                  return InputChip(
                    showCheckmark: false,
                    label: Text(instruments[index]),
                    selected: isInstrumentSelected[index],
                    onSelected: (selected) {
                      setState(() {
                        isInstrumentSelected[index] = selected;
                      });
                    },
                    pressElevation: 0, // Disable elevation when pressed
                    backgroundColor: Colors.transparent,
                    selectedColor: selectedColor,
                    selectedShadowColor: selectedColor,
                    labelStyle: TextStyle(
                      color: isInstrumentSelected[index]
                          ? Colors.white
                          : bordertextColor,
                      fontSize: 17.sp,
                    ),
                    shadowColor: isInstrumentSelected[index]
                        ? bordertextColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: bordertextColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(title: "User Details"),
        body: Theme(
            data: ThemeData(
                primarySwatch: Colors.purple,
                colorScheme: ColorScheme.light(
                  primary: stepperColor,
                )),
            child: Stepper(
              steps: steps(),
              currentStep: currentStep,
              type: StepperType.horizontal,
              onStepTapped: (step) {
                setState(() {
                  currentStep = step;
                });
              },
              onStepContinue: () {
                if (currentStep == steps().length - 1) {
                  createUserDetails(
                      nameController.text,
                      lastnameController.text,
                      titleController.text,
                      descriptionController.text,
                      "In Person",
                      addressController.text);
                  postItemsList(isGenreSelected, "genres");
                  postItemsList(isInstrumentSelected, "instruments");
                  nameController.clear();
                  lastnameController.clear();
                  titleController.clear();
                  descriptionController.clear();
                  preferenceController.clear();
                  isGenreSelected = List.filled(15, false);
                  isInstrumentSelected = List.filled(13, false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Homepage()),
                      (route) => false);
                  //send data to server
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () {
                      setState(() {
                        currentStep -= 1;
                      });
                    },
            )));
  }
}

