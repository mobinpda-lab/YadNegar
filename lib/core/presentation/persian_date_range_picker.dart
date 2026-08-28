import 'package:flutter/material.dart';
import 'package:yadnegar/core/presentation/persian_datetime_formatter.dart';

Future<DateTimeRange?> showYadNegarPersianDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialRange,
  PersianDateTimeFormatter formatter = const PersianDateTimeFormatter(),
}) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (context) => _PersianDateRangeDialog(
      initialRange: initialRange,
      formatter: formatter,
    ),
  );
}

class _PersianDateRangeDialog extends StatefulWidget {
  const _PersianDateRangeDialog({
    required this.initialRange,
    required this.formatter,
  });

  final DateTimeRange? initialRange;
  final PersianDateTimeFormatter formatter;

  @override
  State<_PersianDateRangeDialog> createState() => _PersianDateRangeDialogState();
}

class _PersianDateRangeDialogState extends State<_PersianDateRangeDialog> {
  static const _primary = Color(0xFF5546D8);
  static const _monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];
  static const _weekDays = <String>['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  late JalaliDate _visibleMonth;
  JalaliDate? _start;
  JalaliDate? _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final initialStart = widget.initialRange?.start ?? now;
    _start = widget.initialRange == null
        ? null
        : widget.formatter.toJalali(widget.initialRange!.start);
    _end = widget.initialRange == null
        ? null
        : widget.formatter.toJalali(widget.initialRange!.end);
    final visible = widget.formatter.toJalali(initialStart);
    _visibleMonth = JalaliDate(visible.year, visible.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('persian-date-range-dialog'),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      title: const Text(
        'انتخاب بازه زمانی',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          key: const Key('persian-date-range-scroll'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMonthHeader(),
              const SizedBox(height: 12),
              _buildWeekHeader(),
              const SizedBox(height: 6),
              _buildMonthGrid(),
              const SizedBox(height: 12),
              _buildSelectionSummary(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('انصراف'),
        ),
        FilledButton(
          key: const Key('persian-date-range-confirm'),
          style: FilledButton.styleFrom(backgroundColor: _primary),
          onPressed: _start == null ? null : _confirm,
          child: const Text('اعمال'),
        ),
      ],
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      children: [
        IconButton(
          key: const Key('persian-calendar-next-month'),
          tooltip: 'ماه بعد',
          onPressed: () => setState(() => _visibleMonth = _nextMonth(_visibleMonth)),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
        Expanded(
          child: Text(
            '${_monthNames[_visibleMonth.month - 1]} ${widget.formatter.persianDigits(_visibleMonth.year.toString())}',
            key: const Key('persian-calendar-month-title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF29264A),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          key: const Key('persian-calendar-previous-month'),
          tooltip: 'ماه قبل',
          onPressed: () => setState(() => _visibleMonth = _previousMonth(_visibleMonth)),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ],
    );
  }

  Widget _buildWeekHeader() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        for (final day in _weekDays)
          Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  color: Color(0xFF797A8D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    final firstGregorian = widget.formatter.toGregorian(_visibleMonth);
    final leadingBlanks = (firstGregorian.weekday + 1) % 7;
    final dayCount = widget.formatter.daysInJalaliMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );
    final cells = leadingBlanks + dayCount;
    final rows = (cells / 7).ceil();

    return GridView.builder(
      key: const Key('persian-calendar-grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: rows > 5 ? 1.05 : 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, index) {
        final day = index - leadingBlanks + 1;
        if (day < 1 || day > dayCount) {
          return const SizedBox.shrink();
        }
        final date = JalaliDate(_visibleMonth.year, _visibleMonth.month, day);
        return _buildDay(date);
      },
    );
  }

  Widget _buildDay(JalaliDate date) {
    final isStart = _sameDate(date, _start);
    final isEnd = _sameDate(date, _end);
    final isBoundary = isStart || isEnd;
    final inRange = _isBetween(date, _start, _end);

    return InkWell(
      key: Key('persian-calendar-day-${date.year}-${date.month}-${date.day}'),
      borderRadius: BorderRadius.circular(12),
      onTap: () => _select(date),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isBoundary
              ? _primary
              : inRange
                  ? const Color(0xFFECE9FF)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.formatter.persianDigits(date.day.toString()),
          style: TextStyle(
            color: isBoundary ? Colors.white : const Color(0xFF343446),
            fontWeight: isBoundary ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSummary() {
    if (_start == null) {
      return const Text(
        'تاریخ شروع را انتخاب کنید',
        key: Key('persian-date-range-summary'),
        style: TextStyle(color: Color(0xFF77788A)),
      );
    }
    final effectiveEnd = _end ?? _start!;
    return Container(
      key: const Key('persian-date-range-summary'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        'از ${_formatJalali(_start!)} تا ${_formatJalali(effectiveEnd)}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: _primary, fontWeight: FontWeight.w700),
      ),
    );
  }

  void _select(JalaliDate date) {
    setState(() {
      if (_start == null || _end != null) {
        _start = date;
        _end = null;
        return;
      }
      if (_compare(date, _start!) < 0) {
        _start = date;
        _end = null;
        return;
      }
      _end = date;
    });
  }

  void _confirm() {
    final start = _start!;
    final end = _end ?? start;
    Navigator.of(context).pop(
      DateTimeRange(
        start: widget.formatter.toGregorian(start),
        end: widget.formatter.toGregorian(end),
      ),
    );
  }

  JalaliDate _previousMonth(JalaliDate value) {
    if (value.month == 1) {
      return JalaliDate(value.year - 1, 12, 1);
    }
    return JalaliDate(value.year, value.month - 1, 1);
  }

  JalaliDate _nextMonth(JalaliDate value) {
    if (value.month == 12) {
      return JalaliDate(value.year + 1, 1, 1);
    }
    return JalaliDate(value.year, value.month + 1, 1);
  }

  bool _sameDate(JalaliDate value, JalaliDate? other) {
    return other != null &&
        value.year == other.year &&
        value.month == other.month &&
        value.day == other.day;
  }

  bool _isBetween(JalaliDate value, JalaliDate? start, JalaliDate? end) {
    if (start == null || end == null) {
      return false;
    }
    return _compare(value, start) > 0 && _compare(value, end) < 0;
  }

  int _compare(JalaliDate left, JalaliDate right) {
    final year = left.year.compareTo(right.year);
    if (year != 0) {
      return year;
    }
    final month = left.month.compareTo(right.month);
    if (month != 0) {
      return month;
    }
    return left.day.compareTo(right.day);
  }

  String _formatJalali(JalaliDate value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return widget.formatter.persianDigits('${value.year}/$month/$day');
  }
}
