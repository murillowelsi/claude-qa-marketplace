---
name: qa-test-generation
description: >
  Generate structured API and E2E test cases from requirements, user stories, or
  existing code. Use this skill whenever the user asks to generate tests, create
  test scenarios, identify edge cases, build test data, or mentions test coverage
  gaps. Also trigger when the user pastes an API endpoint, a Swagger/OpenAPI spec,
  or a Jira ticket and wants test cases derived from it — even if they don't
  explicitly say "generate tests."
---

# QA Test Generation

Generate comprehensive test cases from requirements, code, or API specs.

## When to Use

- User provides a requirement, user story, or Jira ticket and wants test cases.
- User pastes an API endpoint or OpenAPI spec and wants test coverage.
- User asks for edge cases, negative tests, or boundary analysis.
- User has an existing test suite and wants to fill coverage gaps.

## Workflow

### Step 1: Identify the Input Type

Determine what the user provided:
- **User story / requirement text** → Extract acceptance criteria, then derive tests.
- **API endpoint or OpenAPI spec** → Parse parameters, responses, auth, then generate contract + functional tests.
- **Existing code** → Analyze paths, branches, error handling, then generate covering tests.
- **Jira ticket** → Extract description, acceptance criteria, linked specs.

### Step 2: Generate Test Cases

For each input, produce test cases in this structure:

```
Test Case ID: TC-<feature>-<number>
Title: <concise description>
Priority: Critical | High | Medium | Low
Type: Positive | Negative | Boundary | Security | Performance
Preconditions: <setup required>
Steps:
  1. <action>
  2. <action>
Expected Result: <observable outcome>
Test Data: <specific values to use>
```

Apply these heuristics:
- Every happy path gets at least one negative counterpart.
- Every input parameter gets boundary values (min, max, empty, null, type mismatch).
- Auth endpoints get token expiry, invalid token, missing token, wrong role.
- List endpoints get empty list, single item, pagination boundary, sort edge cases.
- String inputs get empty, whitespace-only, max length, special characters, SQL injection patterns.

### Step 3: Organize and Present

Group test cases by:
1. Feature / endpoint
2. Test type (positive → negative → boundary → security)

Present as a structured table or as code (Playwright/TypeScript test stubs) depending on user preference. If unclear, ask.

## Example Prompts

1. "Generate test cases for this user registration endpoint: POST /api/users"
2. "What edge cases should I test for this Jira ticket?" (with ticket content pasted)
3. "Create Playwright tests for the login flow described in this spec"

## Pitfalls

- Don't assume authentication scheme without evidence. Ask or inspect the spec.
- Don't generate performance test cases unless explicitly requested — they require different tooling.
- If the user's stack is unknown, generate framework-agnostic test cases. Don't assume Playwright unless the project context confirms it.
