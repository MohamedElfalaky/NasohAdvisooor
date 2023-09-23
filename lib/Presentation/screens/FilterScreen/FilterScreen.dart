import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nasooh/Presentation/screens/FilterScreen/Components/CompleteAdvisorCard.dart';
import 'package:nasooh/Presentation/screens/FilterScreen/Components/PaymentCard.dart';
import 'package:nasooh/Presentation/widgets/MyButton.dart';
import 'package:nasooh/Presentation/widgets/noInternet.dart';
import 'package:nasooh/Presentation/widgets/shared.dart';
import 'package:nasooh/app/constants.dart';
import 'package:nasooh/app/utils/myApplication.dart';

import '../../../Data/cubit/authentication/category_cubit/category_cubit.dart';
import '../../../Data/cubit/authentication/category_cubit/category_state.dart';
import '../../../Data/models/Auth_models/category_model.dart';
import '../../../app/Style/Icons.dart';
import '../../../app/Style/sizes.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // AdvisorController AdvisorController = AdvisorController();
  late StreamSubscription<ConnectivityResult> _subscription;
  bool? isConnected;
  List<CategoryData> selectedItems = [];

  @override
  void initState() {
    super.initState();

    MyApplication.checkConnection().then((value) {
      if (value) {
        //////
        // todo recall data
        ///
        ///
        ///
        ///
      } else {
        MyApplication.showToastView(message: '${'noInternet'.tr}');
      }
    });

    // todo subscribe to internet change
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          result == ConnectivityResult.none
              ? isConnected = false
              : isConnected = true;
        });
      }

      /// if internet comes back
      if (result != ConnectivityResult.none) {
        /// call your apis
        // todo recall data
        ///
        ///
        ///
        ///
      }
    });
    context.read<CategoryCubit>().getCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // todo if not connected display nointernet widget else continue to the rest build code
    final sizee = MediaQuery.of(context).size;
    if (isConnected == null) {
      MyApplication.checkConnection().then((value) {
        setState(() {
          isConnected = value;
        });
      });
    } else if (!isConnected!) {
      MyApplication.showToastView(message: '${'noInternet'.tr}');
      return NoInternetWidget(size: sizee);
    }

    return GestureDetector(
      onTap: () {
        MyApplication.dismissKeyboard(context);
      }, // hide keyboard on tap anywhere

      child: Scaffold(
        floatingActionButton: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            child:  MyButton(onPressedHandler: (){
              print(selectedItems.map((e) => e.id).toList());
            },
              txt: "تصفية",
              isBold: true,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.whiteAppColor,
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Constants.whiteAppColor,
          elevation: 0,
          leading: Container(
            padding: const EdgeInsets.symmetric(vertical: 7),
            margin: const EdgeInsets.only(right: 10),
            child: const Card(
                child: BackButton(
              color: Colors.black,
            )),
          ),
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "تصفية",
                  style: Constants.headerNavigationFont,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("مسح", style: Constants.secondaryTitleRegularFont),
                  const SizedBox(
                    width: 4,
                  ),
                  SvgPicture.asset(recycleIcon),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, categoryState) {
          if (categoryState is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (categoryState is CategoryLoaded) {
            final catList = categoryState.response?.data ?? [];
            return Container(
                color: Constants.whiteAppColor,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 32,
                        ),
                        child: Text(
                          "المجالات",
                          style: Constants.mainTitleFont,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 16,
                        ),
                        child: Text(
                          "جميع المجالات",
                          style: Constants.secondaryTitleRegularFont,
                        ),
                      ),
                      InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              content: SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.separated(
                                  separatorBuilder: (context, int index) =>
                                      const Divider(),
                                  itemBuilder: (context, int index) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedItems
                                              .add(catList[index]);
                                          // catList.remove(catList[index]);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Center(
                                          child: Text(catList[index].name!))),
                                  itemCount: catList.length,
                                ),
                              ),
                            );
                          },
                        ),
                        child: TextField(
                          enabled: false,
                          decoration: Constants.setTextInputDecoration(
                              prefixIcon: MyPrefixWidget(
                                svgString: categoriesIcon,
                              ),
                              isSuffix: true,
                              suffixIcon:
                                  const Icon(Icons.keyboard_arrow_down_sharp),
                              hintText: "اختر المجال أو التخصص..."),
                        ),
                      ),
                      SizedBox(
                          height: height(context) * 0.4,
                          width: width(context),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: selectedItems
                                .map((e) => Container(
                                          margin:
                                              const EdgeInsetsDirectional.only(
                                                  end: 10, bottom: 8, top: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                              color: const Color(0XFFEEEEEE),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                e.name!,
                                                style: const TextStyle(
                                                    fontFamily:
                                                        Constants.mainFont,
                                                    fontSize: 10),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                height: 14,
                                                width: 14,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0XFF5C5E6B))),
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedItems.remove(e);
                                                        // catList.add(e);
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.close_outlined,
                                                      size: 12,
                                                      color: Color(0XFF5C5E6B),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                    // Container(child: Text(e))

                                    )
                                .toList(),
                          )

                          // ListView.builder(
                          //   itemCount: selectedItems.length,
                          //   itemBuilder: (context, index) {
                          //     return Container(height: 20,
                          //       child: ListTile(
                          //         title: Text(selectedItems[index].toString()),
                          //       ),
                          //     );
                          //   },
                          // ),
                          ),
                    ],
                  ),
                ));
          } else if (categoryState is CategoryError) {
            return const SizedBox();
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}
