import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_hagz/layout/bottom_nav_screen.dart';
import 'package:yalla_hagz/modules/school_screen.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';
import 'dart:math';
class PaymentScreen extends StatelessWidget {
  Random random = Random();
  String randomNumber = "";
  var choose;
  var school;
  var date;
  var field;
  var count;
  var fromTime;
  PaymentScreen(this.choose,this.school,this.date,this.field,this.count,this.fromTime);
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var fromWallet = choose.length*school["fees"]<cubit.userModel["balance"]?choose.length*school["fees"]:cubit.userModel["balance"];
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Payment',
              style: TextStyle(
                  color: Color(0xff388E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Credit',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      '${cubit.userModel["balance"]}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width:5),
                    Text(
                      'EGP',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  'Pay With',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.circle_outlined),
                      SizedBox(width: 5,),
                      Icon(Icons.credit_card),
                      SizedBox(width: 5),
                      Text('Credit/Debit Card'),
                    ],
                  ),

                ),
                MaterialButton(
                    onPressed: () {
                      if(count>=school["policy"]){
                        cubit.isCash = false;
                        showToast(text:"Choose vodafone cash as ${school["policyStr"]}",state: ToastStates.WARNING);
                      }else{
                        cubit.cashSelection();
                      }
                    },
                    child: Row(
                      children: [
                        cubit.isCash?Icon(
                            Icons.circle,
                            color:defaultColor
                        ):const Icon(
                          Icons.circle_outlined,
                        ),
                        const SizedBox(width: 5,),
                        const Icon(Icons.money),
                        const SizedBox(width: 5),
                        const Text('Cash'),
                      ],
                    )
                ),
                MaterialButton(
                  onPressed: () {
                    cubit.vodaCashSelection();
                  },
                  child: Row(
                    children: [
                      cubit.vodaCash?Icon(
                          Icons.circle,
                          color:defaultColor
                      ):const Icon(Icons.circle_outlined),
                      const SizedBox(width: 5,),
                      const Icon(Icons.money),
                      const SizedBox(width: 5),
                      const Text('Vodafone Cash'),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Text(
                  'Payment Summary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if(!cubit.isCash&&!cubit.vodaCash){
                      showToast(text:'Please choose a payment method from above',state:ToastStates.WARNING);
                    }else {
                      cubit.walletSelection();
                    }
                  },
                  child: Row(
                    children: [
                      cubit.isWallet?Icon(
                          Icons.circle,
                          color:defaultColor
                      ):const Icon(Icons.circle_outlined),
                      const SizedBox(width: 5,),
                      const Icon(Icons.account_balance_wallet_outlined),
                      const SizedBox(width: 5),
                      const Text('Use Wallet'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text('Hourly Rate'),
                    const Spacer(),
                    Text('EGP ${school["fees"]}'),

                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    const Text('Number of Hours'),
                    const Spacer(),
                    Text('${choose.length}'),

                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    const Text('Wallet'),
                    const Spacer(),
                    Text('(-)${cubit.isWallet? fromWallet:0}'),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    const Text('Total'),
                    const Spacer(),
                    Text('EGP ${choose.length*school["fees"]-(cubit.isWallet? fromWallet:0)}'),
                  ],
                ),
                const Spacer(),
                ConditionalBuilder(
                  condition: cubit.isCash||cubit.vodaCash,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      color: Color(0xff388E3C),
                      child: defaultTextButton(
                        color: Colors.white,
                        backGroundColor: Color(0xff388E3C),
                        function: () {
                        if (cubit.userModel["count"] < 2){
                            if (cubit.userModel["balance"] >= -200) {
                              bool wasBooked = false;
                              for (int z = 0; z < fromTime.length; z++) {
                                for (int m = 0; m < cubit.booked.length; m++) {
                                  if (cubit.booked[m]["isBooked"] &&
                                      cubit.booked[m]["from"] == fromTime[z]) {
                                    showToast(
                                        text:
                                        "Someone has just recently booked from: ${fromTime[z]} to: ${cubit
                                            .booked[m]["to"]}",
                                        state: ToastStates.ERROR);
                                    wasBooked = true;
                                    break;
                                  }
                                }
                              }
                              if (wasBooked) {
                                navigateAndFinish(
                                    context, SchoolScreen(school));
                              } else {
                                for (int j = 1; j <= 6; j++) {
                                  randomNumber += "${random.nextInt(10)}";
                                }
                                int from = 10000000000000;
                                int to = -1000000000000;
                                choose.sort();
                                bool isConsequent = true;
                                for(int j=0;j<choose.length;j++){
                                  if(j!=choose.length-1){
                                    if(cubit.startTimes[choose[j]]["to"]!=cubit.startTimes[choose[j+1]]["from"]){
                                      showToast(
                                          text: "The reservations are not consequent",
                                          state: ToastStates.ERROR
                                      );
                                      isConsequent = false;
                                      break;
                                    }
                                  }
                                }
                                if(isConsequent){
                                for (int i = 0; i < choose.length; i++) {
                                  if (cubit.startTimes[choose[i]]["from"] < from) {
                                    from = cubit.startTimes[choose[i]]["from"];
                                  }
                                  if (cubit.startTimes[choose[i]]["to"] > to) {
                                    to = cubit.startTimes[choose[i]]["to"];
                                  }
                                  cubit.updateBookingTimeModel(
                                      cityId: cubit.currentCity,
                                      schoolId: school["schoolId"],
                                      date: date,
                                      field: field.toString(),
                                      from: cubit.startTimes[choose[i]]["from"]
                                          .toString(),
                                      data: {
                                        "isBooked": true,
                                        "userId": uId,
                                        "userName": cubit.userModel["name"],
                                        "userPhone": cubit.userModel["phone"],
                                        "randomNumber": randomNumber
                                      }
                                  );
                                }

                                cubit.userModel["mala3eb"].add({
                                  "schoolId": school["schoolId"],
                                  "from": from,
                                  "to": to,
                                  "schoolName": school["name"],
                                  "fees": school["fees"],
                                  "city": cubit.currentCity,
                                  "date": date,
                                  "field": field,
                                  "location": school["mapLocation"],
                                  "isDone": false,
                                  "hasRated": false,
                                  "isVerified": false,
                                  "hasWithdrawn": false,
                                  "rating": 0,
                                  "randomNumber": randomNumber,
                                  "image":school["fieldsImages"][field -1 ]
                                });
                                if (cubit.isWallet) {
                                  cubit.userModel["balance"] -= fromWallet;
                                }
                                cubit.userModel["count"]++;
                                cubit.updateUserData(data: {
                                  "mala3eb": cubit.userModel["mala3eb"],
                                  "balance": cubit.userModel["balance"],
                                  "count": cubit.userModel["count"]
                                });
                                if (count > school["policy"]) {
                                  showToast(
                                      text:
                                      "You have successfully booked but Ta3ala 2df3 ya 7iwan ya nasab ya beheema",
                                      state: ToastStates.WARNING);
                                } else {
                                  showToast(
                                      text: "You have successfully booked",
                                      state: ToastStates.SUCCESS);
                                }
                                navigateAndFinish(context, BottomNavScreen());
                                }
                              }
                            }
                            else {
                              showToast(
                                  text: "Sorry, you need to fix your negative wallet before being able to reserve",
                                  state: ToastStates.ERROR);
                            }
                          }
                          else{
                              showToast(
                              text: "Sorry, you have a limit of 2 reservations",
                              state: ToastStates.ERROR);
                              }
                          },
                        text: 'YALA',
                      ),
                    );
                  },
                  fallback: (context) {
                    return Container();
                  }
                ),
              ],
            ),
          ),
        );
      },
    );

  }

}