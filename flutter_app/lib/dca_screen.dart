import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DcaScreen extends StatefulWidget {
  const DcaScreen({Key? key}) : super(key: key);

  @override
  State<DcaScreen> createState() => _DcaScreenState();
}

class _DcaScreenState extends State<DcaScreen> {
  // 예시 필드들
  String _selectedCycle = '매일';
  String _selectedAsset = 'BTC';
  String _selectedPair = 'USDT';
  final TextEditingController _amountController = TextEditingController();

  // iOS 시간 피커용
  DateTime _selectedDateTime = DateTime(2022, 1, 1, 9, 0);

  @override
  Widget build(BuildContext context) {
    // Dummy wallet balances
    final double stableBalance = 1000.123456789;
    double cryptoBalance = 0.123456789;

    if (_selectedAsset == 'ETH') cryptoBalance = 2.123456789;
    if (_selectedAsset == 'XRP') cryptoBalance = 123.987654321;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('매수 주기'),
          _buildCycleDropdown(context),
          const SizedBox(height: 24),

          _buildSectionTitle('매수 시간'),
          _buildTimeSelector(context),
          const SizedBox(height: 24),

          _buildSectionTitle('매수 금액'),
          _buildAmountField(context),
          const SizedBox(height: 24),

          _buildSectionTitle('매수 자산'),
          _buildAssetAndPairRow(context),
          const SizedBox(height: 24),

          _buildWalletBalanceCard(context, stableBalance, cryptoBalance),
          const SizedBox(height: 32),

          _buildConfirmButton(context),
        ],
      ),
    );
  }

  //region --- UI 빌더 메서드들 ---
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCycleDropdown(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: _selectedCycle,
        underline: const SizedBox(),
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: '매일', child: Text('매일')),
          DropdownMenuItem(value: '매주', child: Text('매주')),
          DropdownMenuItem(value: '매월', child: Text('매월')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedCycle = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoTimePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade100
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.time,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(_formatTime(_selectedDateTime)),
            const Spacer(),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCupertinoTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 300,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey.shade900,
          child: Column(
            children: [
              // 상단 툴바
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey.shade900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('취소'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      '시간 선택',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CupertinoButton(
                      child: const Text('완료'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _selectedDateTime,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _selectedDateTime = newDateTime;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? '오후' : '오전';
    final displayHour = (hour == 0)
        ? 12
        : (hour > 12 ? hour - 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$ampm $displayHour:$minuteStr';
  }

  Widget _buildAmountField(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey.shade100 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '예) 50',
        ),
      ),
    );
  }

  Widget _buildAssetAndPairRow(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Row(
      children: [
        // 자산
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isLight ? Colors.grey.shade100 : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _selectedAsset,
              underline: const SizedBox(),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'BTC', child: Text('BTC')),
                DropdownMenuItem(value: 'ETH', child: Text('ETH')),
                DropdownMenuItem(value: 'XRP', child: Text('XRP')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAsset = value;
                    if (_selectedAsset == 'BTC' || _selectedAsset == 'ETH') {
                      _selectedPair = 'USDT';
                    } else {
                      _selectedPair = '';
                    }
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 페어 (BTC, ETH일 때만)
        if (_selectedAsset == 'BTC' || _selectedAsset == 'ETH')
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isLight ? Colors.grey.shade100 : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: (['USDT', 'USDC'].contains(_selectedPair))
                    ? _selectedPair
                    : 'USDT',
                underline: const SizedBox(),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'USDT', child: Text('USDT')),
                  DropdownMenuItem(value: 'USDC', child: Text('USDC')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPair = value;
                    });
                  }
                },
              ),
            ),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildWalletBalanceCard(BuildContext context, double stable, double crypto) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지갑 잔고',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text('스테이블 코인: \$${stable.toStringAsFixed(9)}'),
          const SizedBox(height: 4),
          Text('$_selectedAsset 잔고: ${crypto.toStringAsFixed(9)}'),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onConfirm(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '설정 완료',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  //endregion

  void _onConfirm(BuildContext context) {
    // 자산/페어
    String finalPair = _selectedAsset;
    if (_selectedAsset == 'BTC' || _selectedAsset == 'ETH') {
      finalPair = '$_selectedAsset/$_selectedPair';
    }

    // 시간 포맷
    final timeText = _formatTime(_selectedDateTime);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('DCA 설정 완료'),
        content: Text(
          '주기: $_selectedCycle\n'
          '시간: $timeText\n'
          '금액: \$${_amountController.text}\n'
          '거래 페어: $finalPair',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
