import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'services/api_service.dart';
import 'result_screen.dart';

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

  // Open report
  Future<void> _openReport(BuildContext context, Map<String, dynamic> r) async {
    final id = r["id"]?.toString();
    if (id == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final report = await ApiService.getReportById(id);
      if (!context.mounted) return;
      Navigator.pop(context); // close loader

      final disease =
          report["primaryDisease"]?.toString() ?? "No disease detected";
      final rawConf = (report["overallConfidence"] as num?)?.toDouble() ?? 0;
      final conf = rawConf <= 1 ? rawConf * 100 : rawConf;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            name: "",
            age: "",
            gender: "",
            maritalStatus: "",
            email: "",
            diagnosis: disease,
            confidence: conf,
            reportId: id,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
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
                  onTap: () => _openReport(context, r),
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
