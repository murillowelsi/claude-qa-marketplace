# Test Cases: PULSE-1 — User Login with Email and Password

**Project:** PulseFlow  
**Ticket:** [PULSE-1](https://murillowelsi.atlassian.net/browse/PULSE-1)  
**Generated:** 2026-04-05  

---

### AC1 — Successful login

**Login with valid email and correct password redirects to dashboard**
- Pre-conditions: A registered user account exists with known email and password. User is logged out and on the login page.
- Steps:
  1. Enter the registered email address in the email field.
  2. Enter the correct password in the password field.
  3. Click the login/submit button.
- Expected result: The user is authenticated, a session is created, and the browser redirects to the dashboard page.

**Session persists across page navigation after login**
- Pre-conditions: User has successfully logged in and is on the dashboard.
- Steps:
  1. Navigate to another page within the application.
  2. Navigate back to the dashboard.
- Expected result: The user remains authenticated and is not redirected to the login page.

---

### AC2 — Invalid credentials

**Login with correct email and wrong password shows generic error**
- Pre-conditions: A registered user account exists. User is on the login page.
- Steps:
  1. Enter the registered email address.
  2. Enter an incorrect password.
  3. Click the login/submit button.
- Expected result: Login is rejected. The error message "Invalid email or password" is displayed. The user remains on the login page.

**Login with unregistered email shows the same generic error**
- Pre-conditions: User is on the login page. The email used does not belong to any account.
- Steps:
  1. Enter an email address that is not registered in the system (e.g., `ghost@example.com`).
  2. Enter any password.
  3. Click the login/submit button.
- Expected result: Login is rejected. The error message displayed is identical to the wrong-password case: "Invalid email or password". No indication is given that the email does not exist.

**Error message does not reveal whether the email exists (user enumeration check)**
- Pre-conditions: User is on the login page.
- Steps:
  1. Attempt login with a known-registered email and wrong password. Note the error message.
  2. Attempt login with a non-existent email and any password. Note the error message.
- Expected result: Both attempts produce the exact same error message text, formatting, and page behaviour. No difference distinguishes a registered from an unregistered email.

---

### AC3 — Account lockout

**Account is locked after 3 consecutive failed login attempts**
- Pre-conditions: A registered user account exists. User is on the login page. The account has not previously failed any login attempts.
- Steps:
  1. Enter the correct email and an incorrect password. Submit. (Attempt 1)
  2. Enter the correct email and an incorrect password. Submit. (Attempt 2)
  3. Enter the correct email and an incorrect password. Submit. (Attempt 3)
  4. Enter the correct email and the correct password. Submit. (Attempt 4)
- Expected result: After the 3rd failed attempt, the account is locked. On the 4th attempt (even with the correct password), login is refused and the message "Your account has been temporarily locked. Try again in 5 minutes." is displayed.

**Locked account cannot log in during the 5-minute window**
- Pre-conditions: The user's account has just been locked by 3 failed attempts.
- Steps:
  1. Wait less than 5 minutes.
  2. Enter the correct email and correct password.
  3. Click the login/submit button.
- Expected result: Login is refused. The lockout message is still displayed. The user is not authenticated.

**Account unlocks and allows login after 5 minutes**
- Pre-conditions: The user's account was locked exactly 5 minutes ago.
- Steps:
  1. Wait until the 5-minute lockout period has elapsed.
  2. Enter the correct email and correct password.
  3. Click the login/submit button.
- Expected result: Login succeeds. The user is redirected to the dashboard.

**Failed attempt counter resets to zero after a successful login**
- Pre-conditions: A registered user account exists. The account has 2 previous failed login attempts recorded (1 attempt away from lockout).
- Steps:
  1. Log in successfully with the correct email and password.
  2. Log out.
  3. Attempt login with the correct email and an incorrect password once.
- Expected result: The account is not locked after this single failed attempt. The counter was reset by the successful login. The generic error message is shown.

---

### AC4 — Forgot password link

**"Forgot password?" link is visible on the login page**
- Pre-conditions: User is on the login page (not logged in).
- Steps:
  1. Observe the login page.
- Expected result: A "Forgot password?" link is visible on the page.

**Clicking "Forgot password?" navigates to the password reset page**
- Pre-conditions: User is on the login page.
- Steps:
  1. Click the "Forgot password?" link.
- Expected result: The browser navigates to the password reset page. The login page is no longer displayed.

---

### AC5 — Empty field validation

**Submitting the form with an empty email field shows a validation message**
- Pre-conditions: User is on the login page.
- Steps:
  1. Leave the email field empty.
  2. Enter any value in the password field.
  3. Click the login/submit button.
- Expected result: The form is not submitted. A validation message "This field is required" (or equivalent) is shown on the email field.

**Submitting the form with an empty password field shows a validation message**
- Pre-conditions: User is on the login page.
- Steps:
  1. Enter a valid email address.
  2. Leave the password field empty.
  3. Click the login/submit button.
- Expected result: The form is not submitted. A validation message "This field is required" (or equivalent) is shown on the password field.

**Submitting the form with both fields empty shows validation messages**
- Pre-conditions: User is on the login page.
- Steps:
  1. Leave both the email and password fields empty.
  2. Click the login/submit button.
- Expected result: The form is not submitted. Validation messages are shown on both fields.

---

### AC6 — Invalid email format

**Submitting a malformed email address shows an inline validation error**
- Pre-conditions: User is on the login page.
- Steps:
  1. Enter a value that is not a valid email format (e.g., `notanemail`) in the email field.
  2. Enter any value in the password field.
  3. Click the login/submit button.
- Expected result: The form is not submitted. The message "Please enter a valid email address." is displayed on the email field.

**Submitting an email missing the domain shows a validation error**
- Pre-conditions: User is on the login page.
- Steps:
  1. Enter `user@` in the email field.
  2. Enter any value in the password field.
  3. Click the login/submit button.
- Expected result: The form is not submitted. An inline validation error is shown on the email field.

---

### AC7 — Email case insensitivity

**Login succeeds when the email is entered in a different case than it was registered**
- Pre-conditions: A registered user account exists with email `User@Example.com`.
- Steps:
  1. Enter `user@example.com` (all lowercase) in the email field.
  2. Enter the correct password.
  3. Click the login/submit button.
- Expected result: Login succeeds. The user is redirected to the dashboard.

**Login succeeds when the email is entered in all uppercase**
- Pre-conditions: A registered user account exists with email `user@example.com`.
- Steps:
  1. Enter `USER@EXAMPLE.COM` in the email field.
  2. Enter the correct password.
  3. Click the login/submit button.
- Expected result: Login succeeds. The user is redirected to the dashboard.

---

### AC8 — Password field masking

**Password characters are masked by default**
- Pre-conditions: User is on the login page.
- Steps:
  1. Click into the password field.
  2. Type any characters.
- Expected result: The typed characters are displayed as masked symbols (dots or asterisks). The actual characters are not visible in the input field.

---

### AC9 — Keyboard accessibility

**Login form can be completed and submitted using only the keyboard**
- Pre-conditions: User is on the login page. No mouse interaction is used.
- Steps:
  1. Press Tab to focus the email field. Type a valid email.
  2. Press Tab to move focus to the password field. Type the correct password.
  3. Press Tab to move focus to the login button.
  4. Press Enter to submit.
- Expected result: The form is submitted successfully. The user is redirected to the dashboard. No mouse interaction was required at any step.

**Tab order follows a logical sequence on the login form**
- Pre-conditions: User is on the login page.
- Steps:
  1. Press Tab repeatedly from the top of the page.
  2. Note the focus order of interactive elements.
- Expected result: Focus moves in logical order: email field → password field → login button → "Forgot password?" link (or equivalent logical sequence).

---

> **22 test cases generated — 11 positive, 6 negative, 4 edge cases, 1 non-functional.**
