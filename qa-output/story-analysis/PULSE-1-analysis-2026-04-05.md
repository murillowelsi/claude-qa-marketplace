# Story Analysis: PULSE-1 — User Login with Email and Password

**Project:** PulseFlow  
**Ticket:** [PULSE-1](https://murillowelsi.atlassian.net/browse/PULSE-1)  
**Status:** To Do  
**Analyzed:** 2026-04-05  

---

## Overview

This story covers the core authentication flow for the PulseFlow application, allowing registered users to sign in with email and password. It promises a working login form with basic lockout protection and a password recovery entry point. The key testing challenge is that authentication stories carry significant security risk surface — brute force, session management, input validation — and the current AC only scratches the surface of what needs to be verified before this is safe to ship.

---

## Quality Issues Found

### Dimension 1: INVEST Criteria

🟢 **Low — INVEST — Independent**  
No significant dependency issues. A dependency on user registration exists implicitly but is manageable.

🟡 **Medium — INVEST — Estimable**  
The story lacks details on session management, email validation, and the "Forgot password?" flow behaviour, making effort estimation incomplete — particularly for the security-conscious parts.

🟡 **Medium — INVEST — Testable**  
The AC covers the happy path and one negative path, but several testable conditions are underdefined (empty fields, unregistered email, account lock messaging). Testers cannot derive a complete test suite from the story as written.

---

### Dimension 2: Clarity and Understandability

🟡 **Medium — Clarity — Missing scope boundaries**  
There is no explicit statement of what is **out of scope** (e.g., SSO/OAuth, "Remember me", biometric login). Without this, the team may debate scope mid-sprint.  
**Why it matters:** Ambiguous scope leads to unplanned development work and gaps in test coverage.  
**Recommendation:** Add an "Out of scope" section listing excluded features (e.g., "Social login and Remember Me are not part of this story").

🟡 **Medium — Clarity — "Forgot password?" is a UI assertion, not a story**  
`"Forgot password?" link is available` describes the presence of a UI element but provides no behaviour, making it unclear what "available" means for testing.  
**Why it matters:** A tester cannot write a meaningful pass/fail test for a link whose destination and behaviour are unspecified.  
**Recommendation:** Clarify if this story only covers the link's presence, or also its navigation target. If it's just presence, state that explicitly; if behaviour is included, add an AC for it.

---

### Dimension 3: Acceptance Criteria Quality

🔴 **Critical — AC — Missing: empty/invalid input handling**  
There is no AC for submitting the form with empty fields, an invalid email format, or whitespace-only values.  
**Why it matters:** This is a primary entry point for the application — missing validation here means undefined behaviour that developers will implement inconsistently and testers will miss.  
**Recommendation:** Add AC for: empty email, empty password, malformed email format (e.g., `notanemail`). Each should specify the expected error message or UI state.

🟠 **High — AC — Unregistered email scenario not covered**  
AC2 only covers "incorrect password" but not the case where the email address does not exist in the system.  
**Why it matters:** The system must return the same generic error (`"Invalid email or password"`) for security (user enumeration prevention), but this is not stated. Without it, a developer might return `"Email not found"` which leaks account existence.  
**Recommendation:** Add AC: *If the email is not registered, the error message must be identical to the one shown for incorrect password.*

🟠 **High — AC — Account lockout behaviour underdefined**  
`"3 failed attempts → account locked for 5 minutes"` is missing: the message shown during lockout, whether the counter resets after a successful login, and whether lockout is per-account or per-IP.  
**Why it matters:** Without these, the feature cannot be fully tested and the implementation may be inconsistent or bypassable.  
**Recommendation:** Add:
- Lockout message (e.g., "Your account has been temporarily locked. Try again in 5 minutes.")
- Counter resets to 0 on successful login
- Clarify: lockout is per account (not per IP)

🟡 **Medium — AC — No session or redirect behaviour on success**  
AC1 says "redirect to dashboard" but says nothing about session duration, session token handling, or whether the user is redirected to the originally requested URL if login was triggered by a protected route.  
**Why it matters:** Session behaviour is critical for security and UX — and it is untestable without defined expectations.  
**Recommendation:** Add at minimum: session is created on successful login; state expected session duration or reference the session policy.

🟡 **Medium — AC — "Forgot password?" link: no behaviour defined**  
The fourth AC only asserts the link exists; there is no AC for what happens when it is clicked.  
**Why it matters:** A tester can only verify the link renders — not that it works.  
**Recommendation:** Either scope this to "link is visible and navigates to the password reset page" or move password reset into a separate story and state this explicitly.

🟡 **Medium — AC — No non-functional requirements**  
No AC for password field masking, HTTPS enforcement, CSRF protection, page load performance, or accessibility (keyboard navigation, screen reader support).  
**Why it matters:** Login is a high-security, high-visibility component. NFR gaps here create security and compliance risk.  
**Recommendation:** Add at minimum: password input is masked by default; form is submitted over HTTPS; login page is keyboard-navigable.

---

### Dimension 4: Testability and Completeness

🟠 **High — Testability — Pre-conditions and test data not defined**  
The story does not state what a "registered user" means in test context — no mention of test accounts, data setup, or environment.  
**Why it matters:** Testers cannot execute AC without knowing how to obtain valid credentials or set up a locked account.  
**Recommendation:** Add pre-conditions: "A registered user account with known credentials exists in the test environment."

🟡 **Medium — Testability — Email case sensitivity not addressed**  
It is unclear whether `User@example.com` and `user@example.com` are treated as the same account.  
**Why it matters:** Inconsistent handling causes subtle bugs and diverging test results across environments.  
**Recommendation:** Add: email comparison is case-insensitive.

---

### Dimension 5: Other Quality Aspects

🟡 **Medium — Dependencies & Risks — No reference to security standards**  
Login is one of the highest-risk surfaces in any application. There is no reference to OWASP or internal security standards.  
**Why it matters:** Without a security baseline, the implementation may pass functional tests but fail a security review.  
**Recommendation:** Add a note referencing the security standard in use (e.g., "Must comply with OWASP Authentication Cheat Sheet").

---

## Improved Acceptance Criteria

```
[REVISED] AC1 — Successful login
Given a registered user with a valid email and correct password,
When the user submits the login form,
Then they are authenticated, a session is created, and they are redirected to the dashboard.

[REVISED] AC2 — Invalid credentials
Given a registered user enters an incorrect password,
Or any user enters an email address that is not registered,
When the form is submitted,
Then the error message "Invalid email or password" is displayed (identical in both cases to prevent user enumeration).

[REVISED] AC3 — Account lockout
Given a user has submitted invalid credentials 3 consecutive times on the same account,
When they attempt to log in again within the 5-minute lockout window,
Then the form displays: "Your account has been temporarily locked. Try again in 5 minutes."
And the failed attempt counter resets to 0 after a successful login.

[REVISED] AC4 — Forgot password link
Given the user is on the login page,
When they click "Forgot password?",
Then they are navigated to the password reset page.
(Note: password reset flow is out of scope for this story.)

[NEW] AC5 — Empty field validation
Given the user submits the login form with an empty email or empty password field,
Then a field-level validation message is displayed ("This field is required") and the form is not submitted.

[NEW] AC6 — Invalid email format
Given the user enters a value that is not a valid email format (e.g., "notanemail"),
When the form is submitted,
Then an inline validation message is shown: "Please enter a valid email address."

[NEW] AC7 — Email case insensitivity
Given a registered user whose email is "User@example.com",
When they log in using "user@example.com" with the correct password,
Then login succeeds.

[NEW] AC8 — Password field masking
Given the login form is visible,
Then the password input displays characters as masked (dots/asterisks) by default.

[NEW] AC9 — Keyboard accessibility
Given a user navigates the login form using only the keyboard (Tab, Enter),
Then they can fill in both fields and submit the form without requiring a mouse.
```

---

## Readiness Verdict

⚠️ **Needs refinement** — the story has a workable foundation but the team must answer these open questions first:

1. Is the lockout per-account or per-IP (or both)?
2. What is the expected session duration after login?
3. Does the "Forgot password?" flow belong in this story or a separate one?
4. Are there any security compliance requirements (OWASP, internal policy) to reference?
5. What is the expected behaviour if a user navigates to a protected route while logged out — are they redirected back after login?
