## Design Declaration (required before writing any UI code)

Before writing a single line of HTML, CSS, or component code, declare your design direction across these 4 axes:

1. **Purpose** — what is this interface for and who uses it?
2. **Tone** — where on the spectrum does this sit? (clinical / minimal / editorial / playful / brutalist / maximalist)
3. **Constraints** — what must not break? (accessibility level, dark mode, performance budget, framework limits)
4. **Differentiation** — what one thing will make this unmistakably not a template?

State this as: *"This is a [purpose] interface with [tone] tone. Constraint: [constraint]. It will stand out by [differentiation]."*

Do NOT proceed to code until the declaration is written.

---

## 5 Design Dimensions

Apply all five dimensions deliberately. Absence of a choice is still a choice — make it intentional.

### 1. Typography

- Pair at least two typefaces with clear roles (display, body, mono — never all three the same)
- **Forbidden:** Inter as the sole typeface. Use Inter only when it serves a specific functional purpose (UI chrome), paired with something expressive for headings or accents.
- Define a type scale with at least 4 steps; apply it consistently via CSS variables or design tokens

```css
--font-display: 'Playfair Display', Georgia, serif;
--font-body: 'Source Serif 4', Georgia, serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### 2. Color

- Define a named palette as CSS custom properties at the `:root` — never use raw hex values inline
- The palette must have a clear role hierarchy: background, surface, border, accent, text-primary, text-secondary, text-inverse
- **Forbidden:** violet/purple as the reflexive default accent. Earn the color choice from the tone declaration.

```css
:root {
  --color-bg: #0a0a0a;
  --color-surface: #141414;
  --color-border: #2a2a2a;
  --color-accent: #e8c547;      /* earned from editorial/maximalist tone */
  --color-text-primary: #f0ede8;
  --color-text-secondary: #888;
}
```

### 3. Motion

- Declare the motion intent: absent (reduces motion), micro (hover/focus only), purposeful (reveals state), theatrical (hero animations)
- All transitions on the same property must use the same easing and duration family — no mixing `ease-in` and `cubic-bezier` without intent
- Respect `prefers-reduced-motion` for any non-essential animation

```css
:root {
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --duration-fast: 120ms;
  --duration-base: 220ms;
}
```

### 4. Composition

- Define a spatial system: a base unit (4px or 8px) and a set of multiples. Apply it consistently to all padding, gap, and margin values.
- Use asymmetry intentionally — a wider left margin, an off-center focal point, a grid with unequal column weights — not uniform spacing on every side
- **Forbidden:** the same `border-radius` applied to every element. Vary it by element type and role (card vs button vs input vs avatar).

```css
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-4: 16px;
  --space-8: 32px;
  --space-16: 64px;
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-full: 9999px;
}
```

### 5. Atmosphere

- Add one atmospheric treatment that reinforces the tone: a noise texture, a grain overlay, a gradient background with angle and scale, a border treatment, a shadow system
- This should be visible but not distracting — it creates depth, not clutter
- If the tone is minimal/clinical, the atmospheric choice might be deliberate whitespace and hairline rules — that counts

---

## Quality bar

- The design declaration must appear before any component code
- Every dimension must be applied, even if the application is "none" (state it explicitly)
- CSS variables must be defined for all repeated values — no magic numbers in component styles
- The result should be distinguishable from a default Tailwind scaffold or a generic MUI/shadcn template

## Anti-patterns

- **Skipping the declaration** — going directly to code produces the generic default. The declaration is not optional.
- **Inter + purple + 8px everywhere** — the AI default trifecta. Forbidden by this skill.
- **Inline hex values** — every color must have a name. `#7c3aed` is not a name; `--color-accent` is.
- **Uniform spacing** — `padding: 16px` on every element with no variation. Spatial systems have variation.
- **Motion by default with no intent** — adding `transition: all 0.3s ease` as a habit. Declare why first.
