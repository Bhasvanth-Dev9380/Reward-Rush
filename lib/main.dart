import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'features/home/presentation/bloc/coin_bloc.dart';
import 'features/home/presentation/bloc/coin_event.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/history/presentation/bloc/transaction_bloc.dart';
import 'features/history/presentation/bloc/transaction_event.dart';
import 'features/history/presentation/pages/history_page.dart';
import 'features/redemption_store/presentation/bloc/redemption_bloc.dart';
import 'features/redemption_store/presentation/bloc/redemption_event.dart';
import 'features/redemption_store/presentation/pages/redemption_store_page.dart';

import 'features/home/data/repositories/coin_repository_impl.dart';
import 'features/history/data/repositories/transaction_repository_impl.dart';
import 'features/history/domain/usecases/get_transaction_history.dart';
import 'features/redemption_store/data/repositories/redemption_repository_impl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionRepository = TransactionRepositoryImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(
            getTransactionHistory: GetTransactionHistory(transactionRepository),
            transactionRepository: transactionRepository,
          )..add(LoadTransactionHistory()),
        ),
        BlocProvider<CoinBloc>(
          create: (context) => CoinBloc(
            repository: CoinRepositoryImpl(),
            transactionBloc: context.read<TransactionBloc>(),
          )..add(LoadInitialCoins()),
        ),
        BlocProvider<RedemptionBloc>(
          create: (context) => RedemptionBloc(
            repository: RedemptionRepositoryImpl(),
            coinBloc: context.read<CoinBloc>(),
            transactionBloc: context.read<TransactionBloc>(),
          )..add(LoadRedemptionItems()),
        ),
      ],
      child: MaterialApp(
        title: 'Reward Rush',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryColor,
          primaryColor: AppColors.primaryColor,
          hintColor: AppColors.accentColor,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    RedemptionStorePage(),
  ];

  late double indicatorPosition;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      indicatorPosition = index * MediaQuery.of(context).size.width / _pages.length;
    });
  }

  @override
  void initState() {
    super.initState();
    indicatorPosition = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double padding = 16.0;
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: padding, right: padding, bottom: padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Circular border radius
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 250), // Increase duration for smoother transition
                  curve: Curves.easeInOutCubic, // Smooth curve
                  left: indicatorPosition,
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width / _pages.length,
                    height: 3,
                    color: Colors.orangeAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    items: [
                      _buildBottomNavItem(Icons.home, Icons.home_outlined, 'Home', 0),
                      _buildBottomNavItem(Icons.history, Icons.history_outlined, 'History', 1),
                      _buildBottomNavItem(Icons.store, Icons.store_outlined, 'Store', 2),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: Colors.orangeAccent,
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    enableFeedback: false, // Disables tap feedback
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(IconData selectedIcon, IconData unselectedIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: Duration(milliseconds: 200), // Duration for icon transition
        child: Icon(
          _selectedIndex == index ? selectedIcon : unselectedIcon,
          key: ValueKey<int>(_selectedIndex == index ? 1 : 0),
        ),
      ),
      label: label,
    );
  }
}
