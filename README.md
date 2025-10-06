# Laza - E-commerce Authentication App

A Flutter e-commerce application implementing a complete authentication system with clean architecture principles.

## Features

- **User Registration** - Create new account with username, email, and password
- **User Login** - Sign in with email and password
- **Forgot Password Flow** - Complete password recovery system:
  - Email verification
  - 6-digit OTP validation
  - New password creation
- **Navigation** - Seamless routing between authentication screens
- **State Management** - BLoC/Cubit pattern for reactive UI
- **Clean Architecture** - Separation of concerns across Domain, Data, and Presentation layers

## Architecture

This project follows **Clean Architecture** principles with three main layers:

### 1. Domain Layer
- **Entities**: Pure Dart classes representing business models
- **Repositories**: Abstract interfaces defining contracts
- **Use Cases**: Business logic implementation

### 2. Data Layer
- **Models**: JSON-serializable data classes extending domain entities
- **Data Sources**: API service implementations
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer
- **Screens**: UI components
- **Cubits**: State management logic
- **States**: UI state definitions

```
lib/
├── core/
│   ├── common_ui/         # Reusable widgets
│   ├── constants/         # App constants
│   ├── networking/        # API client setup
│   ├── routing/          # Navigation configuration
│   ├── theming/          # App theme
│   └── di.dart           # Dependency injection
│
└── features/
    └── auth/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── use_cases/
        ├── data/
        │   ├── models/
        │   ├── data_sources/
        │   └── repositories/
        └── presentation/
            ├── screens/
            ├── cubit/
            └── widgets/
```

## Tech Stack

- **Flutter** - UI framework
- **flutter_bloc** (^8.1.6) - State management using BLoC/Cubit pattern
- **dio** (^5.7.0) - HTTP client for API calls
- **retrofit** (^5.0.0) - Type-safe HTTP client
- **json_annotation** (^4.9.0) - JSON serialization
- **get_it** (^8.0.2) - Dependency injection
- **go_router** (^14.6.2) - Declarative routing
- **equatable** (^2.0.7) - Value equality

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS simulator / Android emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd laza
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code for JSON serialization:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## API Configuration

The app connects to the following base URL:
```dart
https://accessories-eshop.runasp.net/api/
```

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Create new user account |
| POST | `/auth/login` | Sign in existing user |
| POST | `/auth/forgot-password` | Send OTP to email |
| POST | `/auth/validate-otp` | Verify OTP code |
| POST | `/auth/reset-password` | Set new password |

### Request/Response Models

#### Register
**Request:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresAtUtc": "string"
}
```

#### Login
**Request:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresAtUtc": "string"
}
```

#### Forgot Password
**Request:**
```json
{
  "email": "string"
}
```

#### Verify OTP
**Request:**
```json
{
  "email": "string",
  "otp": "string"
}
```

#### Reset Password
**Request:**
```json
{
  "email": "string",
  "otp": "string",
  "newPassword": "string"
}
```

## Authentication Flow

### Login Flow
1. User enters email and password
2. `LoginCubit` validates and calls `LoginUseCase`
3. `LoginUseCase` calls `AuthRepository.login()`
4. `AuthRepositoryImpl` uses `AuthApiService` to make API call
5. On success, navigate to home screen
6. On error, display error message

### Registration Flow
1. User enters username, email, and password
2. `RegisterCubit` validates and calls `RegisterUseCase`
3. API returns authentication tokens
4. Navigate to home screen

### Forgot Password Flow
1. **Email Entry** - User enters email address
   - `ForgotPasswordCubit.sendOtp()` sends OTP to email
   - Navigate to verification screen

2. **OTP Verification** - User enters 6-digit code
   - `ForgotPasswordCubit.verifyOtp()` validates code
   - Navigate to new password screen

3. **Password Reset** - User creates new password
   - `ForgotPasswordCubit.resetPassword()` updates password
   - Navigate to login screen

## State Management

### BLoC Pattern Implementation

Each feature uses Cubit for state management:

```dart
// Define states
sealed class LoginState extends Equatable {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final LoginResponseEntity response;
}
class LoginError extends LoginState {
  final String message;
}

// Implement Cubit
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final request = LoginRequestEntity(email: email, password: password);
      final result = await loginUseCase(request);
      emit(LoginSuccess(result));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
```

