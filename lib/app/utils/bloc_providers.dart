import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasooh/Data/cubit/authentication/nationality_cubit/nationality_cubit.dart';
import 'package:nasooh/Data/cubit/send_chat_cubit/send_chat_cubit.dart';
import 'package:nasooh/Data/cubit/show_advice_cubit/show_advice_cubit/show_advice_cubit.dart';

import '../../Data/cubit/advisor_profile_cubit/profile_cubit.dart';
import '../../Data/cubit/authentication/category_cubit/category_cubit.dart';
import '../../Data/cubit/authentication/category_parent_cubit/category_parent_cubit.dart';
import '../../Data/cubit/authentication/check_code/check_code_cubit.dart';
import '../../Data/cubit/authentication/city_cubit/city_cubit.dart';
import '../../Data/cubit/authentication/country_cubit/country_cubit.dart';
import '../../Data/cubit/authentication/delete_account_cubit/delete_account_cubit.dart';
import '../../Data/cubit/authentication/get_by_token_cubit/get_by_token_cubit.dart';
import '../../Data/cubit/authentication/get_user_by_mob_cubit/get_user_cubit.dart';
import '../../Data/cubit/authentication/log_out_cubit/log_out_cubit.dart';
import '../../Data/cubit/authentication/login_cubit/login_cubit.dart';
import '../../Data/cubit/authentication/new_mob/mob_cubit.dart';
import '../../Data/cubit/authentication/options_cubit/options_cubit.dart';
import '../../Data/cubit/authentication/register_cubit/register_cubit.dart';
import '../../Data/cubit/coupons_cubit/coupons_cubit.dart';
import '../../Data/cubit/home/advisor_list_cubit.dart';
import '../../Data/cubit/home/home_slider_cubit.dart';
import '../../Data/cubit/notification_cubit/notification_cubit.dart';
import '../../Data/cubit/orders_cubit/orders_filters_cubit/orders_filters_cubit.dart';
import '../../Data/cubit/orders_cubit/orders_status_cubit/orders_status_cubit.dart';
import '../../Data/cubit/profile/profile_cubit/profile_cubit.dart';
import '../../Data/cubit/profile/update_profile_cubit/update_profile_cubit.dart';
import '../../Data/cubit/rejections_cubit/reject_cubit/post_reject_cubit.dart';
import '../../Data/cubit/rejections_cubit/rejection_list_cubit/rejection_list_cubit.dart';
import '../../Data/cubit/review_cubit/review_cubit.dart';
import '../../Data/cubit/send_advice_cubit/send_advise_cubit.dart';
import '../../Data/cubit/settings_cubits/about_cubit/about_cubit.dart';
import '../../Data/cubit/settings_cubits/is_notification_cubit/is_notification_cubit.dart';
import '../../Data/cubit/settings_cubits/privacy_cubit/privacy_cubit.dart';
import '../../Data/cubit/show_advice_cubit/done_advice_cubit/done_advice_cubit.dart';
import '../../Data/cubit/show_advice_cubit/pay_advice_cubit/pay_advice_cubit.dart';
import '../../Data/cubit/show_advice_cubit/payment_list_cubit/payment_list_cubit.dart';
import '../../Data/cubit/subcategory_cubit/subcategory_cubit.dart';
import '../../Data/cubit/wallet_cubit/wallet_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
  BlocProvider<MobCubit>(create: (context) => MobCubit()),
  BlocProvider<CheckCodeCubit>(create: (context) => CheckCodeCubit()),
  BlocProvider<CountryCubit>(create: (context) => CountryCubit()),
  BlocProvider<CityCubit>(create: (context) => CityCubit()),
  BlocProvider<NationalityCubit>(create: (context) => NationalityCubit()),
  BlocProvider<AboutCubit>(create: (context) => AboutCubit()),
  BlocProvider<RegisterCubit>(create: (context) => RegisterCubit()),
  BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit()..getDataProfile()),
  BlocProvider<LogOutCubit>(create: (context) => LogOutCubit()),
  BlocProvider<CouponsCubit>(create: (context) => CouponsCubit()),
  BlocProvider<UpdateProfileCubit>(create: (context) => UpdateProfileCubit()),
  BlocProvider<GetUserCubit>(create: (context) => GetUserCubit()),
  BlocProvider<HomeSliderCubit>(create: (context) => HomeSliderCubit()),
  BlocProvider<AdvisorListCubit>(create: (context) => AdvisorListCubit()),
  BlocProvider<AdvisorProfileCubit>(create: (context) => AdvisorProfileCubit()),
  BlocProvider<SendAdviseCubit>(create: (context) => SendAdviseCubit()),
  BlocProvider<PaymentListCubit>(create: (context) => PaymentListCubit()),
  BlocProvider<GetByTokenCubit>(create: (context) => GetByTokenCubit()),
  BlocProvider<ShowAdviceCubit>(create: (context) => ShowAdviceCubit()),
  BlocProvider<PayAdviceCubit>(create: (context) => PayAdviceCubit()),
  BlocProvider<OrdersStatusCubit>(create: (context) => OrdersStatusCubit()),
  BlocProvider<OrdersFiltersCubit>(create: (context) => OrdersFiltersCubit()),
  BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
  BlocProvider<PrivacyCubit>(create: (context) => PrivacyCubit()),
  BlocProvider<DoneAdviceCubit>(create: (context) => DoneAdviceCubit()),
  BlocProvider<SendChatCubit>(create: (context) => SendChatCubit()),
  BlocProvider<ListRejectionCubit>(create: (context) => ListRejectionCubit()),
  BlocProvider<PostRejectCubit>(create: (context) => PostRejectCubit()),
  BlocProvider<CategoryParentCubit>(create: (context) => CategoryParentCubit()),
  BlocProvider<ReviewCubit>(create: (context) => ReviewCubit()),
  BlocProvider<WalletCubit>(create: (context) => WalletCubit()),
  BlocProvider<IsNotificationCubit>(create: (context) => IsNotificationCubit()),
  BlocProvider<NotificationCubit>(create: (context) => NotificationCubit()),
  BlocProvider<DeleteAccountCubit>(create: (context) => DeleteAccountCubit()),
  BlocProvider<SubCategoryCubit>(create: (context) => SubCategoryCubit()),
  BlocProvider<OptionsCubit>(create: (context) => OptionsCubit()),
];
