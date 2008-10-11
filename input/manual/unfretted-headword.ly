% #!lilypond lcp-extract.ly -*- coding: utf-8; -*-

%%%
%%% les-cinq-pieds:
%%% extract for the lilypond documentaton project
%%%

%% Title:	Les cinq pieds
%% Composer: 	David Séverin
%% Date:	Juillet 2007
%% Instrument:	Violon Solo
%% Dedication:	A mon épouse Lívia De Souza Vidal
%% Additional:	avec l'aide de Krzysztof Wagenaar

%% Statement:

%% Here by, I, the composer, agree that this extract of my composition
%% be in the public domain and can be part of, used and presented in
%% the Lilypond Documention Project.

%% Statement Date: Octber the 9th, 2008


\version "2.11.61"


%%%
%%% Abreviations
%%%

db         = \markup { \musicglyph #"scripts.downbow" }
dub        = \markup { \line { \musicglyph #"scripts.downbow" " " \musicglyph #"scripts.upbow" } }
dubetc     = \markup { \line { \musicglyph #"scripts.downbow" " " \musicglyph #"scripts.upbow" "..." } }

ub         = \markup { \musicglyph #"scripts.upbow" }
udb        = \markup { \line { \musicglyph #"scripts.upbow" " " \musicglyph #"scripts.downbow" } }
udbetc     = \markup { \line { \musicglyph #"scripts.upbow" " " \musicglyph #"scripts.downbow" "..." } }

fermaTa    = \markup \musicglyph #"scripts.ufermata"

accel   = \markup \tiny \italic \bold "accel. ..."
ritar   = \markup \tiny \italic \bold "ritar. ..."

ignore     = \override NoteColumn #'ignore-collision = ##t


%%
%% Strings
%%

svib           = \markup \small "s. vib."
pvib           = \markup \small "p. vib."
mvib           = \markup \small "m. vib."
sulp           = \markup \small "s.p."
norm           = \markup \small "n."

quatre         = \markup \teeny "IV"


%%
%% Shifting Notes
%%

shift      = \once \override NoteColumn #'force-hshift = #0.9
shifta     = \once \override NoteColumn #'force-hshift = #1.2
shiftb     = \once \override NoteColumn #'force-hshift = #1.4


%%
%% Hairpin
%%

% aniente        = "a niente"
aniente        = \once \override Hairpin #'circled-tip = ##t


%%
%% Tuplets
%%

tupletbp       = \once \override Staff.TupletBracket #'padding = #2.25


%%
%% Flag [Note Head - Stem]
%%

noflag         = \once \override Stem #'flag-style = #'no-flag

%%%
%%% Functions
%%%

#(define-markup-command (colmark layout props args)
  (markup-list?)
  (let ((entries (cons (list '(baseline-skip . 2.3)) props)
       ))
   (interpret-markup layout entries
    (make-column-markup
     (map (lambda (arg)
	   (markup arg))
      (reverse args))))))


%%%
%%% Paper
%%%

#(set-global-staff-size 20)
%#(set-default-paper-size "a4" 'landscape)

\paper {
  between-system-padding = 9
}


%%%
%%% Header
%%%

\header {
  meter       = "lentement (circa 8 minutes)"
}


%%%
%%% Instruments
%%%

ViolinSolo = \relative c' {

  \voiceOne

  \set Score.markFormatter     =  #format-mark-box-numbers
  \override Score.VoltaBracket #'font-name                  = #"sans"
  \override Score.VoltaBracket #'extra-offset               = #'(0 . 1)
  \override SpacingSpanner     #'uniform-stretching         = ##t


  %% Measure 1
  \time 11/4
  \mark \default
  r2 ^\markup \colmark { \italic "fatigué" } r4
  <<
    { \shift d2 \glissando ^\markup \colmark { \quatre \dubetc \svib } \shifta e1 } \\
    { d2 \open \mf \< ~ \aniente d1  \! \> r4 r ^\markup \colmark { " " \fermaTa } \! }
  >>


  %% Measure 2
  \time 7/4
  \set Score.repeatCommands = #'((volta "¹) n.      ²) s.p."))
  <<
    { \shift d2 \glissando ^\markup \colmark { \quatre \udbetc } \shifta e1 } \\
    { d2 \open \mf \< ~ d1 \! \> ~ d4 ^\markup \colmark { " " \fermaTa } \! }
  >>
  \set Score.repeatCommands = #'((volta #f))


  %% Measure 3
  \time 15/4
  <<
    { \shift d2 \glissando ^\markup \colmark { \quatre \dubetc \pvib \norm } \shifta e1 \glissando d2 } \\
    { d2 \open \mf \< ~ d1 ~ d2 \ff  ~ d1 \> ~ d2 ^\markup \colmark { " " " " \svib } ~ d4 \pp}
  >>


  %% Measure 4
  \time 4/4
  \stemUp
  \tupletDown
  \times 2/3 { d4 ^\markup \colmark { \quatre \db \accel } d d }
  \times 2/3 { d4 ^\markup \colmark { " " \db " " \sulp } d d }
}


%%%
%%% Score
%%%

\score {

  <<
    \relative c' <<
      \new Staff {
        \set Staff.midiInstrument = "violin"
        \ViolinSolo
      }
    >>
    \override Score.Rest #'transparent = ##t
    \set Score.defaultBarType          = "empty"
  >>

  \layout  {
    indent = 0.0
    \context {
      \Staff
      \remove "Time_signature_engraver"
      \remove "Bar_number_engraver"
    }
  }
  \midi { }
}
