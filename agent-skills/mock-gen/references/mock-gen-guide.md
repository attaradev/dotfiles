# Mock Generation Guide

## Test double taxonomy

| Double type | Definition | When to use |
|-------------|-----------|-------------|
| **Stub** | Returns hard-coded values; no assertion | When you need to control inputs, not verify calls |
| **Mock** | Records calls; asserts expectations at end | When verifying the interaction itself is the goal |
| **Fake** | Has working implementation (e.g. in-memory DB) | When stub complexity grows too large to maintain |
| **Spy** | Wraps a real object and records calls | When you need real behaviour + call verification |

Default to **stub** for state-based tests. Use **mock** only when verifying a specific call is the test's core purpose.

---

## Go

### With `testify/mock`

```go
// Interface to mock
type EmailSender interface {
    Send(to, subject, body string) error
}

// Generated mock
type MockEmailSender struct {
    mock.Mock
}

func (m *MockEmailSender) Send(to, subject, body string) error {
    args := m.Called(to, subject, body)
    return args.Error(0)
}

// Usage in test
func TestWelcomeEmail(t *testing.T) {
    sender := new(MockEmailSender)
    sender.On("Send", "user@example.com", "Welcome", mock.AnythingOfType("string")).Return(nil)

    svc := NewUserService(sender)
    err := svc.Register("user@example.com")

    require.NoError(t, err)
    sender.AssertExpectations(t)
}

// Error case
func TestWelcomeEmail_SendFails(t *testing.T) {
    sender := new(MockEmailSender)
    sender.On("Send", mock.Anything, mock.Anything, mock.Anything).Return(errors.New("smtp timeout"))

    svc := NewUserService(sender)
    err := svc.Register("user@example.com")

    require.ErrorContains(t, err, "smtp timeout")
}
```

### With `gomock`

```go
//go:generate mockgen -source=emailsender.go -destination=mock_emailsender.go -package=mocks

// Usage
ctrl := gomock.NewController(t)
defer ctrl.Finish()

sender := mocks.NewMockEmailSender(ctrl)
sender.EXPECT().Send("user@example.com", "Welcome", gomock.Any()).Return(nil)
```

### Simple stub (no library)

```go
type stubEmailSender struct {
    sentTo []string
    err    error
}

func (s *stubEmailSender) Send(to, subject, body string) error {
    s.sentTo = append(s.sentTo, to)
    return s.err
}
```

Use the stub pattern when you only need to capture state, not assert call order/count.

---

## TypeScript / JavaScript

### With Jest

```typescript
// Interface
interface PaymentGateway {
  charge(amount: number, token: string): Promise<{ id: string }>
  refund(chargeId: string): Promise<void>
}

// Auto-mock with jest.fn()
const gateway: jest.Mocked<PaymentGateway> = {
  charge: jest.fn().mockResolvedValue({ id: 'ch_123' }),
  refund: jest.fn().mockResolvedValue(undefined),
}

// Test
it('creates a charge and stores the ID', async () => {
  const svc = new OrderService(gateway)
  const order = await svc.pay({ amount: 100, token: 'tok_test' })

  expect(gateway.charge).toHaveBeenCalledWith(100, 'tok_test')
  expect(order.chargeId).toBe('ch_123')
})

// Error case
it('marks order as failed when charge throws', async () => {
  gateway.charge.mockRejectedValueOnce(new Error('card declined'))

  const svc = new OrderService(gateway)
  const order = await svc.pay({ amount: 100, token: 'tok_bad' })

  expect(order.status).toBe('failed')
})
```

### With Vitest

Same API as Jest (`vi.fn()` instead of `jest.fn()`):

```typescript
import { vi } from 'vitest'
const charge = vi.fn().mockResolvedValue({ id: 'ch_123' })
```

---

## Python

### With `unittest.mock`

```python
from unittest.mock import MagicMock, patch, AsyncMock

# Stub via MagicMock
def test_sends_welcome_email():
    sender = MagicMock()
    sender.send.return_value = None

    svc = UserService(sender)
    svc.register("user@example.com")

    sender.send.assert_called_once_with(
        to="user@example.com",
        subject="Welcome",
        body=ANY,
    )

# Error case
def test_register_handles_send_failure():
    sender = MagicMock()
    sender.send.side_effect = SMTPError("timeout")

    svc = UserService(sender)
    with pytest.raises(RegistrationError):
        svc.register("user@example.com")

# Async mock
async def test_async_sender():
    sender = AsyncMock()
    sender.send.return_value = None
    # ...

# Patch a module-level import
@patch("myapp.services.requests.post")
def test_http_call(mock_post):
    mock_post.return_value.json.return_value = {"status": "ok"}
    # ...
```

---

## Fake (in-memory implementation)

Use a fake when stub logic becomes too complex. A fake is a real implementation that does not hit external systems.

```go
// Fake repository (replaces a real DB)
type FakeUserRepo struct {
    mu    sync.Mutex
    users map[string]*User
}

func NewFakeUserRepo() *FakeUserRepo {
    return &FakeUserRepo{users: make(map[string]*User)}
}

func (r *FakeUserRepo) Save(u *User) error {
    r.mu.Lock()
    defer r.mu.Unlock()
    r.users[u.ID] = u
    return nil
}

func (r *FakeUserRepo) FindByID(id string) (*User, error) {
    r.mu.Lock()
    defer r.mu.Unlock()
    u, ok := r.users[id]
    if !ok {
        return nil, ErrNotFound
    }
    return u, nil
}
```

Fakes should live in a `testhelpers` or `internal/testing` package — not in production code.

---

## Decision guide

```
Does the test need to verify that a specific call was made?
  YES → Mock (with assertion at end)
  NO  → Does the dependency need to return different values per call?
          YES → Stub with side_effect / Return sequence
          NO  → Simple stub with fixed return value
                Is the stub getting complex (branching logic, state)?
                  YES → Fake
                  NO  → Stay with stub
```

---

## Common pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Mock asserts too many calls | Brittle — breaks on refactor | Assert only the call your test is about |
| Stub returns zero value implicitly | Hides unset expectations | Explicitly set return values for all expected calls |
| `mock.Anything` everywhere | Test proves nothing | Use specific matchers for the meaningful arguments |
| Mock in production package | Leaks test code into binary | Keep mocks in `_test.go` files or a `testhelpers` package |
| Using a mock when a fake would do | Tedious setup repeated in every test | Extract a fake when 3+ tests set up the same mock state |
| Mocking what you don't own | Breaks when the 3rd-party API changes | Wrap the 3rd-party client behind your own interface; mock the wrapper |
