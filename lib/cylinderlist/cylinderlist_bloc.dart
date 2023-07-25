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
  factory CylinderListEvent.update(CylinderModel cylinder) => _UpdateCylinder(cylinder);
  factory CylinderListEvent.delete(UuidValue id) => _DeleteCylinder(id);
  factory CylinderListEvent.reorder(int a, int b) => _ReorderCylinders(a, b);
  factory CylinderListEvent.reset() => _ResetCylinders();
}

class _NewCylinderList extends CylinderListEvent {
  final List<CylinderModel> cylinders;
  const _NewCylinderList(this.cylinders);
}

class _UpdateCylinder extends CylinderListEvent {
  final CylinderModel cylinder;
  const _UpdateCylinder(this.cylinder);
}

class _DeleteCylinder extends CylinderListEvent {
  final UuidValue id;
  const _DeleteCylinder(this.id);
}

class _ReorderCylinders extends CylinderListEvent {
  final int a, b;
  const _ReorderCylinders(this.a, this.b);
}

class _ResetCylinders extends CylinderListEvent {
  const _ResetCylinders();
}

class CylinderListBloc extends Bloc<CylinderListEvent, CylinderListState> {
  final CylinderListService? cylinderListService = serviceLocator<CylinderListService>();

  CylinderListBloc() : super(CylinderListState([])) {
    on<_NewCylinderList>((event, emit) => emit(CylinderListState(event.cylinders)));

    on<_UpdateCylinder>((event, emit) async {
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
      emit(CylinderListState(cylinders));
    });

    on<_DeleteCylinder>((event, emit) async {
      var cylinders = state.cylinders.where((c) => c.id != event.id).toList();
      await cylinderListService!.saveCylinders(cylinders);
      emit(CylinderListState(cylinders));
    });

    on<_ReorderCylinders>((event, emit) async {
      var cylinders = state.cylinders;
      var a = cylinders[event.a];
      cylinders[event.a] = cylinders[event.b];
      cylinders[event.b] = a;
      await cylinderListService!.saveCylinders(cylinders);
      emit(CylinderListState(cylinders));
    });

    on<_ResetCylinders>((event, emit) async {
      emit(CylinderListState(await cylinderListService!.defaultCylinders()));
    });

    loadData();
  }

  void loadData() async {
    var cyls = await cylinderListService!.getCylinders();
    add(_NewCylinderList(cyls));
  }
}
