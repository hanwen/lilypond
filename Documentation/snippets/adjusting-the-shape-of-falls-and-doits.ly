%% Do not edit this file; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.4"

\header {
  lsrtags = "expressive-marks"

%% Translation of GIT committish: b2d4318d6c53df8469dfa4da09b27c15a374d0ca
  texidoces = "
Puede ser necesario trucar la propiedad
@code{shortest-duration-space} para poder ajustar el tamaño de las
caídas y subidas de tono («falls» y «doits»).

"
  doctitlees = "Ajustar la forma de las subidas y caídas de tono"

%% Translation of GIT committish: d96023d8792c8af202c7cb8508010c0d3648899d
texidocde = "
Die @code{shortest-duration-space}-Eigenschaft kann verändert werden, um
das Aussehen von unbestimmten Glissandi anzupassen.

"
  doctitlede = "Das Aussehen von unbestimmten Glissandi anpassen"

  texidoc = "
The @code{shortest-duration-space} property may have to be tweaked to
adjust the shape of falls and doits.

"
  doctitle = "Adjusting the shape of falls and doits"
} % begin verbatim

\relative c'' {
  \override Score.SpacingSpanner #'shortest-duration-space = #4.0
  c2-\bendAfter #+5
  c2-\bendAfter #-3
  c2-\bendAfter #+8
  c2-\bendAfter #-6
}

