import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nasooh/Data/cubit/orders_cubit/orders_status_cubit/orders_status_cubit.dart';
import 'package:nasooh/Data/cubit/orders_cubit/orders_status_cubit/orders_status_state.dart';
import 'package:nasooh/Presentation/screens/chat_screen/chat_screen.dart';
import 'package:nasooh/app/utils/shared_preference.dart';

import '../../../../../app/utils/my_application.dart';
import '../../../../Data/cubit/orders_cubit/orders_filters_cubit/orders_filters_cubit.dart';
import '../../../../Data/cubit/orders_cubit/orders_filters_cubit/orders_filters_state.dart';
import '../../../../app/constants.dart';
import '../../../widgets/shared.dart';
import '../../CompleteAdviseScreen/complete_advise_screen.dart';
import 'OrderCard/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  int current = 0;


  double changePositionedOfLine() {
    switch (current) {
      case 0:
        return MediaQuery.of(context).size.width * 0.83;
      case 1:
        return MediaQuery.of(context).size.width * 0.7;
      case 2:
        return MediaQuery.of(context).size.width * 0.57;
      case 3:
        return MediaQuery.of(context).size.width * 0.42;
      case 4:
        return MediaQuery.of(context).size.width * 0.27;
      case 5:
        return MediaQuery.of(context).size.width * 0.14;
      default:
        return 0;
    }
  }



  @override
  void initState() {
    context.read<OrdersStatusCubit>().getOrdersStatus();
    context.read<OrdersFiltersCubit>().getOrdersFilters(id: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawerScrimColor: Colors.white,
        appBar: customABarNoIcon(
            txt: "my_orders".tr, back: false, context: context),
        body: sharedPrefs.getToken() == ''
            ? const Center(
                child: Text(
                  'برجاء تسجيل الدخول اولا',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : BlocBuilder<OrdersStatusCubit, OrdersStatusState>(
                builder: (context, homeState) {
                if (homeState is OrdersStatusLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (homeState is OrdersStatusLoaded) {
                  var ordersList = homeState.response?.data;
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 50,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: ordersList?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                  });
                                  context
                                      .read<OrdersFiltersCubit>()
                                      .getOrdersFilters(
                                          id: ordersList?[index].id == 0
                                              ? ""
                                              : '${ordersList![index].id}');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Column(
                                    children: [
                                      Text(
                                        ordersList?[index].name ?? "",
                                        style: Constants.subtitleRegularFont
                                            .copyWith(
                                          fontWeight: current == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize:
                                              current == index ? 15 : 14,
                                        ),
                                      ),
                                      if (current == index)
                                        Container(
                                          width: ordersList?[index].name?.length
                                                  .toDouble()??0 *
                                              8,
                                          margin: const EdgeInsets.only(top: 6),
                                          height: 2,
                                          color: Colors.black,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      buildOrdersFilterBlocBuilder()
                    ],
                  );
                } else if (homeState is OrdersStatusEmpty) {
                  return const Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 150),
                    child: Center(
                        child: Text(
                      'لا يوجد ناصحين بهذا الاسم',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontFamily: Constants.mainFont,
                      ),
                    )),
                  ));
                }
                return const SizedBox.shrink();
              }));
  }

  BlocBuilder<OrdersFiltersCubit, OrdersFiltersState>
      buildOrdersFilterBlocBuilder() {
    return BlocBuilder<OrdersFiltersCubit, OrdersFiltersState>(
        builder: (context, ordersFilters) {
      if (ordersFilters is OrdersFiltersEmpty) {
        return const Expanded(
            child: Padding(
          padding: EdgeInsets.only(bottom: 150),
          child: Center(
              child: Text(
            'لا يوجد طلبات بهذا القسم',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: Constants.mainFont,
            ),
          )),
        ));
      }
      if (ordersFilters is OrdersFiltersLoading) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      } else if (ordersFilters is OrdersFiltersLoaded) {
        var filtersList = ordersFilters.response?.data;

        return Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemCount: filtersList?.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: filtersList![index].label!.id == 1
                      ? () {
                          MyApplication.navigateTo(
                              context,
                              CompleteAdviseScreen(
                                  adviceId: filtersList[index].id!));
                        }
                      : () {
                    log(filtersList[index].label?.name.toString() ?? "" , name: "LabelName");
                    log(filtersList[index].label?.id.toString() ?? "" , name: "LabelName");
                          MyApplication.navigateTo(
                              context,
                              ChatScreen(
                                description: filtersList[index].description ??
                                    'لا يوجد وصف لهذا الناصح',
                                statusClickable:
                                    filtersList[index].label!.id == 3,
                                labelToShow:
                                    filtersList[index].label!.id == 1 ||
                                        filtersList[index].label!.id == 2,
                                openedStatus: filtersList[index].label!.id == 2 || filtersList[index].label!.id == 3,
                                adviceId: filtersList[index].id!,
                                adviserProfileData: filtersList[index].adviser,
                              ));
                        },
                  child: OrderCard(
                      orderFilterData: filtersList[index],
                      description:
                          ordersFilters.response?.data?[index].description ??
                              'لا يوجد وصف لهذا الناصح'),
                );
              }),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
