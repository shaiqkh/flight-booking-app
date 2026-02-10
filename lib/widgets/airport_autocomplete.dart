import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/airport_provider.dart';
import '../models/airport_model.dart';

class AirportAutocomplete extends StatefulWidget {
  final String label;
  final ValueChanged<String> onSelected;

  const AirportAutocomplete({
    super.key,
    required this.label,
    required this.onSelected,
  });

  @override
  State<AirportAutocomplete> createState() => _AirportAutocompleteState();
}

class _AirportAutocompleteState extends State<AirportAutocomplete> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<AirportModel> suggestions = [];
  AirportModel? selectedAirport;
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();

    // Load airports after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AirportProvider>();
      if (provider.airports.isEmpty && !provider.loading) {
        provider.loadAirports();
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => showSuggestions = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final provider = context.read<AirportProvider>();
    setState(() {
      showSuggestions = value.isNotEmpty;
      suggestions = provider.searchAirport(value);
    });
  }

  void _selectAirport(AirportModel airport) {
    setState(() {
      selectedAirport = airport;
      showSuggestions = false;
    });
    _controller.clear();
    widget.onSelected(airport.code);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),

        // Display selected airport or input field
        if (selectedAirport != null)
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAirport = null;
                showSuggestions = false;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${selectedAirport!.city} ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      selectedAirport!.code,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  selectedAirport!.name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        else
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: widget.label == "FROM" ? "Delhi" : "Mumbai",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

        // Suggestions dropdown
        if (showSuggestions && suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: suggestions.length > 5 ? 5 : suggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (_, i) {
                final airport = suggestions[i];
                return ListTile(
                  dense: true,
                  onTap: () => _selectAirport(airport),
                  title: Text(
                    "${airport.city} (${airport.code})",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    airport.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}