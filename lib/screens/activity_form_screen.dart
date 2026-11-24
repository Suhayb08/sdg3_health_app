import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../data/activity_store.dart';
import '../models/activity.dart';

class ActivityFormScreen extends StatefulWidget {
  const ActivityFormScreen({
    super.key,
    required this.store,
    this.activity,
    this.onNavigate,
  });

  final ActivityStore store;
  final Activity? activity;
  final ValueChanged<int>? onNavigate;

  bool get isEditing => activity != null;

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  late final TextEditingController _dateController;
  late final TextEditingController _notesController;

  static const List<String> _categories = <String>[
    'Walking',
    'Cycling',
    'Yoga',
    'Running',
    'Cardio',
    'Strength',
    'Swimming',
    'Stretching',
    'Other',
  ];

  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final activity = widget.activity;
    _nameController = TextEditingController(text: activity?.name ?? '');
    _durationController = TextEditingController(
      text: activity == null ? '' : activity.durationMinutes.toString(),
    );
    _selectedCategory = activity?.category ?? 'Walking';
    _selectedDate = activity?.date ?? DateTime.now();
    _dateController = TextEditingController(
      text: formatActivityDate(_selectedDate),
    );
    _notesController = TextEditingController(text: activity?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme
              .copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
      _dateController.text = formatActivityDate(_selectedDate);
    });
  }

  void _saveActivity() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final duration = int.parse(_durationController.text.trim());
    final existing = widget.activity;

    if (existing == null) {
      widget.store.addActivity(
        name: _nameController.text,
        category: _selectedCategory,
        durationMinutes: duration,
        date: _selectedDate,
        notes: _notesController.text,
      );
    } else {
      widget.store.updateActivity(
        existing.copyWith(
          name: _nameController.text.trim(),
          category: _selectedCategory,
          durationMinutes: duration,
          date: _selectedDate,
          notes: _notesController.text.trim(),
        ),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 17,
              ),
            ),
            const SizedBox(width: 9),
            const Text(
              'HealthTrack',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_rounded : Icons.add_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isEditing ? 'Edit Activity' : 'Add Activity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isEditing
                          ? 'Update the selected activity details'
                          : 'Enter a new activity to track your progress',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.045),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Activity Name',
                              prefixIcon: Icon(Icons.directions_run_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Please enter an activity name';
                              if (value.trim().length < 2)
                                return 'Activity name must have at least 2 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: _categories
                                .map(
                                  (category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null)
                                setState(() => _selectedCategory = value);
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select a category'
                                : null,
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Duration (minutes)',
                              prefixIcon: Icon(Icons.timer_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Please enter duration';
                              final minutes = int.tryParse(value.trim());
                              if (minutes == null || minutes <= 0)
                                return 'Duration must be a positive number';
                              if (minutes > 1440)
                                return 'Duration cannot exceed 1440 minutes';
                              return null;
                            },
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _chooseDate,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                              suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Please select a date'
                                : null,
                          ),
                          const SizedBox(height: 13),
                          TextFormField(
                            controller: _notesController,
                            minLines: 1,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Notes (optional)',
                              prefixIcon: Icon(Icons.notes_rounded),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _saveActivity,
                              child: Text(
                                isEditing ? 'Update Activity' : 'Save Activity',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Estimated calories are calculated for demonstration and are not a medical measurement.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 84,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Container(
                margin: const EdgeInsets.fromLTRB(18, 6, 18, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF173B35).withValues(alpha: 0.07),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: NavigationBar(
                  height: 68,
                  selectedIndex: 1,
                  onDestinationSelected: (index) {
                    final navigate = widget.onNavigate;
                    Navigator.pop(context);
                    navigate?.call(index);
                  },
                  destinations: const <NavigationDestination>[
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.directions_run_outlined),
                      selectedIcon: Icon(Icons.directions_run_rounded),
                      label: 'Activities',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
