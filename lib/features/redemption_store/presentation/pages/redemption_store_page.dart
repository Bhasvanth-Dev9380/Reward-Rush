import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../bloc/redemption_bloc.dart';
import '../bloc/redemption_event.dart';
import '../bloc/redemption_state.dart';
import '../widgets/redemption_item_widget.dart';

class RedemptionStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<RedemptionBloc>().add(LoadRedemptionItems());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Redemption Store',
          style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: BlocListener<RedemptionBloc, RedemptionState>(
        listener: (context, state) {
          if (state is RedemptionSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RedemptionSuccessPage(),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Choose an item to redeem!",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: BlocBuilder<RedemptionBloc, RedemptionState>(
                  builder: (context, state) {
                    if (state is RedemptionLoading) {
                      return Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                    } else if (state is RedemptionLoaded) {
                      return GridView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.8 / 2, // Adjust height of the cards
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return RedemptionItemWidget(item: item);
                        },
                      );
                    } else if (state is RedemptionFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class RedemptionSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set a timer to automatically navigate back to MainPage after 2 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()), // Navigate back to MainPage
            (Route<dynamic> route) => false, // Clear all previous routes
      );
    });

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/success.png'),
            Icon(Icons.check_circle, color: Colors.orangeAccent, size: 80),
            SizedBox(height: 16),
            Text(
              "Successfully Redeemed!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Redirecting...",
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}