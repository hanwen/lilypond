%% Do not edit this file; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.4"

\header {
  lsrtags = "expressive-marks"

%% Translation of GIT committish: b2d4318d6c53df8469dfa4da09b27c15a374d0ca
  texidoces = "
Los cambios de dinámica con estilo de texto (como cresc. y dim.)
se imprimen con una línea intermitente que muestra su alcance.
Esta línea se puede suprimir de la siguiente manera:

"
  doctitlees = "Ocultar la línea de extensión de las expresiones textuales de dinámica"

%% Translation of GIT committish: d96023d8792c8af202c7cb8508010c0d3648899d
texidocde = "
Dynamik-Texte (wie cresc. und dim.) werden mit einer gestrichelten Linie
gesetzt, die ihre Dauer anzeigt.  Diese Linie kann auf foldenge Weise
unterdrückt werden:

"
  doctitlede = "Crescendo-Linien von Dynamik-Texten unterdrücken"

  texidoc = "
Text style dynamic changes (such as cresc. and dim.) are printed with a
dashed line showing their extent.  This line can be suppressed in the
following way:

"
  doctitle = "Hiding the extender line for text dynamics"
} % begin verbatim

\relative c'' {
  \override DynamicTextSpanner #'dash-period = #-1.0
  \crescTextCresc
  c1\< | d | b | c\!
}

