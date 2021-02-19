
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
