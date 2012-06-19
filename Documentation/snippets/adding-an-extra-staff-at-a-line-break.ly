%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
%% Translation of GIT committish: f5cfaf8ef4ac347702f554af0944ef0d8396e73a
  texidocfr = "
Lorsqu'une nouvelle portée vient s'ajouter après un saut de ligne,
LilyPond préserve un espace juste avant le saut de ligne -- pour un
éventuel changement d'armure qui, quoi qu'il en soit, ne sera pas
imprimé.  L'astuce consiste alors, comme indiqué dans l'exemple suivant,
à ajuster @code{Staff.explicitKeySignatureVisibility}.

"
  doctitlefr = "Ajout d'une portée supplémentaire après un saut de ligne"

  lsrtags = "workaround, breaks, contexts-and-engravers, staff-notation"


%% Translation of GIT committish: b482c3e5b56c3841a88d957e0ca12964bd3e64fa
  texidoces = "
Al añadir un pentagrama nuevo en un salto de línea, por desgracia
se añade un espacio adicional al final de la línea antes del salto
(reservado para hacer sitio a un cambio de armadura que de todas
formas no se va a imprimir). La solución alternativa es añadir un
ajuste para @code{Staff.explicitKeySignatureVisibility} como se
muestra en el ejemplo.

"
  doctitlees = "Añadir un pentagrama adicional en un salto de línea"

  texidoc = "
When adding a new staff at a line break, some extra space is
unfortunately added at the end of the line before the break (to fit in
a key signature change, which  will never be printed anyway).  The
workaround is to add a setting of
@code{Staff.explicitKeySignatureVisibility} as is shown in the example.


"
  doctitle = "Adding an extra staff at a line break"
} % begin verbatim


\score {
  \new StaffGroup \relative c'' {
    \new Staff
    \key f \major
    c1 c^"Unwanted extra space" \break
    << { c1 | c }
       \new Staff {
         \key f \major
         \once \override Staff.TimeSignature #'stencil = ##f
         c1 | c
       }
    >>
    c1 | c^"Fixed here" \break
    << { c1 | c }
       \new Staff {
         \once \set Staff.explicitKeySignatureVisibility = #end-of-line-invisible
         \key f \major
         \once \override Staff.TimeSignature #'stencil = ##f
         c1 | c
       }
    >>
  }
}

