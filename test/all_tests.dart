import './unit/calculation_bloc.dart' as calculation_bloc;
import './widget/calculation.dart' as calculation_widget;
import './unit/calculation_history_service.dart' as calculation_history_container;

void main() {
  calculation_bloc.main();
  calculation_history_container.main();
  calculation_widget.main();
}