import 'package:auto_route/auto_route.dart';
import 'package:kopianan_boilerplate/presentation/home/home_page.dart';
import 'package:kopianan_boilerplate/presentation/splash/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Page,Route")
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page),
      ];
}
