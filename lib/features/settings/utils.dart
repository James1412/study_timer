import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_models/auto_brightness_vm.dart';

bool isAutoBrightnessControl(BuildContext context) {
  return context.watch<AutoBrightnessViewModel>().isAutoBrightnessControl;
}
