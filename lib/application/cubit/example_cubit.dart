import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kopianan_boilerplate/domain/example/i_get_data.dart';

part 'example_state.dart';
part 'example_cubit.freezed.dart';

@Injectable()
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit(this.iExample) : super(const ExampleState.initial());
  IExample iExample;
  void getData() {
    iExample.getData();
  }
}
