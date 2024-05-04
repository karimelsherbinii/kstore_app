import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  var searchController = TextEditingController();
  final List<String> locations = [
    'al maadi',
    'al mohandseen',
    'al mokattam',
    'al mounib',
    'al mounira',
    'al mounira 2',
    'al mounira 3',
    'Cairo',
    'Dokki',
    'Giza',
    'Helwan',
    'Heliopolis',
  ];
  final List<String> searches = [
    'T-shirt',
    'Shirt',
    'Pants',
    'Shoes',
    'Socks',
    'Jacket',
    'Sweater',
    'Sweatshirt',
    'Shorts',
    'Dress',
    'Skirt',
    'Coat',
  ];
  String userLocatoin = 'Cairo';
}
