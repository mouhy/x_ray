import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Cached request
  late Future<List<dynamic>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = ApiService.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        title: Text(
          AppLocalizations.of(context)!.history,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Build by state
      body: FutureBuilder<List<dynamic>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString().replaceFirst('Exception: ', ''),
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final reports = snapshot.data ?? [];

          // Empty state
          if (reports.isEmpty) {
            return const Center(
              child: Text(
                "No reports yet",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          // Data state
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final r = reports[index] as Map<String, dynamic>;

              final disease = r["primaryDisease"]?.toString() ?? "—";
              final status = r["status"]?.toString() ?? "";
              // To percent (handle 0-1 or 0-100 scale)
              final rawConf = (r["overallConfidence"] as num?)?.toDouble() ?? 0;
              final confidence = rawConf <= 1 ? rawConf * 100 : rawConf;
              // Trim date
              final date = r["createdAt"]?.toString().split('T').first ?? "";

              return Card(
                color: const Color(0xff1E293B),
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    status == "Healthy" ? Icons.check_circle : Icons.warning,
                    color: status == "Healthy" ? Colors.green : Colors.orange,
                  ),
                  title: Text(
                    "$disease  •  ${confidence.toStringAsFixed(1)}%",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "$status   -   $date",
                    style: const TextStyle(color: Colors.white60),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
