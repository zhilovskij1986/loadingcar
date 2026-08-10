import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../features/authorization/login_screen.dart';
// Імпортуйте ваші екрани вкладки
// import '../features/pages/home_screen.dart';
// import '../features/pages/clients_screen.dart';
// import '../features/pages/calendar_screen.dart';
// import '../features/pages/reports_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    // 1. Екран авторизації (без нижнього меню)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // 2. Головне меню з нижньою навігацією (BottomNavigationBar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        final userName = state.extra as String? ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Завантаження авто'),
            centerTitle: true,
          ),
          drawer: _buildAppDrawer(context, userName),
          body: navigationShell,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                Colors.blue, // Змінено на контрастний, щоб бачити виділення
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_outlined),
                activeIcon: Icon(Icons.qr_code_scanner),
                label: 'Хід сканування',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'По клієнтам',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning_amber_rounded),
                activeIcon: Icon(Icons.warning_rounded),
                label: 'Проблемні',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined),
                activeIcon: Icon(Icons.local_shipping),
                label: 'Доставка',
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main',
              builder: (context, state) {
                return const Scaffold(
                  body: Center(
                    child: Text('Екран: По хід сканування(в розробці)'),
                  ),
                );
                //return HomeScreen(userName: userName);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/clients',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Екран: По клієнтам (в розробці)')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/problematic',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Екран: Проблемні (в розробці)')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/delivery',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Екран: Доставка (в розробці)')),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget _buildAppDrawer(BuildContext context, String userName) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Налаштування'),
          onTap: () {
            Navigator.pop(context);
            // TODO: Навігація до налаштувань
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Вихід', style: TextStyle(color: Colors.red)),
          onTap: () {
            Navigator.pop(context);
            //SystemNavigator.pop();
            if (context.mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    ),
  );
}
