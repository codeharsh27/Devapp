import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MainWrapperPage extends StatefulWidget {
  final Widget child;
  const MainWrapperPage({super.key, required this.child});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  void _onTap(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/submissions'); // Applications
        break;
      case 2:
        context.go('/inbox'); // Inbox
        break;
      case 3:
        context.go('/profile'); // Profile
        break;
    }
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/submissions')) return 1;
    if (location.startsWith('/inbox')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Floating Capsule Navigation Bar
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              color: theme.scaffoldBackgroundColor, // Ensure background matches
              child: widget.child,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor, // Adaptive background
                  border: Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5)),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5))
                  ]),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavBarItem(
                      icon: Icons.home_rounded,
                      label: "Home",
                      index: 0,
                      isSelected: selectedIndex == 0,
                      onTap: () => _onTap(0),
                    ),
                    _NavBarItem(
                      icon: Icons.grid_view_rounded,
                      label: "Drops",
                      index: 1,
                      isSelected: selectedIndex == 1,
                      onTap: () => _onTap(1),
                    ),
                    _NavBarItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "Inbox",
                      index: 2,
                      isSelected: selectedIndex == 2,
                      onTap: () => _onTap(2),
                    ),
                    _NavBarItem(
                      icon: Icons.person_outline_rounded,
                      label: "Profile",
                      index: 3,
                      isSelected: selectedIndex == 3,
                      onTap: () => _onTap(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.primaryColor;
    final inactiveColor =
        theme.iconTheme.color?.withOpacity(0.5) ?? Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF2C2C2C)
                  : theme.primaryColor.withOpacity(0.1))
              : Colors.transparent, // Pill Decoration
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (isDark ? Colors.white : activeColor)
                  : inactiveColor,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected
                      ? (isDark ? Colors.white : activeColor)
                      : inactiveColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
