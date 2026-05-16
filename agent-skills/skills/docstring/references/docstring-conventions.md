# Docstring Conventions by Language

Match the convention for the detected language. If the file already has doc comments, match their style exactly over these defaults.

---

## Go (godoc)

Comment immediately precedes the declaration with no blank line. Starts with the name of the symbol. Full sentences with periods.

```go
// ParseConfig reads a YAML configuration file from path and returns the
// parsed Config. Returns ErrNotFound if the file does not exist, or a
// wrapped error if the file cannot be parsed.
//
// ParseConfig does not validate semantic correctness of the config — use
// Config.Validate for that.
func ParseConfig(path string) (*Config, error) {
```

**Package docs** go in `doc.go` or at the top of the main file:
```go
// Package ratelimit provides token-bucket rate limiting for HTTP handlers.
// It is safe for concurrent use.
package ratelimit
```

**Rules:**
- Begin with the symbol name: `// ParseConfig reads...` not `// This function reads...`
- Exported types, functions, methods, and constants must be documented
- Unexported symbols: document only when the logic is non-obvious
- Use `//` not `/* */` for doc comments
- Note thread safety: "safe for concurrent use" or "not safe for concurrent use"
- Document error return values for public functions

---

## Python (docstrings)

Use triple double-quotes. Follow the project's existing style — Google, NumPy, or Sphinx. Default to Google style.

**Google style:**
```python
def parse_config(path: str) -> Config:
    """Parse a YAML configuration file and return the parsed Config.

    Does not validate semantic correctness — use Config.validate() for that.

    Args:
        path: Absolute or relative path to the YAML config file.

    Returns:
        Parsed Config instance.

    Raises:
        FileNotFoundError: If the file does not exist.
        ConfigParseError: If the file cannot be parsed as valid config YAML.
    """
```

**NumPy style** (common in scientific code):
```python
def parse_config(path):
    """
    Parse a YAML configuration file and return the parsed Config.

    Parameters
    ----------
    path : str
        Absolute or relative path to the YAML config file.

    Returns
    -------
    Config
        Parsed Config instance.

    Raises
    ------
    FileNotFoundError
        If the file does not exist.
    """
```

**Rules:**
- One-line docstring for obvious functions: `"""Return the user's display name."""`
- Multi-line: summary line, blank line, then details
- Document all public functions, classes, and methods
- Include types in Args/Parameters if not in type hints
- Private methods (`_name`): document only when non-obvious

---

## TypeScript / JavaScript (JSDoc)

```typescript
/**
 * Parses a YAML configuration file and returns the parsed config.
 *
 * Does not validate semantic correctness — use `Config.validate()` for that.
 *
 * @param path - Absolute or relative path to the YAML config file.
 * @returns Parsed config object.
 * @throws {NotFoundError} If the file does not exist.
 * @throws {ParseError} If the file cannot be parsed.
 *
 * @example
 * const config = await parseConfig('./config.yaml');
 */
async function parseConfig(path: string): Promise<Config> {
```

**Rules:**
- Use `/** */` not `//` for JSDoc
- `@param name - description` (dash, not colon, in modern JSDoc)
- `@returns` describes what is returned; skip for `void`
- `@throws` for each exception type
- `@example` for non-obvious usage — especially useful for public APIs
- For TypeScript: type annotations in code are preferred over `{type}` in JSDoc; omit `{Type}` if already typed
- Interface properties and class fields: one-line `/** description */` above the property

---

## Rust (rustdoc)

```rust
/// Parses a YAML configuration file and returns the parsed [`Config`].
///
/// # Errors
///
/// Returns [`Error::NotFound`] if the file does not exist.
/// Returns [`Error::Parse`] if the file cannot be parsed.
///
/// # Panics
///
/// Panics if `path` contains null bytes.
///
/// # Examples
///
/// ```
/// let config = parse_config("config.yaml")?;
/// ```
pub fn parse_config(path: &str) -> Result<Config, Error> {
```

**Rules:**
- Use `///` for item docs, `//!` for module/crate docs
- Cross-reference types with `[`TypeName`]`
- Required sections: `# Errors` for `Result`-returning functions, `# Panics` if the function can panic
- Optional sections: `# Safety` for `unsafe` functions (required), `# Examples`, `# Notes`
- Examples in `# Examples` must be valid Rust that compiles (tested by `cargo test --doc`)

---

## When not to write a docstring

A docstring that restates the code adds noise without value:

```go
// Bad — restates the obvious
// GetUserByID returns the user with the given ID.
func GetUserByID(id string) (*User, error) {

// Good — adds context the name doesn't provide
// GetUserByID looks up the user in the read replica. For writes that
// require consistency, use GetUserByIDPrimary.
func GetUserByID(id string) (*User, error) {
```

Skip the docstring entirely rather than writing one that says nothing. Document when:
- The behavior is not obvious from the name and signature
- There are important caveats (thread safety, ownership, side effects, performance)
- Error conditions need explanation beyond the error type name
- The function is part of a public API
