import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flight_provider.dart';
import '../widgets/flight_card.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String? selectedClass;
  int? selectedStops;
  String sortBy = "price_asc";

  void _showFilterBottomSheet() {
    final provider = context.read<FlightProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.clearFilters();
                          setModalState(() {
                            selectedClass = null;
                            selectedStops = null;
                          });
                          setState(() {});
                        },
                        child: const Text("Clear All"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Travel Class Filter
                  if (provider.availableClasses.isNotEmpty) ...[
                    const Text(
                      "Travel Class",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.availableClasses.map((travelClass) {
                        final isSelected = selectedClass == travelClass;
                        return FilterChip(
                          label: Text(travelClass),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              selectedClass = selected ? travelClass : null;
                            });
                            setState(() {});
                            provider.filterByClass(selectedClass);
                          },
                          selectedColor: Colors.blue.shade100,
                          checkmarkColor: Colors.blue,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Stops Filter
                  const Text(
                    "Stops",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text("Non-stop"),
                        selected: selectedStops == 0,
                        onSelected: (selected) {
                          setModalState(() {
                            selectedStops = selected ? 0 : null;
                          });
                          setState(() {});
                          if (selected) {
                            provider.filterByStops(0);
                          } else {
                            provider.clearFilters();
                          }
                        },
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue,
                      ),
                      FilterChip(
                        label: const Text("1 Stop"),
                        selected: selectedStops == 1,
                        onSelected: (selected) {
                          setModalState(() {
                            selectedStops = selected ? 1 : null;
                          });
                          setState(() {});
                          if (selected) {
                            provider.filterByStops(1);
                          } else {
                            provider.clearFilters();
                          }
                        },
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    final provider = context.read<FlightProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sort By",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                title: const Text("Price: Low to High"),
                leading: Radio<String>(
                  value: "price_asc",
                  groupValue: sortBy,
                  onChanged: (value) {
                    setState(() => sortBy = value!);
                    provider.sortByPrice(true);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Price: High to Low"),
                leading: Radio<String>(
                  value: "price_desc",
                  groupValue: sortBy,
                  onChanged: (value) {
                    setState(() => sortBy = value!);
                    provider.sortByPrice(false);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Flight Results",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.black),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: Consumer<FlightProvider>(
        builder: (context, provider, child) {
          // ⭐ Only show loading for SEARCH, not details
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (provider.flights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No flights found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try adjusting your filters",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filter chips display
              if (selectedClass != null || selectedStops != null)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (selectedClass != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(selectedClass!),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() => selectedClass = null);
                              provider.clearFilters();
                            },
                            backgroundColor: Colors.blue.shade50,
                          ),
                        ),
                      if (selectedStops != null)
                        Chip(
                          label: Text(
                            selectedStops == 0 ? "Non-stop" : "$selectedStops Stop",
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() => selectedStops = null);
                            provider.clearFilters();
                          },
                          backgroundColor: Colors.blue.shade50,
                        ),
                    ],
                  ),
                ),

              // Results count
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${provider.flights.length} flights found",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Flight list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: provider.flights.length,
                  itemBuilder: (context, index) {
                    final flight = provider.flights[index];
                    return FlightCard(
                      flight: flight,
                      onTap: () {
                        print('Flight tapped: ${flight.id}');
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: flight.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}