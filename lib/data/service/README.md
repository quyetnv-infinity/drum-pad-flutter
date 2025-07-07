# SoLoud Service

## Overview

The `SoLoudService` is a singleton service that manages SoLoud audio engine initialization and provides a centralized way to handle audio operations throughout the app.

## Features

- **Singleton Pattern**: Ensures only one instance of SoLoud is created and managed
- **Automatic Initialization**: Handles SoLoud initialization automatically when needed
- **Centralized Audio Operations**: Provides methods for loading, playing, and disposing audio
- **Error Handling**: Includes proper error handling and logging

## Usage

### Basic Usage

```dart
// Get the service instance
final soloudService = SoLoudService.instance;

// Initialize (usually done in main.dart)
await soloudService.initialize();

// Load audio file
final audioSource = await soloudService.loadFile('path/to/audio.mp3');

// Play audio
final handle = await soloudService.play(audioSource);

// Stop audio
soloudService.stop(handle);

// Dispose audio source
soloudService.disposeSource(audioSource);
```

### In Drum Pad Widget

The drum pad widget has been refactored to use the SoLoud service:

```dart
class _DrumPadScreenState extends State<DrumPadScreen> {
  late SoLoudService _soloudService;

  @override
  void initState() {
    super.initState();
    _soloudService = SoLoudService.instance;
    _initializeSoloud();
    // ... rest of initialization
  }

  Future<void> _initializeSoloud() async {
    try {
      await _soloudService.initialize();
    } catch (e) {
      print('Error initializing SoLoud: $e');
    }
  }

  Future<void> _playSound(String sound) async {
    if (!_soloudService.isInitialized) return;
    
    // Use service methods instead of direct SoLoud calls
    if (audioSources.containsKey(sound)) {
      final handle = await _soloudService.play(audioSources[sound]!);
      currentlyPlayingSounds[sound] = handle;
    }
  }
}
```

## Service Locator Integration

The SoLoud service is registered in the service locator for dependency injection:

```dart
// In ServiceLocator.initialise()
registerSingletonIfNeeded(SoLoudService.instance);
```

## App Initialization

The service is initialized early in the app lifecycle in `main.dart`:

```dart
await Future.wait([
  // ... other initialization
  SoLoudService.instance.initialize(),
].toList());
```

## Benefits of This Refactoring

1. **Single Instance**: Only one SoLoud instance is created and managed
2. **Better Resource Management**: Centralized audio resource handling
3. **Easier Testing**: Service can be mocked for testing
4. **Consistent API**: Provides a clean, consistent interface for audio operations
5. **Error Handling**: Centralized error handling for audio operations

## Migration Notes

- All direct `SoLoud.instance` calls have been replaced with service method calls
- The service automatically handles initialization when needed
- Audio resource disposal is now handled through the service
- The service provides the same functionality as direct SoLoud calls but with better management 
 