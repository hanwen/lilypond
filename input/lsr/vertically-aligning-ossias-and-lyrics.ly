%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.52"

\header {
  lsrtags = "vocal-music, tweaks-and-overrides, spacing"

  texidoc = "
This snippet demonstrates the use of the context properties
@code{alignBelowContext} and @code{alignAboveContext} to control the
positioning of lyrics and ossias.

"
  doctitle = "Vertically aligning ossias and lyrics"
} % begin verbatim
\paper {
  ragged-right = ##t
}

\relative c' <<
  \new Staff = "1" { c4 c s2 }
  \new Staff = "2" { c4 c s2 }
  \new Staff = "3" { c4 c s2 }
  { \skip 2
    <<
      \lyrics {
        \set alignBelowContext = #"1"
        lyrics4 below
      }
      \new Staff \with {
        alignAboveContext = #"3"
        fontSize = #-2
        \override StaffSymbol #'staff-space = #(magstep -2)
        \remove "Time_signature_engraver"
      } {
        \times 4/6 {
          \override TextScript #'padding = #3
          c8^"ossia above" d e d e f
        }
      }
    >>
  }
>>
