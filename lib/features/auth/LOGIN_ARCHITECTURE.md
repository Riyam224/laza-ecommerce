# Login Feature - Clean Architecture

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  LoginScreen  →  LoginCubit  →  LoginState                   │
│                      ↓                                        │
└──────────────────────┼──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                     DOMAIN LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  LoginUseCase  →  AuthRepository (interface)                 │
│  LoginRequestEntity                                          │
│  LoginResponseEntity                                         │
└──────────────────────┼──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                      DATA LAYER                              │
├─────────────────────────────────────────────────────────────┤
│  AuthRepositoryImpl  →  AuthApiService                       │
│  LoginRequestModel (extends LoginRequestEntity)             │
│  LoginResponseModel (extends LoginResponseEntity)           │
└─────────────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. **Presentation Layer** 📱
- **LoginScreen**: UI for user login
- **LoginCubit**: Business logic and state management
- **LoginState**: State definitions (Initial, Loading, Success, Error)

### 2. **Domain Layer** 🎯
- **LoginUseCase**: Orchestrates login flow
- **AuthRepository**: Interface contract
- **LoginRequestEntity**: Domain entity for login request
- **LoginResponseEntity**: Domain entity for login response
- **Independent of frameworks** ✅

### 3. **Data Layer** 💾
- **AuthRepositoryImpl**: Repository implementation
- **AuthApiService**: Retrofit API service
- **LoginRequestModel**: Data transfer object (extends entity)
- **LoginResponseModel**: Data transfer object (extends entity)

## Data Flow

### Login Request Flow:
```
User Input (LoginScreen)
    ↓
LoginCubit.loginUser()
    ↓
Creates LoginRequestEntity
    ↓
Calls LoginUseCase
    ↓
AuthRepository.login()
    ↓
AuthRepositoryImpl converts Entity → Model
    ↓
AuthApiService makes API call
    ↓
Response Model → Entity
    ↓
LoginSuccess state emitted
    ↓
UI Updates
```

## Key Benefits ✨

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to mock dependencies and test in isolation
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features following the same pattern
5. **Dependency Rule**: Dependencies point inward (domain is independent)

## Files Structure

```
lib/features/auth/
├── presentation/
│   ├── cubit/
│   │   ├── login_cubit.dart
│   │   └── login_state.dart
│   └── screens/
│       └── login_screen.dart
├── domain/
│   ├── entities/
│   │   ├── login_request_entity.dart
│   │   └── login_response_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── use_cases/
│       └── login_usecase.dart
└── data/
    ├── models/
    │   └── login/
    │       ├── login_request_model.dart
    │       └── login_response_model.dart
    ├── repositories/
    │   └── auth_repository_impl.dart
    └── data_sources/
        └── auth_api_service.dart
```

## Error Handling 🛡️

LoginCubit handles errors at multiple levels:
- **DioException**: Network and API errors
- **Validation**: Email/password validation
- **Server Errors**: Proper status code handling (401, 400, 500+)
- **User Feedback**: Clear error messages

## Dependency Injection 💉

All dependencies registered in `lib/core/di.dart`:
```dart
// Use Case
sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

// Cubit
sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
```

## Usage Example

```dart
// In LoginScreen, wrap with BlocProvider:
BlocProvider(
  create: (context) => sl<LoginCubit>(),
  child: LoginScreen(),
)

// Listen to state changes:
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // Navigate to home
    } else if (state is LoginError) {
      // Show error
    }
  },
  child: YourUI(),
)
```
