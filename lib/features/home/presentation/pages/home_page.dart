import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/coin_bloc.dart';
import '../bloc/coin_event.dart';
import '../bloc/coin_state.dart';
import '../widgets/scratch_card_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<int> timerStream;
  List<Map<String, dynamic>> scratchCards = [];

  @override
  void initState() {
    super.initState();
    context.read<CoinBloc>().add(LoadInitialCoins());
    _loadScratchCardStates();
    timerStream = Stream.periodic(Duration(seconds: 1), (_) => DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _loadScratchCardStates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> loadedScratchCards = [];

    for (int i = 0; i < 5; i++) {
      final isScratched = prefs.getBool('scratch_card_${i}_scratched') ?? false;
      final reward = prefs.getInt('scratch_card_${i}_reward') ?? 0;
      loadedScratchCards.add({
        'index': i,
        'isScratched': isScratched,
        'reward': reward,
      });
    }

    setState(() {
      scratchCards = loadedScratchCards;
    });
  }

  // Callback to update scratch card state
  void _updateScratchCardState(int index, bool isScratched, int reward) {
    setState(() {
      scratchCards[index] = {
        'index': index,
        'isScratched': isScratched,
        'reward': reward,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Rush', style: AppTextStyles.headline),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          final coins = state.coins;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Coin Balance Card
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Card(
                    color: AppColors.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Your Coins', style: AppTextStyles.subheadline),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/coin.png', height: 20),
                              SizedBox(width: 10),
                              Text(coins.toString(), style: AppTextStyles.headline.copyWith(fontSize: 32)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Remaining time or availability message
                StreamBuilder<int>(
                  stream: timerStream,
                  builder: (context, snapshot) {
                    final remainingTime = state.nextScratchTime.difference(DateTime.now());
                    return Text(
                      remainingTime.isNegative
                          ? 'Scratch card available now!'
                          : 'Next scratch card in: ${remainingTime.inMinutes}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: AppTextStyles.bodyText,
                    );
                  },
                ),
                SizedBox(height: 40),
                // Horizontal scratch card list
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Align(alignment:Alignment.centerLeft,child: Text('Recent Scratch cards',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: scratchCards.length,
                        itemBuilder: (context, index) {
                          final card = scratchCards[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ScratchCardWidget(
                              index: card['index'],
                              isScratched: card['isScratched'],
                              reward: card['reward'],
                              onScratchComplete: _updateScratchCardState, // Pass callback here
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
