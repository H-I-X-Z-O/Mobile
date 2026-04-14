import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/study_plan_provider.dart';
import '../../domain/entities/study_plan_entity.dart';
import 'reminder_settings_screen.dart';
import '../../../../core/extensions/context_extension.dart';

class WeeklyStudyPlanScreen extends StatefulWidget {
  const WeeklyStudyPlanScreen({super.key});

  @override
  State<WeeklyStudyPlanScreen> createState() => _WeeklyStudyPlanScreenState();
}

class _WeeklyStudyPlanScreenState extends State<WeeklyStudyPlanScreen> {
  // Removed hardcoded _days list
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudyPlanProvider>();
    final plan = provider.studyPlan ?? StudyPlanEntity(userId: '');
    final t = context.appTheme;
    final days = [
      context.l10n.mon,
      context.l10n.tue,
      context.l10n.wed,
      context.l10n.thu,
      context.l10n.fri,
      context.l10n.sat,
      context.l10n.sun
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.weekly_schedule),
        centerTitle: true,
      ),
      body: provider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(AppDimensions.p20),
            children: [
              Text(context.l10n.daily_goal, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppDimensions.p8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${plan.dailyMinutesGoal} ${context.l10n.minutes}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
              Slider(
                value: plan.dailyMinutesGoal.toDouble(),
                min: 15,
                max: 60,
                divisions: 3,
                label: '${plan.dailyMinutesGoal} ${context.l10n.minutes}',
                activeColor: AppColors.primary,
                onChanged: (val) {
                  provider.updatePlan(plan.copyWith(dailyMinutesGoal: val.toInt()));
                },
              ),
              
              const SizedBox(height: AppDimensions.p24),
              Text(context.l10n.study_days, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppDimensions.p16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(7, (index) {
                  final dayNum = index + 1;
                  final isSelected = plan.studyDays.contains(dayNum);
                  return GestureDetector(
                    onTap: () {
                      final newList = List<int>.from(plan.studyDays);
                      if (isSelected) {
                        newList.remove(dayNum);
                      } else {
                        newList.add(dayNum);
                      }
                      provider.updatePlan(plan.copyWith(studyDays: newList));
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : t.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? null : Border.all(color: t.borderColor),
                      ),
                      child: Center(
                        child: Text(
                          days[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : t.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppDimensions.p32),
              Text(context.l10n.notifications, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppDimensions.p16),
              
              ...plan.reminders.map((reminder) => _buildReminderTile(context, reminder, plan, provider)),
              
              const SizedBox(height: AppDimensions.p16),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReminderSettingsScreen()),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: Text(context.l10n.add_time),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
              
              const SizedBox(height: AppDimensions.p48),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(context.l10n.finish_setup),
              ),
            ],
          ),
    );
  }

  Widget _buildReminderTile(BuildContext context, ReminderTime reminder, StudyPlanEntity plan, StudyPlanProvider provider) {
    final t = context.appTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.orange.withAlpha(20), shape: BoxShape.circle),
            child: const Icon(Icons.access_time, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.reminder_slots, style: Theme.of(context).textTheme.titleSmall),
                Text(reminder.timeString, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(
            value: reminder.isEnabled,
            onChanged: (val) {
              final newList = plan.reminders.map((r) {
                if (r == reminder) {
                  return ReminderTime(hour: r.hour, minute: r.minute, isEnabled: val);
                }
                return r;
              }).toList();
              provider.updatePlan(plan.copyWith(reminders: newList));
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
