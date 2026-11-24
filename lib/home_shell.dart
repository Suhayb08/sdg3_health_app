import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'data/activity_store.dart';
import 'models/activity.dart';
import 'screens/activity_form_screen.dart';
import 'utils/activity_ui.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.store});

  final ActivityStore store;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardContent(
        store: widget.store,
        onViewActivities: () => setState(() => _selectedIndex = 1),
      ),
      ActivityListContent(
        store: widget.store,
        onNavigate: (index) => setState(() => _selectedIndex = index),
      ),
      const ProfileContent(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Open navigation menu',
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 9),
            const Text(
              'HealthTrack',
              style: TextStyle(
                color: AppColors.heading,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.mint,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.favorite_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'HealthTrack',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.heading),
                    ),
                  ],
                ),
              ),
              _drawerItem(Icons.home_rounded, 'Home', 0),
              _drawerItem(Icons.directions_run_rounded, 'Activities', 1),
              _drawerItem(Icons.person_outline_rounded, 'Profile', 2),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('HealthTrack • Practical 1', style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        // Keep this area to the navigation bar's actual height so the page body
        // retains the remaining vertical space.
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
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  destinations: const <NavigationDestination>[
                    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
                    NavigationDestination(icon: Icon(Icons.directions_run_outlined), selectedIcon: Icon(Icons.directions_run_rounded), label: 'Activities'),
                    NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? AppColors.primary : AppColors.secondaryText),
      title: Text(title, style: TextStyle(color: AppColors.heading, fontWeight: _selectedIndex == index ? FontWeight.w700 : FontWeight.w500)),
      selected: _selectedIndex == index,
      selectedTileColor: AppColors.mint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => _selectPage(index),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.store, required this.onViewActivities});

  final ActivityStore store;
  final VoidCallback onViewActivities;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final todaysActivities = store.activitiesForDay(today);
        final totalMinutes = todaysActivities.fold<int>(0, (sum, item) => sum + item.durationMinutes);
        final totalCalories = todaysActivities.fold<int>(0, (sum, item) => sum + item.estimatedCalories);

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(18)),
                          child: const Icon(Icons.monitor_heart_rounded, color: AppColors.primary, size: 30),
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        'Your Daily Activity Summary',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.heading),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        formatLongDate(today),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 22),
                      if (constraints.maxWidth >= 560)
                        Row(
                          children: <Widget>[
                            Expanded(child: _SummaryCard(icon: Icons.directions_run_rounded, label: 'Activities', value: '${todaysActivities.length}', unit: 'recorded')),
                            const SizedBox(width: 12),
                            Expanded(child: _SummaryCard(icon: Icons.schedule_rounded, label: 'Exercise Time', value: '$totalMinutes', unit: 'minutes')),
                            const SizedBox(width: 12),
                            Expanded(child: _SummaryCard(icon: Icons.local_fire_department_rounded, label: 'Calories', value: '$totalCalories', unit: 'estimated kcal')),
                          ],
                        )
                      else
                        Column(
                          children: <Widget>[
                            _SummaryCard(icon: Icons.directions_run_rounded, label: 'Activities', value: '${todaysActivities.length}', unit: 'recorded'),
                            const SizedBox(height: 10),
                            _SummaryCard(icon: Icons.schedule_rounded, label: 'Exercise Time', value: '$totalMinutes', unit: 'minutes'),
                            const SizedBox(height: 10),
                            _SummaryCard(icon: Icons.local_fire_department_rounded, label: 'Calories', value: '$totalCalories', unit: 'estimated kcal'),
                          ],
                        ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 14, offset: const Offset(0, 4))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Today\'s Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.heading)),
                            const SizedBox(height: 14),
                            if (todaysActivities.isEmpty)
                              const Text('No activities recorded today. Add an activity to get started.', style: TextStyle(color: AppColors.secondaryText, height: 1.45))
                            else
                              ...todaysActivities.map((activity) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: <Widget>[
                                    Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.paleMint, borderRadius: BorderRadius.circular(12)), child: Icon(categoryIcon(activity.category), color: AppColors.primary, size: 20)),
                                    const SizedBox(width: 11),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text(activity.name, style: const TextStyle(color: AppColors.heading, fontWeight: FontWeight.w600)), Text('${activity.durationMinutes} min • ${activity.estimatedCalories} kcal estimated', style: const TextStyle(color: AppColors.secondaryText, fontSize: 12))])),
                                  ],
                                ),
                              )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: onViewActivities,
                          icon: const Icon(Icons.list_alt_rounded),
                          label: const Text('View Activities'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Calories are estimates for demonstration only.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryText, fontSize: 11)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.unit});

  final IconData icon;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(
        children: <Widget>[
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.paleMint, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: AppColors.primary, size: 21)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 11)), const SizedBox(height: 3), Text(value, style: const TextStyle(color: AppColors.heading, fontSize: 22, fontWeight: FontWeight.w700)), Text(unit, style: const TextStyle(color: AppColors.secondaryText, fontSize: 10))])),
        ],
      ),
    );
  }
}

