# FranklinTheorems.jl
Theorems Environment for [Franklin.jl](https://franklinjl.org/), using syntax reminiscent of the LaTeX [`amsthm` package](https://ctan.org/pkg/amsthm?lang=en).

## Installation

This is a plugin for Franklin.
In order to install it, `add FranklinTheorems` in the Julia package manager.

To enable the plugin, add the following lines to the `utils.jl` file:
```julia
# Includes the Package, bringing the lx_functions into scope
using FranklinTheorems

# Includes the custom markdown files, bringing the `\newcommand` and `\newenvironment` definitions into scope.
Franklin.include_external_config(FranklinTheorems.config_path()) 
```

Additionally, FranklinTheorems also creates the `.theorem`, `.theorem-header`, `.theorem-type`, `.theorem-accordion`, `.theorem-panel`, `.theorem-accordion-text`, and `.proof-box` div environments. We provide a [CSS file](/src/FranklinTheorems.css) for the tufte Franklin style.
After installing the package, the following Julia code will return the path to a local copy of the CSS file:
```julia
using FranklinTheorems
FranklinTheorems.css_path()
```

## Usage

At the top of every markdown webpage you use this plugin for, include the line
```latex
\enabletheorems
```
and at the bottom of every such markdown webpage, include the lines
```latex
\theoremscripts
```

Then, you can create definitions, theorems, and lemmas:
```latex
\begin{definition}{The Name of The Defined}{label-name}
	This is the body of the definition.
	$$17 + 9$$
	_You **can** include styling and math in the body of the definition._
\end{definition}
```
You can similarly use `\begin{theorem}...\end{theorem}` and `\begin{lemma}...\end{lemma}`.
Further, if the optional parameter `label-name` is given, then you can run `\definitionref{label-name}` to create a link to the definition.
You can similarly run `\theoremref{...}` and `\lemmaref{...}`.
The label-name parameter can also be left empty if you do not want to refer to it elsewhere.

#### Custom Theorem Blocks

Suppose you want to use blocks other than `theorem`, `lemma`, and `definition`.
Then, in `utils.jl`, you can specify additional blocks you want to use.
For example, suppose you want to provide some corollaries. Then, you would write:
```latex
Franklin.include_external_config(FranklinTheorems.config_path(['corollary'])) 
```
Which would then export the `corollary` environment and `corollaryref` command, in addition to the standard `theorem`, `lemma`, and `definition` commands and environments.

#### Proofs

You can also include proofs, which creates a new CSS class and has a QEQ box at its end.
To start and end a proof, use `\begin{proof}...\end{proof}`.

In order to hide longer proofs, we also provide an interactive `dropdown` latex-style environment.
Then the syntax
```latex
\begin{dropdown}{Dropdown Button Title}
\begin{proof}
Write your proof here.
\end{proof}
\end{dropdown}
```
creates a button, and hides the proof.
The text of the button reads "Dropdown Button Title".
When clicked, the proof can be revealed and hidden.

The `dropdown` environment works without a proof inside of it; that's just the expected use-case.

The CSS is also written such that dropdown menus look nice immediately after a proof:
```latex
\begin{lemma}{Lovely Lemma}{lemma-eg}
This is a lovely lemma.
\end{lemma}
\begin{dropdown}{_Lovely proof of \lemmaref{lemma-eg}_}
\begin{proof}
This is a lovely proof.
\end{proof}
\end{dropdown}
```

