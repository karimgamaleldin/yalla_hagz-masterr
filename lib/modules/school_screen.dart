import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:yalla_hagz/layout/bottom_nav_screen.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';

import 'payment_screen.dart';

class SchoolScreen extends StatelessWidget {
  var school;
  int currentField = 1000000;
  var dateController = TextEditingController();
  bool dateIsEmpty = true;
  bool fieldIsEmpty = true;
  bool notify = false;
  bool buildListView = false;
  String day = "";
  List<List<int>> timeTable = [];
  SchoolScreen(this.school);
  List<int> choose = [];
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                navigateAndFinish(context, BottomNavScreen());
              },
            ),
          ),
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        school["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          school["location"],
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                        const Spacer(),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: defaultColor,
                          child: TextButton(
                            onPressed:() {
                            },
                            child: Text(
                              'Map Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    defaultRatingBar(school["rating"]),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "${school["name"]} offers:",
                            style:const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 20,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index) => Text(
                                    "#${school["extras"][index]}",
                                  style: const TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                separatorBuilder: (context,index) => SizedBox(width: 10,),
                                itemCount: school["extras"].length
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Policy: ${school["policy"]}"
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        ConditionalBuilder(
                          condition: currentField != 1000000 ,
                          builder: (context) {
                            return Container(
                              height: 50,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: (currentField == index+1) ? defaultColor : Colors.grey[300],
                                    child: TextButton(
                                      onPressed: () {
                                        currentField = index+1;
                                        cubit.changeField();
                                        if(school["calendar$currentField"][day].length != 1) {
                                          AppCubit.get(context).checkDateInDataBase(date: dateController.text, cityId: AppCubit.get(context).currentCity, schoolId: school["schoolId"], field: currentField.toString(), fees: school["fees"],intervals:school["calendar$currentField"][day]);
                                        }else{
                                          showToast(text: 'No reservations on $day ${dateController.text}', state: ToastStates.WARNING);
                                        }
                                      },
                                      child: Text(
                                        'Field ${index+1}',
                                        style: TextStyle(
                                          color: (currentField == index+1) ? Colors.white : defaultColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context,
                                    index) => const SizedBox(width: 5,),
                                itemCount: school["fields"],
                              ),
                            );
                          },
                          fallback: (context) {
                            return Container(
                              height: 50,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    color: Colors.grey[300],
                                    child: TextButton(
                                      onPressed: () {
                                        currentField = index+1;
                                        cubit.changeField();
                                      },
                                      child: Text(
                                        'Field ${index+1}',
                                        style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(width: 5,),
                                itemCount: school["fields"],
                              ),
                            );
                          },

                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    ConditionalBuilder(
                      condition: currentField != 1000000,
                      builder: (context) {
                        return defaultFormField(
                            controller: dateController,
                            prefix: Icons.date_range,
                            text: 'Choose a Date',
                            onTap: () {
                              // showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime.now(),
                              //   lastDate: DateTime.parse('2030-05-03'),
                              // ).then((value) {
                              //   dateController.text =
                              //       DateFormat.yMMMd().format(value!);
                              showRoundedDatePicker(
                                  context: context,
                                  // theme: ThemeData(primarySwatch: Colors.deepPurple),
                                  styleDatePicker: MaterialRoundedDatePickerStyle(
                                    textStyleDayButton:
                                    const TextStyle(fontSize: 36, color: Colors.white),
                                    textStyleYearButton: const TextStyle(
                                      fontSize: 52,
                                      color: Colors.white,
                                    ),
                                    textStyleDayHeader: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                    textStyleCurrentDayOnCalendar: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textStyleDayOnCalendar:
                                    const TextStyle(fontSize: 28, color: Colors.white),
                                    textStyleDayOnCalendarSelected: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textStyleDayOnCalendarDisabled: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white.withOpacity(0.1)),
                                    textStyleMonthYearHeader: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    paddingDatePicker: const EdgeInsets.all(0),
                                    paddingMonthHeader: const EdgeInsets.all(32),
                                    paddingActionBar: const EdgeInsets.all(16),
                                    paddingDateYearHeader: const EdgeInsets.all(32),
                                    sizeArrow: 50,
                                    colorArrowNext: Colors.white,
                                    colorArrowPrevious: Colors.white,
                                    marginLeftArrowPrevious: 16,
                                    marginTopArrowPrevious: 16,
                                    marginTopArrowNext: 16,
                                    marginRightArrowNext: 32,
                                    textStyleButtonAction:
                                    const TextStyle(fontSize: 28, color: Colors.white),
                                    textStyleButtonPositive: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textStyleButtonNegative: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white.withOpacity(0.5)),
                                    decorationDateSelected: BoxDecoration(
                                        color: Colors.orange[600],
                                        shape: BoxShape.circle),
                                    backgroundPicker: defaultColor,
                                    backgroundActionBar: defaultColor,
                                    backgroundHeaderMonth: defaultColor,
                                  ),
                                  styleYearPicker: MaterialRoundedYearPickerStyle(
                                    textStyleYear:
                                    const TextStyle(fontSize: 40, color: Colors.white),
                                    textStyleYearSelected: const TextStyle(
                                        fontSize: 56,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    heightYearRow: 100,
                                    backgroundPicker: defaultColor,
                                  )).then((value) {
                                day = AppCubit.get(context).dateToDay(date: value.toString());
                                dateController.text = DateFormat.yMMMd().format(value!);
                                // print(TimeOfDay.now().hour);
                                // if(value==DateTime.now()&&school["calendar"][day][0]<TimeOfDay.now())
                                //   timeTable = AppCubit.get(context).createTimeTable(startTime: TimeOfDay.now().hour+1, endTime: school["calendar"][day][1]);
                                // else
                                // timeTable = AppCubit.get(context).createTimeTable(startTime: school["calendar"][day][0], endTime: school["calendar"][day][1]);
                                if(school["calendar$currentField"][day].length != 1) {
                                  AppCubit.get(context).checkDateInDataBase(date: dateController.text, cityId: AppCubit.get(context).currentCity, schoolId: school["schoolId"], field: currentField.toString(), fees: school["fees"],intervals:school["calendar$currentField"][day]);
                                }else{
                                  showToast(text: 'No reservations on $day ${dateController.text}', state: ToastStates.WARNING);
                                }
                                AppCubit.get(context).changeDate();
                              });

                            });
                      }, fallback: (BuildContext context) {
                      return Container();
                    },
                    ),
                    const SizedBox(height: 10),
                    ConditionalBuilder(
                      condition: dateController.text.isNotEmpty&&school["calendar$currentField"][day].length != 1,
                      builder: (context) => Column(
                        children: [
                          const Text('Times:'),
                          ConditionalBuilder(
                            condition: state is! AppGetBookingTimeLoadingState&&state is! AppCreateBookingTimeLoadingState&&AppCubit.get(context).startTimes.isNotEmpty,
                            builder: (context) {
                              return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => ConditionalBuilder(
                                    condition:true ,
                                    builder: (context) {
                                      int from  = AppCubit.get(context).startTimes[index].data()["from"];
                                      int to = AppCubit.get(context).startTimes[index].data()["to"];
                                      String strFrom = "";
                                      String strTo = "";
                                      if(from>12){
                                        strFrom = "${from - 12} pm";
                                      }else if(from == 0){
                                        strFrom = "12 am";
                                      }else if(from == 12){
                                        strFrom = "12 pm";
                                      }
                                      else{
                                        strFrom = "$from am";
                                      }
                                      if(to>12){
                                        strTo = "${to - 12} pm";
                                      }else if(to == 0){
                                        strTo= "12 am";
                                      }else if(to == 12){
                                        strTo = "12 pm";
                                      }
                                      else{
                                        strTo = "$to am";
                                      }
                                      return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                  cubit.selected[index] = !cubit.selected[index];
                                                  cubit.changeCardColor();
                                                  if (cubit.selected[index]) choose.add(index);
                                                  else
                                                    for(int i = 0 ; i < choose.length ; i++){
                                                      if (choose[i] == index) {
                                                        choose.removeAt(i);
                                                      }
                                                    }
                                              },
                                              child: Card(
                                                color: cubit.selected[index] ? defaultColor.withOpacity(0.8) : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        '$day ${dateController.text}, from: $strFrom to: $strTo'
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          width: 50,
                                                          child: const Image(
                                                              image: AssetImage(
                                                                  'assets/images/empty_ball.png'
                                                              )
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                                school["name"]
                                                            ),
                                                            Text(
                                                                'Field $currentField'
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                    },
                                    fallback: (context) => Container(),
                                  ),
                                  separatorBuilder: (context, index) => myDivider(),
                                  itemCount: AppCubit.get(context).startTimes.length
                              );
                            },
                            fallback:(context) => Center(child:CircularProgressIndicator(
                              color: defaultColor,
                            ))
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              color: const Color(0xff388E3C),
                              child: defaultTextButton(
                                color: Colors.white,
                                backGroundColor: const Color(0xff388E3C),
                                function: () {
                                  navigateTo(context, PaymentScreen(choose,school,dateController.text,currentField));
                                },
                                text: 'YALA',
                              ),
                            ),
                          ),
                        ],
                      ),
                      fallback: (context) => Container(),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
