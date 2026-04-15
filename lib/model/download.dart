import 'package:signals/signals.dart';

final isLoading = signal(false);
final errorMessage = signal<String?>(null);