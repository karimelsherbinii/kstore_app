import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/features/orders/domain/entities/status.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_state.dart';

import 'package:timelines/timelines.dart';

class TrackingOrdersScreen extends StatefulWidget {
  final int orderId;
  const TrackingOrdersScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<TrackingOrdersScreen> createState() => _TrackingOrdersScreenState();
}

class _TrackingOrdersScreenState extends State<TrackingOrdersScreen> {
  _getOrder() async {
    await context.read<OrdersCubit>().getOrder(widget.orderId);
  }

  @override
  void initState() {
    super.initState();
    _getOrder();
  }

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracker Zen"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: DefaultButton(
          label: translator.translate(AppLocalizationStrings.goToHomePage)!,
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.home);
          },
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is GetOrderLoadingState) {
            return const Center(
              child: LoadingIndicator(),
            );
          }
          if (state is GetOrderErrorState) {
            return Center(
              child: DefaultButton(
                label: translator.translate(AppLocalizationStrings.retry)!,
                onTap: () {
                  context.read<OrdersCubit>().getOrder(widget.orderId);
                },
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/map-track.png'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: buildTrackingTimeLine(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTrackingTimeLine() {
    var ordersCubit = context.read<OrdersCubit>();
    List<Status> statuses =
        ordersCubit.order != null ? ordersCubit.order!.statuses : [];

    return SizedBox(
      height: context.height,
      child: FixedTimeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          connectorTheme: const ConnectorThemeData(
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: statuses.length,
          contentsBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getOrderStatus(context, index),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    formattedDate(statuses[index].createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
          indicatorBuilder: (_, index) {
            var status = statuses[index];
            return DotIndicator(
              size: 20,
              color: getStatusColor(
                statusId: status.id,
                status: status.status,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          connectorBuilder: (_, index, ___) => SolidLineConnector(
            color: getStatusColor(
              statusId: statuses[index].id,
              status: statuses[index].status,
            ),
            thickness: 5,
          ),
        ),
      ),
    );
  }

  Color getStatusColor({required int statusId, required int status}) {
    if (statusId == 1 && status == 1) {
      return Colors.green;
    } else if (statusId == 2 && status == 1) {
      return Colors.green;
    } else if (statusId == 3 && status == 1) {
      return Colors.green;
    } else if (statusId == 4 && status == 1) {
      return Colors.green;
    } else if (statusId == 5 && status == 1) {
      return Colors.red;
    } else {
      return Colors.grey.shade100;
    }
  }

  getIfOrderStatusIsTurnON(int index) {
    var statuses = context.read<OrdersCubit>().orders[index].statuses;
    if (statuses[index].status == 1) {
      return true;
    } else {
      return false;
    }
  }

  String getOrderStatus(BuildContext context, int index) {
    var statuses = context.read<OrdersCubit>().order!.statuses;
    var translator = AppLocalizations.of(context)!;
    if (statuses[index].id == 1) {
      return translator.translate(AppLocalizationStrings.pending)!;
    } else if (statuses[index].id == 2) {
      return translator.translate(AppLocalizationStrings.accepted)!;
    } else if (statuses[index].id == 3) {
      return translator.translate(AppLocalizationStrings.shipped)!;
    } else if (statuses[index].id == 4) {
      return translator.translate(AppLocalizationStrings.delivered)!;
    } else if (statuses[index].id == 5) {
      return translator.translate(AppLocalizationStrings.rejected)!;
    } else {
      return translator.translate(AppLocalizationStrings.pending)!;
    }
  }

  String formattedDate(String date) {
    final customFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    try {
      final dateTime = customFormat.parse(date);
      final outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Invalid Date'; // Or any other error message you prefer
    }
  }
}
