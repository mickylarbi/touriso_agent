// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/auth/auth_shell.dart';
import 'package:touriso_agent/screens/auth/login_page.dart';
import 'package:touriso_agent/screens/auth/register_page.dart';
import 'package:touriso_agent/screens/home/dashboard/dashboard_page.dart';
import 'package:touriso_agent/screens/home/history/history_page.dart';
import 'package:touriso_agent/screens/home/home_page.dart';
import 'package:touriso_agent/screens/home/order/order_page.dart';
import 'package:touriso_agent/screens/home/services/hotel/edit_hotel_page.dart';
import 'package:touriso_agent/screens/home/services/services_page.dart';
import 'package:touriso_agent/screens/home/services/site/activity/activity_details_page.dart';
import 'package:touriso_agent/screens/home/services/site/site_details_page.dart';

GoRouter goRouter = GoRouter(
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],
      builder: (context, state, child) => AuthShell(child: child),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrderPage(),
            ),
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
            GoRoute(
              path: '/services',
              builder: (context, state) => const ServicesPage(),
              routes: [
                GoRoute(
                  path: 'add_hotel',
                  builder: (context, state) => const EditHotelPage(hotel: null),
                ),
                GoRoute(
                  path: 'site/:id',
                  builder: (context, state) => SiteDetailsPage(
                    siteId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'activity/:id',
                      builder: (context, state) => ActivityDetailsPage(
                        activityId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      builder: (context, state, child) => HomePage(child: child),
    ),
  ],
  initialLocation: '/login',
);
