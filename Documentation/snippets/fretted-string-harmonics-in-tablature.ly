% DO NOT EDIT this file manually; it is automatically
% generated from Documentation/snippets/new
% Make any changes in Documentation/snippets/new/
% and then run scripts/auxiliar/makelsr.py
%
% This file is in the public domain.
%% Note: this file works from version 2.14.0
\version "2.14.0"

\header {
%% Translation of GIT committish: 70f5f30161f7b804a681cd080274bfcdc9f4fe8c
  texidoces = "
Armónicos sobre cuerdas pisadas (armónicos artificiales):
"
  doctitlees = "Armónicos sobre cuerdas pisadas en tablatura"



%% Translation of GIT committish: f86f00c1a8de0f034ba48506de2801c074bd5422
  texidocde = "
Flageolett für Bundinstrumente:
"
  doctitlede = "Flageolett von Bundinstrumenten in einer Tabulatur"

%% Translation of GIT committish: 40bf2b38d674c43f38058494692d1a0993fad0bd
  texidocfr = "
Harmoniques et tablature (harmoniques artificielles)
"
  doctitlefr = "Harmoniques et tablature"


  lsrtags = "fretted-strings"
  texidoc = "
Fretted-string harmonics:
"
  doctitle = "Fretted-string harmonics in tablature"
} % begin verbatim


pinchedHarmonics = {
   \textSpannerDown
   \override TextSpanner #'bound-details #'left #'text =
      \markup {\halign #-0.5 \teeny "PH" }
      \override TextSpanner #'style =
         #'dashed-line
   \override TextSpanner #'dash-period = #0.6
   \override TextSpanner #'bound-details #'right #'attach-dir = #1
   \override TextSpanner #'bound-details #'right #'text =
      \markup { \draw-line #'(0 . 1) }
   \override TextSpanner #'bound-details #'right #'padding = #-0.5
}

harmonics = {
  %artificial harmonics (AH)
  \textLengthOn
  <\parenthesize b b'\harmonic>4_\markup{ \teeny "AH 16" }
  <\parenthesize g g'\harmonic>4_\markup{ \teeny "AH 17" }
  <\parenthesize d' d''\harmonic>2_\markup{ \teeny "AH 19" }
  %pinched harmonics (PH)
  \pinchedHarmonics
  <a'\harmonic>2\startTextSpan
  <d''\harmonic>4
  <e'\harmonic>4\stopTextSpan
  %tapped harmonics (TH)
  <\parenthesize g\4 g'\harmonic>4_\markup{ \teeny "TH 17" }
  <\parenthesize a\4 a'\harmonic>4_\markup{ \teeny "TH 19" }
  <\parenthesize c'\3 c''\harmonic>2_\markup{ \teeny "TH 17" }
  %touch harmonics (TCH)
  a4( <e''\harmonic>2. )_\markup{ \teeny "TCH" }
}

frettedStrings = {
  %artificial harmonics (AH)
  \harmonicByFret #4 g4\3
  \harmonicByFret #5 d4\4
  \harmonicByFret #7 g2\3
  %pinched harmonics (PH)
  \harmonicByFret #7 d2\4
  \harmonicByFret #5 d4\4
  \harmonicByFret #7 a4\5
  %tapped harmonics (TH)
  \harmonicByFret #5 d4\4
  \harmonicByFret #7 d4\4
  \harmonicByFret #5 g2\3
  %touch harmonics (TCH)
  a4 \harmonicByFret #9 g2.\3
}

\score {
  <<
    \new Staff {
      \new Voice {
        \clef "treble_8"
        \harmonics
      }
    }
    \new TabStaff {
      \new TabVoice {
        \frettedStrings
      }
    }
  >>
}