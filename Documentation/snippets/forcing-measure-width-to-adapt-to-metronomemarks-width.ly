%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
%% Translation of GIT committish: 30339cb3706f6399c84607426988b25f79b4998c
  texidocfr = "
Par défaut, les indications métronomiques n'influencent en rien
l'espacement horizontal.  Dans le cas où elles se suivent sur des silences
multimesures, elle peuvent se retrouver trop proche l'une de l'autre, et
donc paraître quelque peu imbriquées comme dans la première partie de
l'exemple ci-dessous.  La solution consiste alors à appliquer une simple
dérogation comme dans la deuxième partie.

"
  doctitlefr = "Adaptation de la largeur de mesure selon le MetronomeMark"

  lsrtags = "workaround, staff-notation"

  texidoc = "
By default, metronome marks do not influence horizontal spacing.  This
has one downside: when using compressed rests, some metronome marks may
be too close and therefore are printed vertically stacked, as
demonstrated in the first part of this example.  This can be solved
through a simple override, as shown in the second half of the example.

"
  doctitle = "Forcing measure width to adapt to MetronomeMark's width"
} % begin verbatim


example = {
  \tempo "Allegro"
  R1*6
  \tempo "Rall."
  R1*2
  \tempo "A tempo"
  R1*8
}

{
  \compressFullBarRests

  \example

  R1
  R1

  \override Score.MetronomeMark #'extra-spacing-width = #'(0 . 0)
  \example
}

