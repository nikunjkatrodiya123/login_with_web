import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import 'package:login_with_web/color_controller.dart';

import 'package:login_with_web/screens/catagary_screen.dart';
import 'package:login_with_web/screens/content_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _activePage = 0;
  final List pages = [
    const ContenScreen(),
    const CatagaroyScreen(),
  ];

  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: ColorController.buttonColor,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Users',
                onTap: (pages, _) {
                  sideMenu.changePage(pages);
                  _pageController.animateToPage(--_activePage,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceInOut);
                  setState(() {});
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Catagory',
                onTap: (pages, _) {
                  sideMenu.changePage(pages);
                  _pageController.animateToPage(++_activePage,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.bounceInOut);
                  setState(() {});
                },
                icon: const Icon(Icons.home),
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
                setState(() {});
              },
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                return pages[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
