// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'VocabUp';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'ACCOUNT';

  @override
  String get personal_info => 'Personal Info';

  @override
  String get change_password => 'Change Password';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get push_notifications => 'Push Notifications';

  @override
  String get app_settings => 'APP';

  @override
  String get display_language => 'Language';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get support => 'SUPPORT';

  @override
  String get help_center => 'Help Center';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get home => 'Home';

  @override
  String get topics => 'Learning';

  @override
  String get review => 'Review';

  @override
  String get profile => 'Profile';

  @override
  String get coming_soon => 'Feature coming soon';

  @override
  String get error_occurred => 'An error occurred';

  @override
  String get learning_roadmap => 'Learning Roadmap';

  @override
  String get today_plan => 'Today\'s Plan';

  @override
  String get add_task_hint => 'Add a study note/task...';

  @override
  String get task_type_personal => 'Personal';

  @override
  String get no_plan_msg_tap =>
      'No study tasks yet.\nTap to quickly create today\'s tasks!';

  @override
  String get skill_progress => 'Skill Progress';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get grammar => 'Grammar';

  @override
  String get edit => 'Edit';

  @override
  String get day => 'Day';

  @override
  String get user => 'User';

  @override
  String get statistics => 'Statistics';

  @override
  String get detail => 'Detail';

  @override
  String get update_profile_success => 'Profile updated successfully!';

  @override
  String get full_name => 'Full Name';

  @override
  String get please_enter_name => 'Please enter your name';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get change_password_success => 'Password changed successfully!';

  @override
  String get create_new_password => 'Create new password';

  @override
  String get password_rules =>
      'Your new password must be different from previously used passwords.';

  @override
  String get new_password => 'New Password';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get password_too_short => 'Password must be at least 6 characters';

  @override
  String get passwords_dont_match => 'Passwords do not match';

  @override
  String get update_password => 'Update Password';

  @override
  String get no_data => 'No data yet';

  @override
  String get minutes => 'mins';

  @override
  String get words => 'words';

  @override
  String get points => 'points';

  @override
  String get sessions => 'sessions';

  @override
  String get streak => 'Streak';

  @override
  String get total_days => 'Total Days';

  @override
  String get weekly_schedule => 'Weekly Schedule';

  @override
  String get daily_goal => 'Daily Goal';

  @override
  String get study_days => 'Study Days';

  @override
  String get add_time => 'Add Reminder';

  @override
  String get finish_setup => 'Finish Setup';

  @override
  String get reminder_slots => 'Reminders';

  @override
  String get contact_info_subtitle => 'Name, email, phone';

  @override
  String get daily_reminder_subtitle => 'Receive daily learning reminders';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get study_stats => 'Study Statistics';

  @override
  String get words_per_day => 'Words per Day';

  @override
  String get overall_progress => 'Overall Progress';

  @override
  String get mastered => 'mastered';

  @override
  String get learning_goal => 'Learning Goal';

  @override
  String get goal_question => 'What do you want to achieve?';

  @override
  String get target_score => 'Target Score';

  @override
  String get start_learning => 'Start Learning';

  @override
  String get no_plan_yet =>
      'You haven\'t created a study plan yet.\nStart now to track your progress!';

  @override
  String get create_plan => 'Create Study Plan';

  @override
  String learn_topic(Object topic) {
    return 'Learn \"$topic\"';
  }

  @override
  String get do_quiz => 'Take a Review Quiz';

  @override
  String get duration_range => '15-20 mins';

  @override
  String get quiz_duration => '10 mins';

  @override
  String get grammar_coming_soon =>
      'Grammar module is under development. Focus on vocabulary first!';

  @override
  String get view_details => 'View Details';

  @override
  String topic_title(Object name) {
    return 'Topic: $name';
  }

  @override
  String get completion_progress => 'Completion Progress';

  @override
  String words_count(Object learned, Object total) {
    return '$learned/$total words';
  }

  @override
  String get unknown_error => 'An unknown error has occurred.';

  @override
  String get retry_action => 'Retry';

  @override
  String get no_words_in_topic => 'No vocabulary in this topic yet.';

  @override
  String get learn_flashcards => 'Study Flashcards';

  @override
  String get practice_quiz => 'Practice Quiz';

  @override
  String get review_title => 'Review';

  @override
  String get skill_practice_title => 'Skill Practice';

  @override
  String get skill_practice_subtitle =>
      'Choose a practice mode that fits your goals';

  @override
  String get mode_general => 'Comprehensive';

  @override
  String get mode_general_desc => 'All question types';

  @override
  String get mode_listening => 'Listening';

  @override
  String get mode_listening_desc => 'Listen and pick meaning';

  @override
  String get mode_reflex => 'Reflex';

  @override
  String get mode_reflex_desc => 'Quick Eng - Vie';

  @override
  String get mode_writing => 'Writing';

  @override
  String get mode_writing_desc => 'Remember spelling';

  @override
  String get mode_reverse => 'Reverse Translation';

  @override
  String get mode_reverse_desc => 'Vie - Eng standard';

  @override
  String get learn_words_first_msg =>
      'Learn some words before starting a review!';

  @override
  String greeting_morning(Object name) {
    return 'Good morning, $name!';
  }

  @override
  String greeting_afternoon(Object name) {
    return 'Good afternoon, $name!';
  }

  @override
  String greeting_evening(Object name) {
    return 'Good evening, $name!';
  }

  @override
  String get word_of_day => 'Word of the Day';

  @override
  String get words_learned_label => 'Words Learned';

  @override
  String get goal_reached => 'Great job! You\'ve reached your goal!';

  @override
  String get goal_not_reached => 'Keep it up, you\'re almost there!';

  @override
  String get continue_learning => 'Continue Learning';

  @override
  String get view_all => 'View All';

  @override
  String get no_topics_data => 'No topic data available.';

  @override
  String get personalization_title => 'Personalization';

  @override
  String get goal_q => 'What is your learning goal?';

  @override
  String get level_q => 'What is your current level?';

  @override
  String get time_q => 'How much time per day?';

  @override
  String get onboarding_finish_action => 'Finish and Create Account';

  @override
  String get goal_work => 'Work';

  @override
  String get goal_study => 'Education';

  @override
  String get goal_travel => 'Travel';

  @override
  String get goal_social => 'Communication';

  @override
  String get goal_other => 'Others';

  @override
  String get level_beginner => 'Beginner';

  @override
  String get level_basic => 'Basic';

  @override
  String get level_intermediate => 'Intermediate';

  @override
  String get level_advanced => 'Advanced';

  @override
  String get min_5 => '5 mins';

  @override
  String get min_15 => '15 mins';

  @override
  String get min_30 => '30 mins';

  @override
  String get min_60 => '60 mins';

  @override
  String get onboarding_title => 'Master vocabulary,\nreach the world!';

  @override
  String get onboarding_subtitle =>
      'Personalized vocabulary platform\nhelping you learn every day.';

  @override
  String get start_now_action => 'Start Now';

  @override
  String get already_have_account_action => 'I already have an account';

  @override
  String get create_account_title => 'Create New Account';

  @override
  String get register_subtitle => 'Join the VocabUp English learning community';

  @override
  String get your_name_label => 'Your Name';

  @override
  String get name_hint => 'Enter display name';

  @override
  String get password_hint_register => 'Enter password (At least 6 characters)';

  @override
  String get create_account_action => 'Create Account';

  @override
  String get register_error_msg => 'Please fill in all information.';

  @override
  String get welcome_back => 'Welcome back!';

  @override
  String get login_subtitle => 'Continue your journey to master vocabulary';

  @override
  String get email_hint => 'Enter your email';

  @override
  String get password_hint => 'Enter your password';

  @override
  String get forgot_password_title => 'Forgot Password';

  @override
  String get forgot_password_desc =>
      'Enter your email to receive password reset instructions.';

  @override
  String get forgot_password_q => 'Forgot password?';

  @override
  String get send => 'Send';

  @override
  String get reset_email_sent => 'Password reset email has been sent.';

  @override
  String get remember_me => 'Remember me';

  @override
  String get or_login_with => 'OR LOGIN WITH';

  @override
  String get dont_have_account => 'Don\'t have an account? ';

  @override
  String get register_now => 'Register now';

  @override
  String get login_error_msg => 'Please enter both email and password.';

  @override
  String review_wrong_title(Object count) {
    return 'Review Mistakes ($count)';
  }

  @override
  String get no_wrong_answers => 'You have no mistakes!';

  @override
  String question_label(Object index) {
    return 'Question $index';
  }

  @override
  String get your_choice_label => 'Your choice:';

  @override
  String get correct_answer_label => 'Correct answer:';

  @override
  String get result_title => 'Results';

  @override
  String get great_job => 'Great job!';

  @override
  String get try_harder => 'Keep trying!';

  @override
  String correct_answers_msg(Object correct, Object total) {
    return 'You answered correctly $correct / $total questions.';
  }

  @override
  String get score_label => 'Score';

  @override
  String get review_wrong_action => 'Review Mistakes';

  @override
  String get restart_action => 'Retry';

  @override
  String get back_to_home_action => 'Back to Home';

  @override
  String get data_load_error => 'Data load error.';

  @override
  String get submit => 'Submit';

  @override
  String get next_question => 'Next Question';

  @override
  String get learning_subtitle => 'Vocabulary & Grammar everyday';

  @override
  String get today_progress_label => 'Today\'s Progress';

  @override
  String get unknown_action => 'Don\'t know';

  @override
  String get known_action => 'Already know';

  @override
  String get congrats_completed => 'Completed!';

  @override
  String get learn_again_action => 'Learn again';

  @override
  String get back_to_list_action => 'Back to list';

  @override
  String learned_session_msg(Object learned, Object total) {
    return 'You\'ve memorized $learned / $total words in this session.';
  }

  @override
  String get no_words_learned => 'No words learned yet';

  @override
  String get start_learning_desc =>
      'Start learning vocabulary to track your progress!';

  @override
  String get last_7_days => 'Last 7 days';

  @override
  String get total_learned => 'Total';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get before => 'Before';

  @override
  String get search_vocab_hint => 'Search topics or words...';

  @override
  String get no_topics_found => 'No topics found.';

  @override
  String get learning_label => 'LEARNING';

  @override
  String get all_topics_label => 'ALL TOPICS';

  @override
  String get no_words_found => 'No matching words found.';

  @override
  String get choose_area => 'CHOOSE LEARNING AREA';

  @override
  String get vocab_area_desc => 'Learn by topics or search A-Z dictionary';

  @override
  String get grammar_area_desc => 'Grammar rules from basic to advanced';

  @override
  String get history_area_desc => 'Review the words you\'ve learned by date';

  @override
  String get learned_today_phrase => 'Today you\'ve learned';

  @override
  String learned_total_count(Object count) {
    return 'Total: $count words';
  }

  @override
  String get new_badge => 'New';

  @override
  String get expected_completion => 'Expected Completion Time';

  @override
  String get expected_exam => 'Expected Exam';

  @override
  String months_remaining(Object count) {
    return '$count months left';
  }

  @override
  String get save_and_calculate => 'Save Plan & Calculate Roadmap';

  @override
  String roadmap_saved(Object goal) {
    return 'Roadmap saved: $goal';
  }

  @override
  String get month_1 => 'Jan';

  @override
  String get month_2 => 'Feb';

  @override
  String get month_3 => 'Mar';

  @override
  String get month_4 => 'Apr';

  @override
  String get month_5 => 'May';

  @override
  String get month_6 => 'Jun';

  @override
  String get month_7 => 'Jul';

  @override
  String get month_8 => 'Aug';

  @override
  String get month_9 => 'Sep';

  @override
  String get month_10 => 'Oct';

  @override
  String get month_11 => 'Nov';

  @override
  String get month_12 => 'Dec';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get loading => 'Loading...';

  @override
  String get someone => 'you';

  @override
  String get more_than => 'More than';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get topics_title => 'Learning';

  @override
  String get reminder_settings_desc =>
      'Select a time when you\'d like us to remind you for daily study!';

  @override
  String get save_settings => 'Save Settings';

  @override
  String get communication => 'Communication';

  @override
  String get practical_examples => 'Practical Examples';

  @override
  String get grammar_desc =>
      'Learn English grammar from basic to advanced with real-world examples.';

  @override
  String get login => 'Login';

  @override
  String get error => 'Error';

  @override
  String get register => 'Register';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get vocabulary_exercise => 'Vocabulary Exercise';

  @override
  String get instruction_multiple_choice => 'Choose the correct meaning:';

  @override
  String get instruction_reverse_choice => 'Choose the English word for:';

  @override
  String get instruction_fill_blank => 'Type the English word for:';

  @override
  String get instruction_listening => 'Listen and choose the correct answer:';

  @override
  String get question_label_default => 'Question:';

  @override
  String get practice => 'Practice';

  @override
  String get practice_now => 'Practice Now';

  @override
  String get quiz_finished => 'Quiz finished!';

  @override
  String get question => 'Question';

  @override
  String get enter_answer => 'Enter your answer...';

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect!';

  @override
  String get next => 'Next';

  @override
  String get check => 'Check';
}
