import 'package:blog_app/feature/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/feature/job/presentation/page/job_page.dart';
import 'package:blog_app/feature/profile/page/profile_page.dart';
import 'package:blog_app/feature/application/presentation/page/application_page.dart';
import 'package:blog_app/feature/learn/presentation/page/learn_page.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_state.dart';
import 'package:blog_app/feature/profile/presentation/bloc/profile_event.dart';
import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blog_app/feature/auth/presentation/page/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      context.read<ProfileBloc>().add(
        ProfileFetchRequested(userId: appUserState.user.id),
      );
    }
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home (Jobs)
    GlobalKey<NavigatorState>(), // Explore
    GlobalKey<NavigatorState>(), // Application
    GlobalKey<NavigatorState>(), // Learn
    GlobalKey<NavigatorState>(), // Profile
  ];

  // List of page routes for each tab
  final List<Widget> _pages = [
    const JobsPage(),
    const BlogPage(),
    const ApplicationPage(),
    const LearnPage(),
    const ProfilePage(),
  ];

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: TickerMode(enabled: _selectedIndex == index, child: _pages[index]),
    );
  }

  Widget _buildProfileImage() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String? imageUrl;
        if (state is ProfileLoaded) {
          imageUrl = state.profile.profilePhotoUrl;
        }

        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _selectedIndex == 4 ? Colors.white : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    bool isProfile = false,
  }) {
    return BottomNavigationBarItem(
      icon: isProfile
          ? _buildProfileImage()
          : Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
      label: label,
      activeIcon: isProfile
          ? _buildProfileImage()
          : Icon(icon, size: 26, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0), // Home (Jobs)
            _buildOffstageNavigator(1), // Explore
            _buildOffstageNavigator(2), // Application
            _buildOffstageNavigator(3), // Learn
            _buildOffstageNavigator(4), // Profile
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BottomNavigationBar(
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  if (_selectedIndex == index) {
                    _navigatorKeys[index].currentState?.popUntil(
                      (r) => r.isFirst,
                    );
                  } else {
                    setState(() => _selectedIndex = index);
                  }
                },
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey[400],
                selectedIconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 22,
                ),
                unselectedIconTheme: IconThemeData(
                  color: Colors.grey[400],
                  size: 22,
                ),
                showSelectedLabels: true,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                items: [
                  _buildNavBarItem(
                    icon: _selectedIndex == 0
                        ? Icons.home
                        : Icons.home_outlined,
                    label: 'Home',
                    isSelected: _selectedIndex == 0,
                  ),
                  _buildNavBarItem(
                    icon: _selectedIndex == 1
                        ? Icons.explore
                        : Icons.explore_outlined,
                    label: 'Explore',
                    isSelected: _selectedIndex == 1,
                  ),
                  _buildNavBarItem(
                    icon: _selectedIndex == 2
                        ? Icons.description
                        : Icons.description_outlined,
                    label: 'Application',
                    isSelected: _selectedIndex == 2,
                  ),
                  _buildNavBarItem(
                    icon: _selectedIndex == 3
                        ? Icons.school
                        : Icons.school_outlined,
                    label: 'Learn',
                    isSelected: _selectedIndex == 3,
                  ),

                  _buildNavBarItem(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: _selectedIndex == 4,
                    isProfile: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
