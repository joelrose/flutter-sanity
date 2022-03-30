import 'package:flutter_sanity/flutter_sanity.dart';

void main() async {
  final sanityClient = SanityClient(
    dataset: 'dataSet',
    projectId: 'projectId',
  );

  final response = await sanityClient.fetch('*[_type == "post"]');

  print(response);
}
