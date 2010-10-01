% Do not edit this file; it is automatically
% generated from Documentation/snippets/new
% This file is in the public domain.
%% Note: this file works from version 2.13.16
\version "2.13.36"

\header {
%% Translation of GIT committish: 0b55335aeca1de539bf1125b717e0c21bb6fa31b
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


  lsrtags = "text, vocal-music, spacing"
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

  % Reducing the minimum space below the staff and above the lyrics:
  \new Staff {
    \new Voice = melody \relative c' {
      c4 d e f
      g4 f e d
      c1
    }
  }
  \new Lyrics \with {
    \override VerticalAxisGroup #'inter-staff-spacing = #'((space . 1))
  }
  \lyricsto melody { aa aa aa aa aa aa aa aa aa }
>>
