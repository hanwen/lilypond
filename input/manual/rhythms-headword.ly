\version "2.11.51"
\include "english.ly"
#(set-global-staff-size 15)
\paper {
  line-width = 16\cm
  indent = 0\cm
}

% NR 1.2 Rhythms

% Beethoven, Op. 81a
% Piano sonata 26 - Das Lebewohl
% Movt II - Abwesenheit
% Measures 31 - 34

\layout {
  \context {
    \Score
    \override SpacingSpanner #'base-shortest-duration =
      #(ly:make-moment 1 40)
      %\override SpacingSpanner #'strict-grace-spacing = ##t
  }
  \context {
    \Staff
    \remove "Time_signature_engraver"
  }
}

\new PianoStaff <<

   % RH Staff
   \new Staff {
      \clef treble
      \key c \minor
      \time 2/4
      \set Score.currentBarNumber = #31

      <c''' c''>8 ( -\markup {
        \override #'(baseline-skip . 2) \italic \column {
          \line { a tempo }
          cantabile
        }
      }
      <g'' g'>8 )
      ~
      <g'' g'>8 (
      <a'' a'>16
      <f'' f'>16 )

      |

      \afterGrace
         <f'' f'>8 [ (
         {
            e''16 [
            f''16
            e''16
            d''16 ]
         }
      <e''! e'>16
      <f'' f'>16 ] )
      \once \override TextScript #'padding = #3.8
      <g'' g'>16 ( \staccato -\markup { \italic cresc. }
      <a'' a'>16 ) \staccato
      <bf'' bf'>32  (
      <b'' b'>32 )
      <b'' b'>32 (
      <c''' c''>32 )

      |
      
      \once \override DynamicLineSpanner #'padding = #2
      b''32 ( \p \>
      c'''32
      d'''32
      c'''32 ) \!
      g''8 (
      ~
      g''32 [
      a''64
      g''64 ) ]

      a''64 ( [
      g''64 )
      bf''64 (
      a''64 ) ]

      bf''64 ( [
      a''64 )
      c'''64 (
      b''64 ) ]

      c'''128 ( [
      b''128
      d'''128
      c'''128
      f'''64
      f''64 ) ]
      
      |

      \afterGrace
         <f'' f'>8 [ (
         {
            e''16 [
            f''16
            e''16
            d''16 ]
         }
      <e''! e'>16
      <f'' f'>16 ] )
      <g'' g'>16 ( \staccato -\markup { \italic cresc. }
      <af''! af'!>16 ) \staccato
      <bf'' bf'>32  (
      <b'' b'>32 )
      <b'' b'>32 (
      <c''' c''>32 )
   }

   % LH Staff
   \new Staff {
      \clef bass
      \key c \minor
      \time 2/4

      <g e>32
      c'32
      <g e>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32

      <a f>32
      c'32
      <a f>32
      c'32

      |
      
      <bf g>32
      c'32
      <bf g>32
      c'32

      <bf g>32
      c'32
      <bf g>32
      c'32

      <bf g>32
      c'32
      <a f>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32

      |

      <g e>32
      c'32
      <g e>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32

      <a f>32
      c'32
      <a f>32
      c'32

      |
      
      <bf! g>32
      c'32
      <bf g>32
      c'32

      <bf g>32
      c'32
      <bf g>32
      c'32

      <bf g>32
      c'32
      <af! f>32
      c'32

      <g e>32
      c'32
      <g e>32
      c'32
   }

>>