class ActivityListContent extends StatelessWidget {
  const ActivityListContent({super.key, required this.store, required this.onNavigate});

  final ActivityStore store;
  final ValueChanged<int> onNavigate;

  Future<void> _openForm(BuildContext context, {Activity? activity}) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => ActivityFormScreen(
          store: store,
          activity: activity,
          onNavigate: onNavigate,
        ),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(activity == null ? 'Activity added successfully.' : 'Activity updated successfully.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final activities = store.activities;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 4),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text('My Activities', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.heading)),
                  const SizedBox(height: 5),
                  const Text('Track and manage your daily health activities', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () => _openForm(context),
                      icon: const Icon(Icons.add_rounded, size: 19),
                      label: const Text('Add Activity'),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Expanded(
                    child: activities.isEmpty
                        ? const _EmptyActivities()
                        : ListView.builder(
                            key: const PageStorageKey<String>('activity-list'),
                            padding: const EdgeInsets.only(bottom: 12),
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              final activity = activities[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 9),
                                child: _ActivityCard(
                                  activity: activity,
                                  onTap: () => _openForm(context, activity: activity),
                                  onEdit: () => _openForm(context, activity: activity),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.onTap, required this.onEdit});

  final Activity activity;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE8F0EC)),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(color: AppColors.paleMint, borderRadius: BorderRadius.circular(13)),
                child: Icon(categoryIcon(activity.category), color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(activity.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.heading)),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 10,
                      runSpacing: 3,
                      children: <Widget>[
                        _MetaText(icon: Icons.calendar_today_rounded, text: formatActivityDate(activity.date)),
                        _MetaText(icon: Icons.schedule_rounded, text: '${activity.durationMinutes} min'),
                        _MetaText(icon: Icons.local_fire_department_rounded, text: '${activity.estimatedCalories} kcal'),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit ${activity.name}',
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_outlined, color: AppColors.secondaryText, size: 19),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 11, color: AppColors.secondaryText),
        const SizedBox(width: 3),
        Text(text, style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
      ],
    );
  }
}

class _EmptyActivities extends StatelessWidget {
  const _EmptyActivities();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(width: 58, height: 58, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.directions_run_rounded, color: AppColors.primary, size: 28)),
          const SizedBox(height: 12),
          const Text('No activities yet', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.heading)),
          const SizedBox(height: 5),
          const Text('Add your first activity to get started.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
        ],
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))]),
            child: const Column(
              children: <Widget>[
                CircleAvatar(radius: 35, backgroundColor: AppColors.mint, child: Icon(Icons.person_rounded, color: AppColors.primary, size: 36)),
                SizedBox(height: 15),
                Text('HealthTrack User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.heading)),
                SizedBox(height: 7),
                Text('Your activity records are stored temporarily on this device for the Practical 1 prototype.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryText, height: 1.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

