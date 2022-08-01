module FranklinTheorems

import Franklin
export lx_fakebiblabel, lx_newcounter, lx_stepcounter, lx_arabic


module ExportConfigPath

	export css_path, config_path

	"""
	Returns a path to FranklinTheorem's default CSS file. Copy this file to the Franklin `\\_css\\` directory.
	"""
	function css_path()
		return normpath(joinpath(@__FILE__, "..", "FranklinTheorems.css"))
	end

	"""
	Returns a path to FranklinTheorem's markdown file, full of LaTeX-style definitions.
	By default, the theorem, lemma, and definition blocks are defined.
	If a list of strings is given, then the associated counters and environments are created.
	Since this is dynamic, because of the optional parameters, this returns a path to a tempfile.
	"""
	function config_path()
		config_path([])
	end
	function config_path(theorem_class_names)
		all_class_names = [["theorem", "lemma", "definition"]; theorem_class_names]
		baseMarkdownText = read(normpath(joinpath(@__FILE__, "..", "FranklinTheorems.md")), String)

		f = tempname()
		write(f, baseMarkdownText * "\n" * make_custom_environments(all_class_names))
		return f
	end

	"""
	Returns a path to a temporary file that includes Franklin-Markdown code for a custom amstheorem-style environment.
	"""
	function make_custom_environments(theorem_class_names)
		
		env_string = ""
		enable_string = "\\newcommand{\\enabletheorems}{"

		for i=1:length(theorem_class_names)
			defn_name = theorem_class_names[i]
			defn_titlecase = titlecase(defn_name)
			defn_body = """
\\newcommand{\\$(defn_name)ref}[1]{\\cite{!#1}}

\\newenvironment{$(defn_name)}[2]{
	\\stepcounter{Num$(defn_name)}
	\\begin{thmBlock}{$(defn_titlecase) \\arabic{Num$(defn_name)}}{#1}{$(defn_titlecase)}{ \\fakebiblabel{!#2 @ $(defn_titlecase) \\arabic{Num$(defn_name)}} }
}{
	\\end{thmBlock}
}
			"""
			env_string = env_string * "\n" * defn_body
			enable_string = enable_string * "\n" * "\\newcounter{Num$(defn_name)}"
		end

		enable_string = enable_string * "\n}"

		return env_string * "\n" * enable_string
	end

end

using .ExportConfigPath



"""
Specialized code for automatic numbering by abuse of the biblabel function.

- Given an input of form `\\fakebiblable{@ Legible Name}`, this returns the string `"Legible Name"`
- Given an input of form `\\fakebiblabel{goob @ Legible Name}`, this runs `\\biblabel{goob}{Legible Name}`, so that Franklin's referencing system keeps track of `goob` as a name that points to `"Legible Name"`, and the function returns the string `"goob"`.

This `@` symbol approach is a hack to allow a single optional input variable to the function.
The `@` symbol was chosen because of its relevance to LaTeX.

Further, the string `"Legible Name"` is always parsed by Franklin, which has two notable consequences
1. Other lx_functions like `\\arabic{counter}` can be used in the full name
2. Markdown syntaxing like `_italics_` will be parsed into `<em>italics<em>`, which breaks the references

So, while `Legible Name` can reference counters, it should not have any markdown styling.
"""
function lx_fakebiblabel(lxc, _)
	args = Franklin.content(lxc.braces[1]) |> strip |> split

	nvars = length(args)

	if nvars < 2
		error("Bad fakebiblabel input: Less than 2 inputs were given. Input was:\n\\fakebiblabel{" * join(args, " ") * "}")
	end

	if args[1] == "@"
		return Franklin.fd2html(join(args[2:end], " "), internal=true, nop=true)
	elseif args[2] == "@"
		ref_name = args[1]
		legible_name = Franklin.fd2html(join(args[3:end], " "), internal=true, nop=true)
		Franklin.fd2html("\\biblabel{" * ref_name * "}{" * legible_name * "}", internal=true)
		return ref_name
	else
		error("Bad fakebiblabel input: @ was not the second input. Input was:\n\\fakebiblabel{" * join(args, " ") * "}")
	end
end


# Module for the counters. By making this into a module, this hides
# access to the counters dictionary. If you need a new way to interact
# with the system of counters, impliment a new method in this module.
module LxCounters
	
	# Used for latex-style parsing
	using FranklinUtils

	export lx_newcounter, lx_stepcounter, lx_arabic

	# The core dictionary that stores all the things we want to count.
	counters = Dict{String,Int64}()

	"""
	Call `\\newcounter{name}` to create a new counter. Returns an empty string.
	"""
	function lx_newcounter(lxc, _)
		args, kwargs = lxargs(lxc)

		name = string(args[1])

		delete!(counters, name)
		get!(counters, name, 0)
		return ""
	end

	"""
	Call `\\stepcounter{name}` to incriment the value of a counter by 1. Returns an empty string.
	"""
	function lx_stepcounter(lxc, _)
		args, kwargs = lxargs(lxc)

		name = string(args[1])

		counters[name] = counters[name] + 1
		return ""
	end

	"""
	Call `\\arabic{name}` to return the value of a counter, as an arabic number.
	"""
	function lx_arabic(lxc, _)
		args, kwargs = lxargs(lxc)

		name = string(args[1])

		return string(counters[name])
	end

end

using .LxCounters

end # Module
