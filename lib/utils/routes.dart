// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/auth/auth_shell.dart';
import 'package:touriso_agent/screens/auth/continue_as_writer.dart';
import 'package:touriso_agent/screens/auth/login_page.dart';
import 'package:touriso_agent/screens/auth/register_page.dart';
import 'package:touriso_agent/screens/home/blog/article_details_page.dart';
import 'package:touriso_agent/screens/home/blog/blog_dash.dart';
import 'package:touriso_agent/screens/home/chat/chat_screen.dart';
import 'package:touriso_agent/screens/home/dashboard/dashboard_page.dart';
import 'package:touriso_agent/screens/home/history/history_page.dart';
import 'package:touriso_agent/screens/home/home_page.dart';
import 'package:touriso_agent/screens/home/bookings/bookings_page.dart';
import 'package:touriso_agent/screens/home/profile_page.dart';
import 'package:touriso_agent/screens/home/services/accomodation/edit_hotel_page.dart';
import 'package:touriso_agent/screens/home/services/services_page.dart';
import 'package:touriso_agent/screens/home/services/site/activity/activity_details_page.dart';
import 'package:touriso_agent/screens/home/services/site/site_details_page.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

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
        GoRoute(
          path: '/writer_login',
          builder: (context, state) => const ContinueAsWriter1(),
        ),
        GoRoute(
          path: '/writer_login_details',
          builder: (context, state) => const ContinueAsWriter2(),
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
              path: '/bookings',
              builder: (context, state) => const BookingsPage(),
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
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
    ShellRoute(
      routes: [
        GoRoute(
          path: '/articles/:id',
          builder: (context, state) => ArticleDetailsPage(
            articleId: state.pathParameters['id'],
          ),
        ),
      ],
      builder: (context, state, child) => BlogDash(child: child),
    ),
  ],
  initialLocation: auth.currentUser == null ? '/login' : '/bookings',
);
