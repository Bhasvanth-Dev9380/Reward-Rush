import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scratcher/scratcher.dart';
import '../bloc/coin_bloc.dart';
import '../bloc/coin_event.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ScratchCardWidget extends StatefulWidget {
  final int index;
  final bool isScratched;
  final int reward;
  final Function(int, bool, int) onScratchComplete;

  const ScratchCardWidget({
    Key? key,
    required this.index,
    this.isScratched = false,
    this.reward = 0,
    required this.onScratchComplete,
  }) : super(key: key);

  @override
  _ScratchCardWidgetState createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
  bool isScratched = false;
  int reward = 0;

  @override
  void initState() {
    super.initState();
    isScratched = widget.isScratched;
    reward = widget.reward;
  }



  Future<void> _onScratchComplete() async {
    if (isScratched) return;

    setState(() {
      isScratched = true;
      reward = (50 + (450 * (DateTime.now().millisecond / 1000)).toInt()); // Random reward between 50 and 500
    });

    await _saveScratchCardState();
    // Update state in HomePage
    widget.onScratchComplete(widget.index, isScratched, reward);
    context.read<CoinBloc>().add(ScratchCardEvent(reward: reward));
  }

  Future<void> _saveScratchCardState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('scratch_card_${widget.index}_scratched', isScratched);
    prefs.setInt('scratch_card_${widget.index}_reward', reward);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 150,
      child: Card(
        color: AppColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: isScratched
            ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard, color: AppColors.accentColor, size: 40), // Gift icon
              SizedBox(height: 10),
              Text(
                'Reward: $reward',
                style: AppTextStyles.subheadline,
                textAlign: TextAlign.center,
              ),
              Icon(Icons.check_circle, color: Colors.green, size: 24),
            ],
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [

                  Scratcher(
                    color: AppColors.accentColor,
                    accuracy: ScratchAccuracy.high,
                    threshold: 50,
                    onThreshold: _onScratchComplete,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.card_giftcard, color: AppColors.accentColor, size: 40), // Gift icon
                          SizedBox(height: 10),
                          Text(
                            'Scratch!',
                            style: AppTextStyles.bodyText,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(child: Icon(Icons.wallet_giftcard,color: Colors.white,size: 40,)),
                ],
              ),
            ),
      ),
    );
  }
}
