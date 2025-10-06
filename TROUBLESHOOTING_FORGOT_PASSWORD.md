# Troubleshooting: "Email Not Found" Error

## 🔍 Debugging Steps

### 1. Check Debug Logs

When you run the app and try to verify OTP, check the console/logs for:

```
🔍 DEBUG - Email: your@email.com, OTP: 123456
🔍 DEBUG - Verify OTP Request: {email: your@email.com, code: 123456}
```

This will tell you:
- ✅ What email is being sent
- ✅ What OTP code is being sent
- ✅ The exact JSON being sent to the API

### 2. Common Issues & Solutions

#### Issue 1: Email Not Passed Correctly
**Symptom:** Debug shows `Email: null` or `Email: `

**Solution:**
- Make sure you click "Confirm Mail" on ForgotPasswordScreen
- Check that you see "OTP sent to your email!" message
- The email should be in the URL when navigating to VerificationCodeScreen

#### Issue 2: Wrong API Endpoint
**Current endpoints:**
```dart
POST /auth/forgot-password   // Send OTP
POST /auth/verify-code        // Verify OTP ✅ Changed from verify-otp
POST /auth/reset-password     // Reset password
```

**If your API uses different endpoints, update:**
`lib/features/auth/data/data_sources/auth_api_service.dart`

#### Issue 3: Wrong Field Names
**Current JSON format for verify OTP:**
```json
{
  "email": "user@example.com",
  "code": "123456"
}
```

**If your API expects different field names:**

Update `verify_otp_request_model.dart`:
```dart
@JsonKey(name: 'otp')  // Change 'code' to whatever your API expects
@override
final String otp;
```

Then run: `dart run build_runner build --delete-conflicting-outputs`

#### Issue 4: Wrong OTP Code
**Make sure:**
- ✅ You're entering the ACTUAL code from your email
- ✅ Code hasn't expired (usually 5-10 minutes)
- ✅ You're entering all 6 digits
- ✅ No spaces or extra characters

### 3. API Response Debugging

To see the actual API error, check the Dio error in logs. The error might show:
- `404 Not Found` → Email doesn't exist in database
- `400 Bad Request` → Wrong format or expired OTP
- `401 Unauthorized` → Wrong OTP code

### 4. Test Flow

1. **ForgotPasswordScreen:**
   - Enter email that exists in your system
   - Click "Confirm Mail"
   - Should see: "OTP sent to your email!"
   - Check console: Email should be printed

2. **Check Email:**
   - Open your email inbox
   - Find the OTP code (6 digits)
   - Note: Code might be in spam folder

3. **VerificationCodeScreen:**
   - Check console for: `🔍 DEBUG - Email: ...`
   - Enter the 6-digit code from email
   - Click "Confirm Code"
   - Check console for: `🔍 DEBUG - Verify OTP Request: {...}`

4. **Check API Response:**
   - If error, check the exact error message
   - Verify the endpoint URL is correct
   - Verify the email exists in the database

### 5. Common API Variations

Your API might use:

**Option A: Combined endpoint (some APIs)**
```dart
@POST("auth/verify-otp")  // or verify-code
```

**Option B: Email in path parameter**
```dart
@POST("auth/{email}/verify-otp")
```

**Option C: Different field names**
```json
{
  "email": "...",
  "token": "..."  // instead of "code"
}
```

### 6. Quick Fixes to Try

1. **Try `verify-otp` instead of `verify-code`:**
   ```dart
   @POST("auth/verify-otp")
   Future<void> verifyOtp(@Body() Map<String, dynamic> body);
   ```

2. **Try different field name (token instead of code):**
   ```dart
   @JsonKey(name: 'token')
   @override
   final String otp;
   ```

3. **Check if email needs to be in path:**
   ```dart
   @POST("auth/verify-code/{email}")
   Future<void> verifyOtp(@Path("email") String email, @Body() Map<String, dynamic> body);
   ```

### 7. Remove Debug Prints (After Fixing)

Once you identify the issue, remove the debug prints:

**File:** `auth_repository_impl.dart:46`
```dart
// Remove this line:
print('🔍 DEBUG - Verify OTP Request: $json');
```

**File:** `verification_code_screen.dart:85`
```dart
// Remove this line:
print('🔍 DEBUG - Email: ${widget.email}, OTP: $otp');
```

## 🎯 Next Steps

1. Run the app and check the debug logs
2. Verify the exact error message from the API
3. Check your email for the actual OTP code
4. Contact your backend team to confirm:
   - Exact endpoint URLs
   - Expected JSON field names
   - OTP code format (6 digits, expiry time, etc.)

## 📞 Need More Help?

Share the debug output and API error response for more specific help!
