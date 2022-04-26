import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../models/cylinder_model.dart';
import '../services/cylinderlist_service.dart';
import '../services/service_locator.dart';

class CylinderListState {
  final List<CylinderModel> cylinders;
  const CylinderListState(this.cylinders);

  List<CylinderModel> get selectedCylinders => cylinders.where((c) => c.selected).toList();
}

class CylinderListEvent {
  const CylinderListEvent();
}

class _NewCylinderList extends CylinderListEvent {
  final List<CylinderModel> cylinders;
  const _NewCylinderList(this.cylinders);
}

class UpdateCylinder extends CylinderListEvent {
  final CylinderModel cylinder;
  const UpdateCylinder(this.cylinder);
}

class DeleteCylinder extends CylinderListEvent {
  final UuidValue id;
  const DeleteCylinder(this.id);
}

class Reordercylinders extends CylinderListEvent {
  final int a, b;
  const Reordercylinders(this.a, this.b);
}

class CylinderListBloc extends Bloc<CylinderListEvent, CylinderListState> {
  final CylinderListService? cylinderListService = serviceLocator<CylinderListService>();

  CylinderListBloc() : super(CylinderListState([])) {
    loadData();
  }

  void loadData() async {
    var cyls = await cylinderListService!.getCylinders();
    add(_NewCylinderList(cyls));
  }

  @override
  Stream<CylinderListState> mapEventToState(CylinderListEvent event) async* {
    if (event is _NewCylinderList) {
      yield CylinderListState(event.cylinders);
    }

    if (event is UpdateCylinder) {
      bool updated = false;
      var cylinders = state.cylinders.map((c) {
        if (c.id == event.cylinder.id) {
          updated = true;
          return event.cylinder;
        } else
          return c;
      }).toList();
      if (!updated) {
        cylinders.add(event.cylinder);
      }
      await cylinderListService!.saveCylinders(cylinders);
      yield CylinderListState(cylinders);
    }

    if (event is DeleteCylinder) {
      var cylinders = state.cylinders.where((c) => c.id != event.id).toList();
      await cylinderListService!.saveCylinders(cylinders);
      yield CylinderListState(cylinders);
    }

    if (event is Reordercylinders) {
      var b = event.b;
      state.cylinders.insert(b, state.cylinders.removeAt(event.a));
      await cylinderListService!.saveCylinders(state.cylinders);
      yield CylinderListState(state.cylinders);
    }
  }
}
