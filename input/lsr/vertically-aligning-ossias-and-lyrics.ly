%% Do not edit this file; it is auto-generated from LSR!
%% Tags: vocal-music
\version "2.11.35"

\header { texidoc = "
This snippet shows of to use the @code{alignBelowContext} and
@code{alignAboveContext} properties, which may be needed for text
elements (e.g. lyrics) positioning, but also for musical contents such
as ossias.
" }

\paper {
  ragged-right = ##t
}

\relative <<
  \new Staff = "1" { c4 c s2 }
  \new Staff = "2" { c4  c s2 }
  \new Staff = "3" { c4  c s2 }
  { \skip 2
    <<
      \lyrics {
	\set alignBelowContext = #"1"
	below8 first staff
      }
      \new Staff {
	\set Staff.alignAboveContext = #"3"
	\times 4/6 {
	  \override TextScript #'padding = #3
	  c8^"this" d_"staff" e^"above" d_"last" e^"staff" f
	}
      }
    >> }
>>
