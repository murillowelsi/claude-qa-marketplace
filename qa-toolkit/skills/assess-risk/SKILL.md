---
name: assess-risk
description: Assess risk and prioritise test cases using ISTQB risk-based testing. Scores each test area by likelihood of failure and impact. Use after generate-test-cases or when the user needs to decide what to test first.
---

# Assess Risk

Apply risk-based testing to prioritise what to test first. Based on ISTQB risk analysis: **Risk = Likelihood × Impact**.

## Input

If not already provided, ask for:
- The list of test cases or feature areas to assess
- Any context about the domain, recent changes, or known fragile areas

---

## Step 1 — Define Risk Areas

Group test cases into risk areas (feature areas or AC groups) if there are many. Risk is assessed at the area level first, then individual test cases are ranked within each area.

Example risk areas:
- Authentication flow
- Payment processing
- Search and filter
- User profile management

---

## Step 2 — Score Likelihood (1–5)

How likely is this area to have a defect?

| Score | Description                                                      |
|-------|------------------------------------------------------------------|
| 5     | New or heavily changed code; complex logic; unclear requirements |
| 4     | Moderate changes; some known complexity; limited test history    |
| 3     | Some changes; reasonably well-understood; some past defects      |
| 2     | Minor changes; stable area; few past defects                     |
| 1     | No changes; very stable; extensively tested historically         |

**Factors that increase likelihood**:
- Ambiguous or missing acceptance criteria
- Complex business rules (decision tables, many branches)
- Integration with external systems
- Concurrency / race conditions
- New team member implemented it
- Short development time / pressure

---

## Step 3 — Score Impact (1–5)

What is the consequence if this fails in production?

| Score | Description                                                                  |
|-------|------------------------------------------------------------------------------|
| 5     | Financial loss, data corruption, legal/regulatory violation, complete outage |
| 4     | Major user-facing failure, loss of core business function                    |
| 3     | Degraded experience, workaround exists, moderate user impact                 |
| 2     | Minor UX issue, cosmetic, low user visibility                                |
| 1     | Internal only, no user impact, easily recoverable                            |

**Factors that increase impact**:
- Payments, personal data, or authentication involved
- High-traffic or critical user journey
- Regulatory requirements (GDPR, PCI-DSS, accessibility laws)
- No fallback or recovery mechanism
- Data loss or corruption possible

---

## Step 4 — Calculate Risk Score and Classify

Risk Score = Likelihood × Impact

| Score | Level       | Action                                     |
|-------|-------------|--------------------------------------------|
| 17–25 | 🔴 Critical | Test first; block release if failing       |
| 10–16 | 🟠 High     | Must test before release                   |
| 5–9   | 🟡 Medium   | Test if time allows; include in regression |
| 1–4   | 🟢 Low      | Exploratory / low-priority regression      |

---

## Step 5 — Output Risk Matrix

```markdown
## Risk Assessment

| Area / Test Case            | Likelihood | Impact | Risk Score | Level       | Recommendation |
|-----------------------------|------------|--------|------------|-------------|----------------|
| TC-001 Payment flow         | 4          | 5      | 20         | 🔴 Critical | Test first     |
| TC-005 Login validation     | 3          | 5      | 15         | 🟠 High     | Must test      |
| TC-012 Profile photo upload | 2          | 2      | 4          | 🟢 Low      | Exploratory    |
```

Sort by Risk Score descending.

---

## Step 6 — Recommended Test Execution Order

Based on the matrix, produce a recommended execution order:

```markdown
## Recommended Execution Order

### Phase 1 — Critical (test before any release)
1. TC-001 Payment flow
2. TC-003 Auth token expiry

### Phase 2 — High (required for release sign-off)
3. TC-005 Login validation
4. TC-008 Search filter with special characters

### Phase 3 — Medium (if time allows)
5. TC-011 Profile update
6. TC-014 Pagination edge cases

### Phase 4 — Low (regression / exploratory)
7. TC-012 Profile photo upload
```

---

## After Assessment

Ask the user:
1. Does this prioritisation match your understanding of the system risk?
2. Do you want to **export the full QA review** (story analysis + test cases + risk matrix)? → `/qa-review`
