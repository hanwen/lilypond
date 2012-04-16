%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "correction-wanted, vocal-music, workaround, text, spacing"

%% Translation of GIT committish: 6977ddc9a3b63ea810eaecb864269c7d847ccf98
  texidoces = "
Este fragmento de código muestra cómo situar la línea de base de la
letra más cerca del pentagrama.

"
  doctitlees = "Ajuste del especiado vertical de la letra"


%% Translation of GIT committish: 9a65042d49324f2e3dff18c4b0858def81232eea
  texidocfr = "
Cet extrait illustre la manière de rapprocher la ligne de paroles
de la portée.

"
  doctitlefr = "Ajustement de l'espacement vertical des paroles"


  texidoc = "
This snippet shows how to bring the lyrics line closer to the staff.

"
  doctitle = "Adjusting lyrics vertical spacing"
} % begin verbatim

% Default layout:
<<
  \new Staff \new Voice = melody \relative c' {
    c4 d e f
    g4 f e d
    c1
  }
  \new Lyrics \lyricsto melody { aa aa aa aa aa aa aa aa aa }

  \new Staff {
    \new Voice = melody \relative c' {
      c4 d e f
      g4 f e d
      c1
    }
  }
  % Reducing the minimum space below the staff and above the lyrics:
  \new Lyrics \with {
    \override VerticalAxisGroup #'nonstaff-relatedstaff-spacing = #'((basic-distance . 1))
  }
  \lyricsto melody { aa aa aa aa aa aa aa aa aa }
>>
