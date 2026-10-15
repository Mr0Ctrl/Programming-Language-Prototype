# Programming Language Prototype (MPL)

A basic programming language prototype and interpreter built using **Lex / Flex**, **Yacc / Bison**, and **C**.

---

## Features

- **Dynamic Typing:** Types (`int`, `float`, `bool`) are automatically inferred upon assignment.
- **Arithmetic & Logic:** Supports basic arithmetic (`+`, `-`, `*`, `/`), comparisons (`<`, `>`, `=`), and logical operations (`&`, `|`).
- **Print on Semicolon:** Appending `;` at the end of an expression or variable statement prints its value to standard output.
- **Turkish Keywords:**
  - `ise (<condition>)` : Conditional (`if`) block, closed with `:`
  - `yine` / `yine (<condition>)` : Loop (`while`) block, closed with `:`
  - `kop` : Break loop statement
- **Comments:** Single-line comments starting with `//`.

---

## Project Structure

- `mpl.l`: Lexical analyzer specification (Lex/Flex).
- `mpl.y`: Grammar and parser specification (Yacc/Bison).
- `base.h`: Core data types, symbol table management, and arithmetic operations.
- `build_mpl.sh`: Build script to generate and compile the interpreter binary.
- `code.mpl`: Sample source program demonstrating language syntax.

---

## Prerequisites

To build and run from source, ensure you have the following installed:

- **GCC** (or any standard C compiler)
- **Flex** (or Lex)
- **Bison** (or Yacc)

On Debian/Ubuntu:
```bash
sudo apt update
sudo apt install build-essential flex bison
```

---

## Build and Run

1. **Build the binary:**
   ```bash
   ./build_mpl.sh
   ```
   *(Alternatively: `bison -d mpl.y && lex mpl.l && gcc lex.yy.c mpl.tab.c -o mpl`)*

2. **Execute a script:**
   ```bash
   ./mpl < code.mpl
   ```

3. **Run interactively:**
   ```bash
   ./mpl
   ```

---

## Example Syntax (`code.mpl`)

```text
xa := 10        // Inferred as int
yb := 0 - 3     // Assignment using :=
zc := xa * yb   // Arithmetic multiplication
qd := 11.5      // Inferred as float

yb;             // Prints the value of yb (-3)

ise (1)
    yb := 15;   // Prints 15
:
```
