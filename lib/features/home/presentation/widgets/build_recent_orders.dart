import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_state.dart';
import 'package:kstore/features/orders/presentation/widgets/recent_order_widget.dart';

import '../../../../core/widgets/loading_indicator.dart';
import '../../../orders/domain/entities/order.dart';

class buildRecentOrders extends StatefulWidget {
  const buildRecentOrders({Key? key}) : super(key: key);

  @override
  State<buildRecentOrders> createState() => _buildRecentOrdersState();
}

class _buildRecentOrdersState extends State<buildRecentOrders> {
  _getRecentOrders() async {
    await BlocProvider.of<OrdersCubit>(context).getRecentOrders();
  }

  Future<void> _loadHomeData() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _getRecentOrders();
    } catch (e) {
      print(e);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadHomeData();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        var translator = AppLocalizations.of(context)!;
        //if reorder loading

        if (state is GetRecentOrdersLoadingState) {
          return const LoadingIndicator();
        } else if (state is GetRecentOrdersErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          var orders = context.read<OrdersCubit>().recentOrders;
          log('ordersfromhome: ${orders.length}');

          return reOrdersItems(context, orders, translator);
        }
      },
    );
  }

  Padding reOrdersItems(
      BuildContext context, List<Order> orders, AppLocalizations translator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: ordersItemCount(context),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
              height: context.height * 0.22,
              child: RecentOrdersWidget(
                onReorderTap: () {
                  context.read<OrdersCubit>().reOrder(orders[index].id);
                },
                margin: EdgeInsets.only(
                    right: context.width * 0.02,
                    left: context.width * 0.02,
                    top: context.height * 0.02),
                name: '${orders[index].products[0].orderProduct!.name}',
                imgPath:
                    orders[index].products[0].orderProduct!.images![0] ?? '',
                description:
                    orders[index].products[0].orderProduct!.description!,
                price: orders[index].total.toString(),
                avilability: getOrderVisability(context, index, translator),
              ));
        },
      ),
    );
  }

  int ordersItemCount(BuildContext context) {
    return context.read<OrdersCubit>().recentOrders.length > 3
        ? 3
        : context.read<OrdersCubit>().recentOrders.length;
  }

  String getOrderVisability(
      BuildContext context, int index, AppLocalizations translator) {
    return context
                .read<OrdersCubit>()
                .recentOrders[index]
                .products[0]
                .orderProduct!
                .quantity! >
            0
        ? translator.translate(AppLocalizationStrings.available)!
        : translator.translate(AppLocalizationStrings.notAvailable)!;
  }
}
