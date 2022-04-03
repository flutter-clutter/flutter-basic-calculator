import './unit/calculation_bloc.dart' as calculation_bloc;
import './unit/calculation_history_service.dart'
    as calculation_history_container;
import './widget/calculation.dart' as calculation_widget;

void main() {
  calculation_bloc.main();
  calculation_history_container.main();
  calculation_widget.main();
}
