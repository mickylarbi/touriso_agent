import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/contact.dart';
import 'package:touriso_agent/models/hotels/hotel.dart';
import 'package:touriso_agent/models/tour/site.dart';
import 'package:touriso_agent/screens/auth/auth_form.dart';
import 'package:touriso_agent/screens/auth/auth_screen.dart';
import 'package:touriso_agent/screens/home/dashboard/dashboard_page.dart';
import 'package:touriso_agent/screens/home/history/history_page.dart';
import 'package:touriso_agent/screens/home/home_page.dart';
import 'package:touriso_agent/screens/home/order/order_page.dart';
import 'package:touriso_agent/screens/home/services/hotel/edit_hotel_page.dart';
import 'package:touriso_agent/screens/home/services/hotel/rooms_grid.dart';
import 'package:touriso_agent/screens/home/services/services_page.dart';
import 'package:touriso_agent/screens/home/services/tour/edit_site_page.dart';
import 'package:touriso_agent/screens/home/services/tour/site_details_page.dart';

GoRouter goRouter = GoRouter(
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const AuthForm(authType: AuthType.login),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) =>
              const AuthForm(authType: AuthType.signUp),
        ),
      ],
      builder: (context, state, child) => AuthScreen(child: child),
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
                  path: 'edit_hotel/:hotel_id',
                  builder: (context, state) => EditHotelPage(
                    hotel: state.pathParameters['hotel_id'] != '0'
                        ? Hotel(
                            rooms: const [],
                            id: '',
                            companyId: '',
                            name: '',
                            rating: 0,
                            description: '',
                            contact: Contact(phone: '', email: ''),
                          )
                        : null,
                  ),
                ),
                GoRoute(
                  path: 'edit_site/:site_id',
                  builder: (context, state) => EditSite(
                    site: state.pathParameters['site_id'] != '0'
                        ? Site(
                            id: 'id',
                            name: '',
                            location: 'GeoPoint(0, 0)',
                            geoLocation: GeoPoint(0, 0),
                            description: 'description',
                            imageUrls: List.generate(5, (index) => 'null'),
                          )
                        : null,
                  ),
                ),
                GoRoute(
                  path: 'site_details/:site_id',
                  builder: (context, state) => SiteDetails(
                    site: Site(
                      id: state.pathParameters['site_id']!,
                      name: 'Lou Moon',
                      location: 'GeoPoint(0, 0)',
                      geoLocation: const GeoPoint(0, 0),
                      description: lipsum,
                      imageUrls: const [],
                    ),
                  ),
                ),
                // GoRoute(path: '/add_apartment'),
                // GoRoute(path: '/add_bus'),id
                // GoRoute(path: '/add_flight'),
              ],
            ),
          ],
        ),
      ],
      builder: (context, state, child) => HomePage(child: child),
    ),
  ],
  initialLocation: '/services/site_details/:0',
);
