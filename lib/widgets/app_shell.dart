import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme_picker.dart';


class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _routes = ['/', '/result', '/about'];
  static const _labels = ['Home', 'Result', 'About'];
  static const _icons  = [Icons.home_outlined, Icons.cloud_outlined, Icons.info_outline];

  int _indexFromLocation(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _routes.length; i++) {
      if (loc == _routes[i] || loc.startsWith('${_routes[i]}?')) return i;
    }
    return 0;
  }

  void _go(BuildContext context, int index) {
    if (index < 0 || index >= _routes.length) return;
    if (_routes[index] != GoRouterState.of(context).uri.toString()) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLarge = width >= 900;
    final selectedIndex = _indexFromLocation(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: isLarge
          ? null
          : AppBar(
        title: const Text('Parade Weather'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: const [
          ThemePickerButton(iconOnly: true), // <— here
          SizedBox(width: 4),
        ],
      ),
      drawer: isLarge ? null : Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _routes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) => ListTile(
                    leading: Icon(_icons[i]),
                    title: Text(_labels[i]),
                    selected: i == selectedIndex,
                    onTap: () {
                      Navigator.of(context).pop();
                      _go(context, i);
                    },
                  ),
                ),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.brightness_6_outlined),
                title: Text('Theme'),
                trailing: ThemePickerButton(iconOnly: false),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          // Left rail for large screens
          if (isLarge)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _go(context, i),
              extended: true,
              labelType: NavigationRailLabelType.none,
              leading: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text('Parade Weather',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              destinations: List.generate(
                _routes.length,
                    (i) => NavigationRailDestination(
                  icon: Icon(_icons[i]),
                  label: Text(_labels[i]),
                ),
              ),
              trailing: const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.brightness_6_outlined),
                    SizedBox(width: 8),
                    ThemePickerButton(iconOnly: false),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ),


          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width >= 600 ? 24 : 12,
                vertical: width >= 600 ? 16 : 8,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
