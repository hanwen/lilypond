\version "2.1.22"
\header {

texidoc ="Polyphonic rhythms and rests do not disturb
@code{\lyricsto}."

}

\score {
    \notes {
       \clef violin
       \time 8/8
       \key des \major
       <<
	   \context Voice = one {
	       \voiceOne
	       bes'4 bes'4
	       bes'4 bes'4
	   }
	  \context Voice = two {
	      \voiceTwo
	      ees'8 r8 r8 r8 ees' r8 r8 r8 
          }
          \lyricsto "two" \lyrics \new Lyrics {
             Do na
         }
	 \lyrics  \lyricsto "one" \new Lyrics
	   {
	       Do mi nus ex
	   }
       >>
    }
    \paper { raggedright = ##t}
}

