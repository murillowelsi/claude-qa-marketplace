# Manual Test Plan — Swag Labs (Login Page)

**URL:** https://www.saucedemo.com  
**Explored:** 2026-04-05  
**Scope:** Login page only

---

## Application Overview
Swag Labs (`saucedemo.com`) is a demo e-commerce application built by Sauce Labs for testing purposes. The login page accepts email/password credentials and gates access to a product inventory. The page displays six accepted usernames and a shared password directly on the page, each simulating a different user state: standard access, locked account, broken UI (problem), performance degradation, error state, and visual defects. The login form consists of a username field, a password field, a Login button, and an inline error message banner with a dismiss control.

## Scope
This test plan covers the login page exclusively: form validation, credential scenarios for all six user types, error message behaviour, error dismissal, and session/authorization boundary. Post-login inventory and checkout flows are out of scope.

---

## Feature Area: Form Validation

### Submitting an empty form shows a username-required error

**Pre-conditions:** Browser is on `https://www.saucedemo.com`. Both fields are empty.

**Steps:**
1. Leave both the Username and Password fields empty.
2. Click the **Login** button.

**Expected result:** The form is not submitted. An error banner appears with the message: *"Epic sadface: Username is required"*. The URL remains `https://www.saucedemo.com/`.

---

### Submitting with only a username and no password shows a password-required error

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `standard_user` in the Username field.
2. Leave the Password field empty.
3. Click the **Login** button.

**Expected result:** An error banner appears with the message: *"Epic sadface: Password is required"*. The user is not logged in.

---

### Dismissing the error banner removes it from the page

**Pre-conditions:** An error banner is visible after a failed login attempt.

**Steps:**
1. Trigger any login error (e.g., submit with empty fields).
2. Click the **×** (close) button inside the error banner.

**Expected result:** The error banner disappears. The username and password fields remain populated as they were. No other page state changes.

---

### Error banner shows a red icon on both fields when validation fails

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Submit the form with invalid or missing credentials.
2. Observe the username and password fields.

**Expected result:** Both input fields display a red error icon alongside the error banner.

---

## Feature Area: Authentication — Valid Credentials

### Standard user logs in successfully and lands on the inventory page

**Pre-conditions:** Browser is on `https://www.saucedemo.com`. No active session.

**Steps:**
1. Enter `standard_user` in the Username field.
2. Enter `secret_sauce` in the Password field.
3. Click the **Login** button.

**Expected result:** The browser redirects to `https://www.saucedemo.com/inventory.html`. The Products page loads with 6 items, a sort dropdown, and the navigation header. No error is shown.

---

### Performance glitch user logs in successfully despite a significant delay

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `performance_glitch_user` in the Username field.
2. Enter `secret_sauce` in the Password field.
3. Click the **Login** button.
4. Wait for the page to load.

**Expected result:** Login eventually succeeds and the user lands on the inventory page. The login takes noticeably longer than for `standard_user` (several seconds). No error message is shown.

---

### Problem user logs in and accesses the inventory page

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `problem_user` in the Username field.
2. Enter `secret_sauce` in the Password field.
3. Click the **Login** button.

**Expected result:** Login succeeds and the browser navigates to the inventory page. (Note: this user is known to exhibit UI defects on subsequent pages — verify the login step itself completes without error.)

---

## Feature Area: Authentication — Invalid Credentials

### Login with a correct username and wrong password shows a credential mismatch error

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `standard_user` in the Username field.
2. Enter any incorrect password (e.g., `wrong_password`) in the Password field.
3. Click the **Login** button.

**Expected result:** An error banner appears with the message: *"Epic sadface: Username and password do not match any user in this service"*. The user remains on the login page.

---

### Login with a non-existent username shows a credential mismatch error

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter a username that does not exist (e.g., `ghost_user`) in the Username field.
2. Enter any value in the Password field.
3. Click the **Login** button.

**Expected result:** The error message is identical to the wrong-password case: *"Epic sadface: Username and password do not match any user in this service"*. The error does not reveal whether the username exists.

---

### Login fields retain their values after a failed attempt

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `standard_user` in the Username field.
2. Enter `wrong_password` in the Password field.
3. Click **Login**.

**Expected result:** After the failed attempt, both fields still contain the values entered. The user does not need to re-type their username.

---

## Feature Area: Locked Account

### Locked user cannot log in and sees a specific lockout message

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `locked_out_user` in the Username field.
2. Enter `secret_sauce` in the Password field.
3. Click the **Login** button.

**Expected result:** An error banner appears with the message: *"Epic sadface: Sorry, this user has been locked out."* The browser remains on the login page. The user is not authenticated.

---

### Locked user with wrong password still shows the lockout message (not a credential error)

**Pre-conditions:** Browser is on `https://www.saucedemo.com`.

**Steps:**
1. Enter `locked_out_user` in the Username field.
2. Enter an incorrect password (e.g., `wrong_password`) in the Password field.
3. Click the **Login** button.

**Expected result:** The error message shown is the lockout message (*"Sorry, this user has been locked out."*), not the generic credential mismatch message. This confirms lockout is evaluated before password verification.

---

## Feature Area: Session & Authorization

### Authenticated user session persists across page navigation

**Pre-conditions:** User has just logged in as `standard_user` and is on the inventory page.

**Steps:**
1. Navigate to `https://www.saucedemo.com/` (root URL) in the address bar.
2. Observe what page loads.

**Expected result:** The app recognises the active session. The user is either redirected back to the inventory page or the login form is presented but re-submitting is not required to regain access.

---

### Unauthenticated direct access to a protected URL is blocked

**Pre-conditions:** No active session. Cookies have been cleared. Browser is not on the Swag Labs site.

**Steps:**
1. In a fresh browser session (or after clearing cookies), navigate directly to `https://www.saucedemo.com/inventory.html`.

**Expected result:** The app redirects to the login page (`https://www.saucedemo.com/`). The inventory content is not accessible without authentication.

---

### Logged-out user cannot access the inventory page via browser back navigation

**Pre-conditions:** User has logged in as `standard_user`, reached the inventory page, and then logged out.

**Steps:**
1. Log in as `standard_user`.
2. Log out using the burger menu → Logout.
3. Press the browser's Back button.

**Expected result:** The browser either stays on the login page or navigates back but shows a blank/redirected state. The inventory page content is not displayed for the unauthenticated user.

---

## Defects Found During Exploration

> **Potential defect — Authorization bypass via direct URL**
> During exploration, navigating to `/inventory.html` after visiting the root login page (which was displaying the login form) still loaded the full inventory page without requiring re-authentication. This suggests the session cookie from a previous login persisted, and the root URL (`/`) does not invalidate or check the session. In a real application, this would represent a failure to enforce authentication on protected routes.
>
> **Recommendation:** Use `/report-bug` to log this with reproduction steps and confirm whether session clearing at root is expected behaviour.

> **Observation — Credentials displayed in plain text on login page**
> The accepted usernames and shared password are rendered directly on the login page. This is intentional for a demo app but should not be replicated in any production environment.
