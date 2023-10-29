import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kopianan_boilerplate/application/cubit/example_cubit.dart';
import 'package:kopianan_boilerplate/injection.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<ExampleCubit>().getData();
        },
      ),
    );
  }
}
