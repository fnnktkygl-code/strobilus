import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/enum_extensions.dart';
import '../../../core/theme/design_system.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import '../../../data/models/pine_cone_model.dart';
import '../../../presentation/providers/collection_provider.dart';
import '../../widgets/common/strobilus_snack_bar.dart';

class EditConePage extends StatefulWidget {
  final String coneId;

  const EditConePage({super.key, required this.coneId});

  @override
  State<EditConePage> createState() => _EditConePageState();
}

class _EditConePageState extends State<EditConePage> {
  final _formKey = GlobalKey<FormState>();

  late PineConeModel _cone;
  bool _isLoading = false;

  late TextEditingController _commonNameController;
  late TextEditingController _scientificNameController;
  late TextEditingController _personalNotesController;
  late TextEditingController _locationNameController;

  ConeSize _selectedSize = ConeSize.m;
  ConeCondition _selectedCondition = ConeCondition.good;
  ConeRarity _selectedRarity = ConeRarity.common;

  @override
  void initState() {
    super.initState();
    final collection = context.read<CollectionProvider>();
    final coneOpt = collection.getConeById(widget.coneId);

    if (coneOpt == null) {
      // In a real app, we'd handle this more gracefully
      throw Exception('Cone not found');
    }
    _cone = coneOpt;

    _commonNameController = TextEditingController(text: _cone.commonName);
    _scientificNameController = TextEditingController(
      text: _cone.scientificName ?? '',
    );
    _personalNotesController = TextEditingController(
      text: _cone.personalNotes ?? '',
    );
    _locationNameController = TextEditingController(text: _cone.locationName);

    _selectedSize = _cone.size;
    _selectedCondition = _cone.condition;
    _selectedRarity = _cone.rarity;
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _scientificNameController.dispose();
    _personalNotesController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  Future<void> _saveCone() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedCone = _cone.copyWith(
      commonName: _commonNameController.text.trim(),
      scientificName: _scientificNameController.text.trim().isNotEmpty
          ? _scientificNameController.text.trim()
          : null,
      locationName: _locationNameController.text.trim().isNotEmpty
          ? _locationNameController.text.trim()
          : AppLocalizations.of(context).unknownLocation,
      personalNotes: _personalNotesController.text.trim().isNotEmpty
          ? _personalNotesController.text.trim()
          : null,
      size: _selectedSize,
      condition: _selectedCondition,
      rarity: _selectedRarity,
    );

    try {
      await context.read<CollectionProvider>().updateCone(updatedCone);
      if (mounted) {
        context.pop();
        StrobilusSnackBar.success(context, AppLocalizations.of(context).coneUpdatedSuccess);
      }
    } catch (e) {
      if (mounted) {
        StrobilusSnackBar.error(context, AppLocalizations.of(context).errorGeneric);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editConeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveCone,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DS.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _commonNameController,
                      decoration: InputDecoration(
                        labelText: l10n.commonNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.errorFieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: DS.md),
                    TextFormField(
                      controller: _scientificNameController,
                      decoration: InputDecoration(
                        labelText: l10n.scientificNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: DS.md),
                    TextFormField(
                      controller: _locationNameController,
                      decoration: InputDecoration(
                        labelText: l10n.locationNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: DS.lg),

                    DropdownButtonFormField<ConeSize>(
                      initialValue: _selectedSize,
                      decoration: InputDecoration(
                        labelText: l10n.sizeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: ConeSize.values.map((size) {
                        return DropdownMenuItem(
                          value: size,
                          child: Text(size.label(context)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSize = val);
                      },
                    ),
                    const SizedBox(height: DS.md),

                    DropdownButtonFormField<ConeCondition>(
                      initialValue: _selectedCondition,
                      decoration: InputDecoration(
                        labelText: l10n.conditionLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: ConeCondition.values.map((cond) {
                        return DropdownMenuItem(
                          value: cond,
                          child: Text(cond.label(context)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCondition = val);
                        }
                      },
                    ),
                    const SizedBox(height: DS.md),

                    DropdownButtonFormField<ConeRarity>(
                      initialValue: _selectedRarity,
                      decoration: InputDecoration(
                        labelText: l10n.rarityLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: ConeRarity.values.map((rarity) {
                        return DropdownMenuItem(
                          value: rarity,
                          child: Text(rarity.label(context)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedRarity = val);
                      },
                    ),
                    const SizedBox(height: DS.lg),

                    TextFormField(
                      controller: _personalNotesController,
                      decoration: InputDecoration(
                        labelText: l10n.personalNotes,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                        hintText: l10n.notesHint,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: DS.xxxl),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveCone,
                        child: Text(l10n.saveChanges),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
