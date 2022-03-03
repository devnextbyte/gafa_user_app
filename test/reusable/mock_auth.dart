import 'package:gafamoney/state/auth_state.dart';
import 'package:mockito/mockito.dart';

class MockAuthState extends Mock implements AuthState {
  MockAuthState(){
    when(this.balance).thenReturn(500.25);
    when(this.token).thenAnswer((i) async => "dummy");
  }
}
