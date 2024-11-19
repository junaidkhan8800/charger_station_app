import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth _auth;
  String? _verificationId;

  OtpBloc(this._auth) : super(OtpInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(OtpLoading());
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            emit(OtpVerified());
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(OtpError(e.message ?? 'Verification failed'));
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            emit(OtpSent());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } catch (e) {
        emit(OtpError('Error sending OTP'));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(OtpLoading());
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: event.otp,
        );
        await _auth.signInWithCredential(credential);
        emit(OtpVerified());
      } catch (e) {
        emit(OtpError('Invalid OTP'));
      }
    });
  }
}
