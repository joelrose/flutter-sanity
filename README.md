# Dart Sanity.io

This Dart package is a small abstraction on top of the Sanity.io API.

## Installation 

```sh
dart pub add flutter_sanity
```

## Example

```dart
// main.dart
import 'package:flutter_sanity/flutter_sanity.dart';

void main() async {
  final sanityClient = SanityClient(
    dataset: 'dataSet',
    projectId: 'projectId',
  );

  final response = await sanityClient.fetch('*[_type == "post"]');

  print(response);
}
```

Credits to: https://gist.github.com/ameistad/2c6eec79a62c7f4d08d051ef4ef14ba0