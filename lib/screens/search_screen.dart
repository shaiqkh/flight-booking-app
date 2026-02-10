import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/search_provider.dart';
import '../providers/flight_provider.dart';
import '../utils/helpers.dart';
import '../widgets/airport_autocomplete.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int tripType = 0; // 0=oneway,1=round,2=multi
  DateTime? departDate;
  DateTime? returnDate;
  bool zeroCancellation = false;

  int travelers = 1;
  String selectedClass = "Economy";
  String? selectedSpecialFare;


  // Available travel classes
  final List<String> travelClasses = [
    "Economy",
    "Premium Economy",
    "Business",
  ];

  void _validateAndSearch() async {
    final searchProvider = context.read<SearchProvider>();
    final flightProvider = context.read<FlightProvider>();

    // Validate inputs
    final error = searchProvider.validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    if (searchProvider.tripType == TripType.multiCity) {
      final error = searchProvider.validateMultiCity();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        return;
      }
    }


    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );

    try {
      print(' Starting search...');
      print('From: ${searchProvider.request.origin} To: ${searchProvider.request.destination}');

      await flightProvider.search(searchProvider.request);

      print(' Found ${flightProvider.flights.length} flights');

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Now navigate to results
      if (mounted) {
        Navigator.pushNamed(context, '/results');
      }
    } catch (e) {
      print('Search error: $e');

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showTravelClassBottomSheet() {
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
                  const Text(
                    "Select Travellers & Class",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Travelers Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Travelers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (travelers > 1) {
                                setModalState(() => travelers--);
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.blue,
                          ),
                          Text(
                            '$travelers',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (travelers < 9) {
                                setModalState(() => travelers++);
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(),
                  const SizedBox(height: 5),

                  // Travel Class Selection
                  const Text(
                    "Travel Class",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...travelClasses.map((travelClass) {
                    final bool isSelected = selectedClass == travelClass;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() => selectedClass = travelClass);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected ? Colors.blue.shade50 : Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              travelClass,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 10),

                  // Done Button
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
                        setState(() {
                          // Update main state
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Done",
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
  /* ---------------- CUSTOM TAB ---------------- */

  Widget _tripTab(String text, int index) {
    final bool selected = tripType == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => tripType = index);
          final p = context.read<SearchProvider>();
          if (index == 0) p.setTripType(TripType.oneWay);
          if (index == 1) p.setTripType(TripType.roundTrip);
          if (index == 2) p.setTripType(TripType.multiCity);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
            color: selected ? Colors.white : Colors.grey.shade50,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? Colors.blue : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${date.day} ${months[date.month - 1]}, ${days[date.weekday - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Flight Search",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ---------------- TRIP TYPE TABS ---------------- */
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _tripTab("One way", 0),
                  const SizedBox(width: 8),
                  _tripTab("Roundtrip", 1),
                  const SizedBox(width: 8),
                  _tripTab("Multicity", 2),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /* ---------------- ONE WAY / ROUND TRIP ---------------- */
            if (tripType != 2) ...[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AirportAutocomplete(
                            label: "FROM",
                            onSelected: (v) =>
                                context.read<SearchProvider>().setOrigin(v),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          child: Icon(
                            Icons.swap_horiz,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: AirportAutocomplete(
                            label: "TO",
                            onSelected: (v) => context
                                .read<SearchProvider>()
                                .setDestination(v),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _DateTile(
                            title: "DEPARTURE DATE",
                            date: departDate,
                            onTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                                initialDate: DateTime.now(),
                              );
                              if (d != null) {
                                setState(() => departDate = d);
                                context.read<SearchProvider>().setDepartureDate(
                                  Helpers.formatDateForApi(d),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (tripType == 0) ...[
                          Expanded(
                            child: _DateTile(
                              title: "RETURN DATE",
                              date: returnDate,
                              addReturnText: returnDate == null,
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  firstDate: departDate ?? DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                  initialDate: departDate ?? DateTime.now(),
                                );
                                if (d != null) {
                                  setState(() => returnDate = d);
                                  context.read<SearchProvider>().setReturnDate(
                                    Helpers.formatDateForApi(d),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                        if (tripType == 1) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DateTile(
                              title: "RETURN DATE",
                              date: returnDate,
                              addReturn: returnDate == null,
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  firstDate: departDate ?? DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                  initialDate: departDate ?? DateTime.now(),
                                );
                                if (d != null) {
                                  setState(() => returnDate = d);
                                  context.read<SearchProvider>().setReturnDate(
                                    Helpers.formatDateForApi(d),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],

            /* ---------------- MULTICITY UI ---------------- */
            if (tripType == 2) ...[
              Consumer<SearchProvider>(
                builder: (context, sp, _) {
                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sp.multiCityLegs.length,
                          itemBuilder: (context, index) {
                            final leg = sp.multiCityLegs[index];

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AirportAutocomplete(
                                        label: "FROM",
                                        onSelected: (v) {
                                          sp.updateLegFrom(index, v);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: AirportAutocomplete(
                                        label: "TO",
                                        onSelected: (v) {
                                          sp.updateLegTo(index, v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                        initialDate: DateTime.now(),
                                      );
                                      if (d != null) {
                                        sp.updateLegDate(index, d);
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "DATE",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          leg.date == null
                                              ? "Select Date"
                                              : Helpers.formatDateForApi(leg.date!),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: leg.date == null
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(height: 32),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        /// ADD CITY BUTTON
                        GestureDetector(
                          onTap: () {
                            sp.addCity();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade300,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text(
                                "+ ADD CITY",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],


            const SizedBox(height: 8),

            /* ---------------- TRAVELLER & CLASS (UPDATED WITH DROPDOWN) ---------------- */
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _showTravelClassBottomSheet,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TRAVELLER & CLASS",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$travelers Traveller${travelers > 1 ? 's' : ''} • $selectedClass",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            /* ---------------- SPECIAL FARES ---------------- */
            // Container(
            //   color: Colors.white,
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         "SPECIAL FARES",
            //         style: TextStyle(
            //           fontSize: 10,
            //           color: Colors.grey,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       Row(
            //         children: const [
            //           Expanded(
            //             child: _FareChip("Student", "Extra discounts/baggage"),
            //           ),
            //           SizedBox(width: 8),
            //           Expanded(
            //             child: _FareChip("Senior Citizen", "Up to ₹ 600 off"),
            //           ),
            //           SizedBox(width: 8),
            //           Expanded(
            //             child: _FareChip("Armed Forces", "Up to ₹ 600 off"),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SPECIAL FARES",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SelectableFareChip(
                          title: "Student",
                          subtitle: "Extra discounts/baggage",
                          selected: selectedSpecialFare == "Student",
                          onTap: () {
                            setState(() {
                              selectedSpecialFare =
                              selectedSpecialFare == "Student" ? null : "Student";
                            });

                            context
                                .read<SearchProvider>()
                                .selectSpecialFare(selectedSpecialFare);
                          },
                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        child: _SelectableFareChip(
                          title: "Senior Citizen",
                          subtitle: "Up to ₹ 600 off",
                          selected: selectedSpecialFare == "Senior",
                          onTap: () {
                            setState(() {
                              selectedSpecialFare =
                              selectedSpecialFare == "Senior" ? null : "Senior";
                            });

                            context
                                .read<SearchProvider>()
                                .selectSpecialFare(selectedSpecialFare);
                          },
                        ),
                      ),
                      SizedBox(width: 8,),

                      Expanded(
                        child: _SelectableFareChip(
                          title: "Armed Forces",
                          subtitle: "Up to ₹ 600 off",
                          selected: selectedSpecialFare == "Armed",
                          onTap: () {
                            setState(() {
                              selectedSpecialFare =
                              selectedSpecialFare == "Armed" ? null : "Armed";
                            });

                            context
                                .read<SearchProvider>()
                                .selectSpecialFare(selectedSpecialFare);
                          },
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),


            const SizedBox(height: 8),

            /* ---------------- ZERO CANCELLATION ---------------- */
            if (tripType != 2) ...[
            Container(
              color: Colors.white,
              child: CheckboxListTile(
                value: zeroCancellation,
                onChanged: (v) {
                  setState(() => zeroCancellation = v ?? false);
                  context.read<SearchProvider>().toggleZeroCancellation(
                    v ?? false,
                  );
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue,
                title: Row(
                  children: [
                    const Text(
                      "Add Zero Cancellation",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                subtitle: const Text(
                  "Get 100% refund on cancellation",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),],

            const SizedBox(height: 16),

            /* ---------------- SEARCH BUTTON ---------------- */
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _validateAndSearch,
                  child: const Text(
                    "SEARCH FLIGHTS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- DATE TILE ---------------- */

class _DateTile extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;
  final bool addReturnText;
  final bool addReturn;

  const _DateTile({
    required this.title,
    required this.date,
    required this.onTap,
    this.addReturnText = false,
    this.addReturn = false,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${date.day} ${months[date.month - 1]}, ${days[date.weekday - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (date != null)
            Text(
              _formatDate(date!),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )
          else if (addReturnText)
            const Text(
              "+ ADD RETURN DATE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            )
          else if (addReturn)
              const Text(
                "Select Date",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              )
            else
              const Text(
                "Select Date",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
          if (addReturnText && date == null)
            const Text(
              "Save more on round trips!",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

class _SelectableFareChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableFareChip({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.blue : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: selected ? Colors.blue : Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- FARE CHIP ---------------- */

class _FareChip extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FareChip(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}