### Using in UI

```dart
BlocProvider(
  create: (context) => sl<LoginCubit>(),
  child: BlocListener<LoginCubit, LoginState>(
    listener: (context, state) {
      if (state is LoginSuccess) {
        context.go(AppRoutes.home);
      } else if (state is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    },
    child: BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return /* UI Widget */;
      },
    ),
  ),
)
```

## Dependency Injection

Using `get_it` for dependency injection:

```dart
// Register dependencies
void _setupAuth() {
  // API service
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(sl()));

  // Cubits (Factory for multiple instances)
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl(), sl(), sl()));
}
```

## Navigation

Using `go_router` for declarative routing:

```dart
final router = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verificationCode,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return VerificationCodeScreen(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        final otp = state.uri.queryParameters['otp'];
        return NewPasswordScreen(email: email, otp: otp);
      },
    ),
  ],
);
```

### Navigation Examples

```dart
// Push new screen
context.push(AppRoutes.signup);

// Replace current screen
context.go(AppRoutes.home);

// With query parameters
context.push('${AppRoutes.verificationCode}?email=$email');
```

## Code Generation

This project uses code generation for:

1. **JSON Serialization** (`json_serializable`)
2. **Retrofit API Service** (`retrofit_generator`)

### Running Code Generation

```bash
# Watch for changes and auto-generate
dart run build_runner watch

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

### Generated Files
- `*.g.dart` - JSON serialization code
- `*_api_service.g.dart` - Retrofit implementation

## Project Patterns

### Entity-Model Pattern

**Domain Entity** (Pure Dart):
```dart
class LoginRequestEntity extends Equatable {
  final String email;
  final String password;

  const LoginRequestEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
```

**Data Model** (Extends Entity + JSON):
```dart
@JsonSerializable()
class LoginRequestModel extends LoginRequestEntity {
  const LoginRequestModel({
    required super.email,
    required super.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      email: entity.email,
      password: entity.password,
    );
  }
}
```

### Use Case Pattern

```dart
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseEntity> call(LoginRequestEntity request) async {
    return await repository.login(request);
  }
}
```

## Common Issues & Troubleshooting

### Issue: "Email not found" error

**Cause**: API endpoint path duplication (base URL already includes `/api/`)

**Solution**: Ensure endpoints don't duplicate the prefix:
```dart
// ❌ Wrong
@POST("api/auth/login")

// ✓ Correct
@POST("auth/login")
```

### Issue: Build runner fails

**Solution**: Clean and regenerate:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Dependency injection error

**Solution**: Ensure dependencies are registered in correct order in `di.dart`:
1. Core dependencies (Dio)
2. API services
3. Repositories
4. Use cases
5. Cubits

## Additional Documentation

- [Login Architecture](lib/features/auth/LOGIN_ARCHITECTURE.md) - Detailed login implementation
- [Forgot Password Architecture](lib/features/auth/FORGOT_PASSWORD_ARCHITECTURE.md) - Password recovery flow
- [Troubleshooting Guide](TROUBLESHOOTING_FORGOT_PASSWORD.md) - Common issues and solutions

## Development Guidelines

### Adding a New Feature

1. **Create Domain Layer**
   - Define entities in `domain/entities/`
   - Create repository interface in `domain/repositories/`
   - Implement use case in `domain/use_cases/`

2. **Create Data Layer**
   - Create models extending entities in `data/models/`
   - Add API methods in `data/data_sources/`
   - Implement repository in `data/repositories/`
   - Run code generation

3. **Create Presentation Layer**
   - Define states in `presentation/cubit/`
   - Implement cubit in `presentation/cubit/`
   - Create UI screens in `presentation/screens/`

4. **Register Dependencies**
   - Add to `core/di.dart`

5. **Add Routes**
   - Update `core/routing/app_router.dart`

### Code Style

- Use `const` constructors where possible
- Follow Flutter naming conventions
- Keep functions small and focused
- Add comments for complex logic
- Use meaningful variable names

## Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/login_test.dart

# Run with coverage
flutter test --coverage
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ipa --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is part of the Flutter Mentorship program.

## Contact

For questions or issues, please open an issue in the repository.

---

Built with ❤️ using Flutter and Clean Architecture
