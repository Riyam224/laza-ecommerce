# Forgot Password Flow - Clean Architecture

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  ForgotPasswordScreen → ForgotPasswordCubit → ForgotPasswordState│
│  VerificationCodeScreen →         ↓                              │
│  NewPasswordScreen      →         ↓                              │
└────────────────────────────────────┼────────────────────────────┘
                                     │
┌────────────────────────────────────▼────────────────────────────┐
│                      DOMAIN LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│  ForgotPasswordUseCase → AuthRepository (interface)              │
│  VerifyOtpUseCase      → ForgotPasswordRequestEntity            │
│  ResetPasswordUseCase  → VerifyOtpRequestEntity                 │
│                        → ResetPasswordRequestEntity              │
└────────────────────────────────────┼────────────────────────────┘
                                     │
┌────────────────────────────────────▼────────────────────────────┐
│                       DATA LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│  AuthRepositoryImpl   → AuthApiService                          │
│  ForgotPasswordRequestModel (extends Entity)                    │
│  VerifyOtpRequestModel (extends Entity)                         │
│  ResetPasswordRequestModel (extends Entity)                     │
└─────────────────────────────────────────────────────────────────┘
```

## 📱 User Flow

### Step 1: Forgot Password (Email Entry)
```
ForgotPasswordScreen
    ↓
User enters email
    ↓
ForgotPasswordCubit.sendOtp()
    ↓
ForgotPasswordUseCase
    ↓
AuthRepository.forgotPassword()
    ↓
API: POST /auth/forgot-password
    ↓
ForgotPasswordSuccess (with email)
    ↓
Navigate to VerificationCodeScreen
```

### Step 2: OTP Verification
```
VerificationCodeScreen (receives email)
    ↓
User enters 4-digit OTP
    ↓
ForgotPasswordCubit.verifyOtp(email, otp)
    ↓
VerifyOtpUseCase
    ↓
AuthRepository.verifyOtp()
    ↓
API: POST /auth/verify-otp
    ↓
OtpVerificationSuccess (with email, otp)
    ↓
Navigate to NewPasswordScreen
```

### Step 3: Reset Password
```
NewPasswordScreen (receives email, otp)
    ↓
User enters new password
    ↓
ForgotPasswordCubit.resetPassword(email, otp, newPassword)
    ↓
ResetPasswordUseCase
    ↓
AuthRepository.resetPassword()
    ↓
API: POST /auth/reset-password
    ↓
ResetPasswordSuccess
    ↓
Navigate to LoginScreen
```

## 📂 File Structure

```
lib/features/auth/
├── domain/
│   ├── entities/
│   │   ├── forgot_password_request_entity.dart
│   │   ├── verify_otp_request_entity.dart
│   │   └── reset_password_request_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart (interface)
│   └── use_cases/
│       ├── forgot_password_usecase.dart
│       ├── verify_otp_usecase.dart
│       └── reset_password_usecase.dart
├── data/
│   ├── models/
│   │   └── forgot_password/
│       │       ├── forgot_password_request_model.dart
│       │       ├── forgot_password_request_model.g.dart
│       │       ├── verify_otp_request_model.dart
│       │       ├── verify_otp_request_model.g.dart
│       │       ├── reset_password_request_model.dart
│       │       └── reset_password_request_model.g.dart
│   ├── repositories/
│   │   └── auth_repository_impl.dart
│   └── data_sources/
│       └── auth_api_service.dart
└── presentation/
    ├── cubit/
    │   ├── forgot_password_cubit.dart
    │   └── forgot_password_state.dart
    └── screens/
        ├── forgot_password_screen.dart
        ├── verification_code_screen.dart
        └── new_password_screen.dart
```

## 🎯 States

### ForgotPasswordState (Unified)

**Email Step:**
- `ForgotPasswordInitial` - Initial state
- `ForgotPasswordLoading` - Sending OTP
- `ForgotPasswordSuccess(email)` - OTP sent successfully
- `ForgotPasswordError(message)` - Error sending OTP

**OTP Verification:**
- `OtpVerificationLoading` - Verifying OTP
- `OtpVerificationSuccess(email, otp)` - OTP verified
- `OtpVerificationError(message)` - Invalid OTP

**Password Reset:**
- `ResetPasswordLoading` - Resetting password
- `ResetPasswordSuccess` - Password reset successfully
- `ResetPasswordError(message)` - Error resetting password

## 🔑 Key Components

### 1. **Entities (Domain Layer)**
```dart
// Pure business logic, framework-independent
ForgotPasswordRequestEntity(email)
VerifyOtpRequestEntity(email, otp)
ResetPasswordRequestEntity(email, otp, newPassword)
```

### 2. **Models (Data Layer)**
```dart
// Extend entities, add JSON serialization
@JsonSerializable()
class ForgotPasswordRequestModel extends ForgotPasswordRequestEntity {
  Map<String, dynamic> toJson()
  factory fromEntity(Entity)
}
```

### 3. **Use Cases (Domain Layer)**
```dart
// Single responsibility per operation
ForgotPasswordUseCase.call(entity) → Future<void>
VerifyOtpUseCase.call(entity) → Future<void>
ResetPasswordUseCase.call(entity) → Future<void>
```

### 4. **Cubit (Presentation Layer)**
```dart
// Unified cubit for all 3 steps
ForgotPasswordCubit {
  sendOtp(email)
  verifyOtp(email, otp)
  resetPassword(email, otp, newPassword)
}
```

## 🔄 Data Flow

```
User Input (Screen)
    ↓
Cubit Method
    ↓
Entity Created
    ↓
Use Case Called
    ↓
Repository Method
    ↓
Model Created from Entity
    ↓
API Call
    ↓
Success/Error State Emitted
    ↓
UI Updates
```

## ✨ Benefits

1. **Single Cubit Pattern** - One cubit manages the entire flow, maintaining state across screens
2. **Type Safety** - Entities and models ensure type-safe data flow
3. **Separation of Concerns** - Each layer has a single responsibility
4. **Testability** - Easy to mock dependencies and test in isolation
5. **Maintainability** - Clear structure makes changes easy
6. **Reusability** - Use cases can be reused across different features
7. **Error Handling** - Centralized error handling in cubit

## 🛠️ API Endpoints

```dart
POST /auth/forgot-password    // Send OTP to email
POST /auth/verify-otp          // Verify OTP code
POST /auth/reset-password      // Reset password with OTP
```

## 📋 Implementation Checklist

✅ Domain Entities Created
✅ Data Models with JSON Serialization
✅ API Endpoints Added
✅ Repository Interface Updated
✅ Repository Implementation
✅ Use Cases Created
✅ Unified Cubit & States
✅ Dependency Injection
✅ Build Runner Generated Files
⬜ Update ForgotPasswordScreen with Cubit
⬜ Update VerificationCodeScreen with Cubit
⬜ Update NewPasswordScreen with Cubit
⬜ Add Navigation Between Screens

## 🔐 Security Notes

- OTP is passed between screens but never stored permanently
- Password is only sent once during reset
- All API calls use HTTPS
- Error messages don't expose sensitive information

## 🚀 Next Steps

1. Update screens to use ForgotPasswordCubit
2. Pass email/otp between screens via navigation
3. Handle success/error states in UI
4. Add loading indicators
5. Navigate to login after successful reset
