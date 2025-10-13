import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/widgets/app_header.dart';
import '../services/authentication_service.dart';

class PatternSetupScreen extends StatefulWidget {
  final VoidCallback? onSetupComplete;
  final bool isChange;
  final bool isFirstTimeSetup;

  const PatternSetupScreen({
    super.key,
    this.onSetupComplete,
    this.isChange = false,
    this.isFirstTimeSetup = false,
  });

  @override
  State<PatternSetupScreen> createState() => _PatternSetupScreenState();
}

class _PatternSetupScreenState extends State<PatternSetupScreen> {
  List<int> _currentPattern = [];
  List<int> _confirmPattern = [];
  bool _isConfirming = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _statusMessage;

  Future<void> _setupPattern() async {
    if (_currentPattern.length < 4) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.patternTooShort;
      });
      return;
    }

    if (!_isConfirming) {
      setState(() {
        _isConfirming = true;
        _confirmPattern.clear();
        _errorMessage = null;
        _statusMessage = AppLocalizations.of(context)!.confirmPattern;
      });
      return;
    }

    if (_currentPattern.join() != _confirmPattern.join()) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.patternsDoNotMatch;
        _isConfirming = false;
        _currentPattern.clear();
        _confirmPattern.clear();
        _statusMessage = AppLocalizations.of(context)!.drawPattern;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthenticationService();
      await authService.setupPattern(_currentPattern.join());
      
      if (widget.isChange) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        widget.onSetupComplete?.call();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onPatternDrawn(List<int> pattern) {
    setState(() {
      if (_isConfirming) {
        _confirmPattern = List.from(pattern);
      } else {
        _currentPattern = List.from(pattern);
      }
      _errorMessage = null;
    });
  }

  void _clearPattern() {
    setState(() {
      if (_isConfirming) {
        _confirmPattern.clear();
      } else {
        _currentPattern.clear();
      }
      _errorMessage = null;
    });
  }

  void _resetSetup() {
    setState(() {
      _currentPattern.clear();
      _confirmPattern.clear();
      _isConfirming = false;
      _errorMessage = null;
      _statusMessage = AppLocalizations.of(context)!.drawPattern;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isChange 
          ? AppLocalizations.of(context)!.changePattern 
          : AppLocalizations.of(context)!.setupPattern),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _resetSetup,
              child: Text(AppLocalizations.of(context)!.reset),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isFirstTimeSetup) const AppHeader(),
            if (widget.isFirstTimeSetup) const SizedBox(height: 8),
            Text(
              _statusMessage ?? AppLocalizations.of(context)!.drawPattern,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            PatternGrid(
              onPatternDrawn: _onPatternDrawn,
              currentPattern: _isConfirming ? _confirmPattern : _currentPattern,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _clearPattern,
                  child: Text(AppLocalizations.of(context)!.clear),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _setupPattern,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isConfirming 
                          ? AppLocalizations.of(context)!.confirm
                          : AppLocalizations.of(context)!.next),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PatternGrid extends StatefulWidget {
  final Function(List<int>) onPatternDrawn;
  final List<int> currentPattern;
  final bool enabled;

  const PatternGrid({
    super.key,
    required this.onPatternDrawn,
    required this.currentPattern,
    this.enabled = true,
  });

  @override
  State<PatternGrid> createState() => _PatternGridState();
}

class _PatternGridState extends State<PatternGrid> {
  final List<int> _selectedDots = [];
  bool _isDrawing = false;

  void _onDotTapped(int index) {
    if (!widget.enabled || _selectedDots.contains(index)) return;
    
    setState(() {
      _selectedDots.add(index);
    });
    widget.onPatternDrawn(_selectedDots);
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.enabled) return;
    _isDrawing = true;
    _selectedDots.clear();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enabled || !_isDrawing) return;
    
    // Find which dot is under the current position
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    // Calculate which dot based on position (simplified)
    final gridSize = 200.0; // Approximate grid size
    final dotSize = gridSize / 3;
    final col = (localPosition.dx / dotSize).floor();
    final row = (localPosition.dy / dotSize).floor();
    
    if (col >= 0 && col < 3 && row >= 0 && row < 3) {
      final index = row * 3 + col;
      if (!_selectedDots.contains(index)) {
        setState(() {
          _selectedDots.add(index);
        });
        widget.onPatternDrawn(_selectedDots);
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _isDrawing = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: 200,
        height: 200,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final isSelected = widget.currentPattern.contains(index);
            return GestureDetector(
              onTap: () => _onDotTapped(index),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.3),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}