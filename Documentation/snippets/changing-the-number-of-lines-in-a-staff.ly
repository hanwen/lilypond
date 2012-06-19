%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
%% Translation of GIT committish: 1cda7b7b8219cb97399b8e7b56c1115aaf82c002
  texidocfr = "
Le nombre de lignes d'un portée se modifie par adaptation de la
propriété @code{line-count} du @code{StaffSymbol}.

"
  doctitlefr = "Modification du nombre de lignes de la portée"

  lsrtags = "specific-notation, staff-notation"

  texidoc = "
The number of lines in a staff may changed by overriding the
@code{StaffSymbol} property @code{line-count}.




"
  doctitle = "Changing the number of lines in a staff"
} % begin verbatim


upper = \relative c'' {
  c4 d e f
}

lower = \relative c {
  \clef bass
  c4 b a g
}

\score {
  \context PianoStaff <<
    \new Staff {
      \upper
    }
    \new Staff {
      \override Staff.StaffSymbol #'line-count = #4
      \lower
    }
  >>
}

