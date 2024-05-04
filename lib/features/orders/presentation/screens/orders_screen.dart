import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/core/widgets/no_data.dart';
import 'package:kstore/features/orders/presentation/widgets/recent_order_widget.dart';
import 'package:kstore/features/orders/domain/entities/status.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  void _setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0 &&
            BlocProvider.of<OrdersCubit>(context).pageNo <=
                BlocProvider.of<OrdersCubit>(context).totalPages) {
          _getOrders();
        }
      }
    });
  }

  _getOrders() async {
    await BlocProvider.of<OrdersCubit>(context).getOrders(
      // status: 1,
      sortOrder: 'desc',
      sortBy: 'created_at',
      perPage: 7,
    );
  }

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrdersCubit>(context).clearData();
    _getOrders();
    _setupScrollController(context);
  }

  // @override
  // void deactivate() {
  //   context.read<OrdersCubit>().getRecentOrders();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: Constants.getAppBar(
        context,
        title: translator.translate(AppLocalizationStrings.orders)!,
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
      ),
      body: buildOrders(translator),
    );
  }

  buildOrders(translator) {
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is GetOrdersErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
        if (state is CancelOrderSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          context.read<OrdersCubit>().clearData();
          _getOrders();
        }
      },
      builder: (context, state) {
        var translator = AppLocalizations.of(context)!;
        if (state is GetOrdersLoadingState && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is GetOrdersLoadingState) {
          BlocProvider.of<OrdersCubit>(context).loadMore = true;
        }
        if (state is GetOrdersErrorState) {
          return Center(
            child: Text(state.message),
          );
        }
        if (context.read<OrdersCubit>().orders.isEmpty) {
          return const NoData();
        }
        return _bodyContent(context, translator);
      },
    );
  }

  Padding _bodyContent(BuildContext context, AppLocalizations translator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: context.read<OrdersCubit>().orders.length +
            (context.read<OrdersCubit>().loadMore ? 1 : 0),
        itemBuilder: (context, index) {
          // List<Status> statuses =
          //     context.read<OrdersCubit>().orders[index].statuses;
          if (index < context.read<OrdersCubit>().orders.length) {
            return SizedBox(
                height: context.height * 0.22,
                child: RecentOrdersWidget(
                  abaleToReorder: false,
                  onCancelTap: () => context.read<OrdersCubit>().cancelOrder(
                      context.read<OrdersCubit>().orders[index].id),
                  status: context
                      .read<OrdersCubit>()
                      .orders[index]
                      .status!
                      .toString(),
                  margin: EdgeInsets.only(
                      right: context.width * 0.02,
                      left: context.width * 0.02,
                      top: context.height * 0.02),
                  name:
                      '${context.read<OrdersCubit>().orders[index].products[0].orderProduct!.name}',
                  imgPath: context
                          .read<OrdersCubit>()
                          .orders[index]
                          .products[0]
                          .orderProduct!
                          .images![0] ??
                      '',
                  description: context
                      .read<OrdersCubit>()
                      .orders[index]
                      .products[0]
                      .orderProduct!
                      .description!,
                  price: context
                      .read<OrdersCubit>()
                      .orders[index]
                      .total
                      .toString(),
                  avilability: getOrderVisability(context, index, translator),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.trackingOrdersScreen,
                        arguments:
                            context.read<OrdersCubit>().orders[index].id);
                  },
                ));
          } else if (BlocProvider.of<OrdersCubit>(context).pageNo <=
              BlocProvider.of<OrdersCubit>(context).totalPages) {
            Timer(const Duration(milliseconds: 30), () {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });

            return const LoadingIndicator();
          }
          return const SizedBox();
        },
      ),
    );
  }

  String getOrderVisability(
      BuildContext context, int index, AppLocalizations translator) {
    return context
                .read<OrdersCubit>()
                .orders[index]
                .products[0]
                .orderProduct!
                .quantity! >
            0
        ? translator.translate(AppLocalizationStrings.available)!
        : translator.translate(AppLocalizationStrings.notAvailable)!;
  }

  int ordersItemCount(BuildContext context) {
    return context.read<OrdersCubit>().orders.length > 3
        ? 3
        : context.read<OrdersCubit>().orders.length;
  }
}

String getOrderStatus({
  required BuildContext context,
  required int id,
  required int status,
}) {
  var translator = AppLocalizations.of(context)!;
  if (id == 1 && status == 1) {
    return translator.translate(AppLocalizationStrings.pending)!;
  } else if (id == 2 && status == 1) {
    return translator.translate(AppLocalizationStrings.accepted)!;
  } else if (id == 3 && status == 1) {
    return translator.translate(AppLocalizationStrings.shipped)!;
  } else if (id == 4 && status == 1) {
    return translator.translate(AppLocalizationStrings.delivered)!;
  } else if (id == 5 && status == 1) {
    return translator.translate(AppLocalizationStrings.rejected)!;
  } else {
    return translator.translate(AppLocalizationStrings.pending)!;
  }
}
