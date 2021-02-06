
\newcommand{\franklinhtml}[1]{~~~!#1~~~}

\newenvironment{thmBlock}[4]{
	\franklinhtml{
		<div class="theorem">
			<h2 class="theorem-header" id="}!#4\franklinhtml{">
				<a href="#}!#4\franklinhtml{">}#1: #2\franklinhtml{</a>
				<div class="theorem-type">}#3\franklinhtml{</div>
			</h2>
			<div class="theorem-content">
	}
}
{
	\franklinhtml{
		</div></div>
	}
}

\newcommand{\theoremref}[1]{\cite{!#1}}
\newcommand{\lemmaref}[1]{\cite{!#1}}
\newcommand{\definitionref}[1]{\cite{!#1}}


\newenvironment{theorem}[2]{
	\stepcounter{NumTheorems}
	\begin{thmBlock}{Theorem \arabic{NumTheorems}}{#1}{Theorem}{ \fakebiblabel{!#2 @ Theorem \arabic{NumTheorems}} }
}{
	\end{thmBlock}
}


\newenvironment{definition}[2]{
	\stepcounter{NumDefinitions}
	\begin{thmBlock}{Definition \arabic{NumDefinitions}}{#1}{Definition}{\fakebiblabel{!#2 @ Definition \arabic{NumDefinitions}}}
}{
	\end{thmBlock}
}


\newenvironment{lemma}[2]{
	\stepcounter{NumLemmas}
	\begin{thmBlock}{Lemma \arabic{NumLemmas}}{#1}{Lemma}{\fakebiblabel{!#2 @ Lemma \arabic{NumLemmas}}}
}{
	\end{thmBlock}
}


\newenvironment{dropdown}[1]{
	\franklinhtml{<button class="theorem-accordion"><div class="theorem-accordion-text">}
	#1
	\franklinhtml{</div></button><div class="theorem-panel"><p>}
}
{
	\franklinhtml{</p></div>}
}


\newenvironment{proof}{
	@@proof-box
	_**Proof.**_
}{
	\begin{right}
	$\blacksquare \, \, $
	\end{right}
	@@
}


\newcommand{\enabletheorems}{
	\newcounter{NumTheorems}
	\newcounter{NumDefinitions}
	\newcounter{NumLemmas}
}


\newcommand{\theoremscripts}{
~~~
<script>
var acc = document.getElementsByClassName("theorem-accordion");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.maxHeight) {
      panel.style.maxHeight = null;
    } else {
      panel.style.maxHeight = panel.scrollHeight + "px";
    }
  });
}
</script>
~~~
}
