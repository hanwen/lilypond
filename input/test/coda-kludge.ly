\version "1.7.18"
% TODO: rethink name and whole file -- possible delete or major
% changes.  See repeat-manual.ly
\header{
	texidoc="@cindex Coda Kludge"
}
%{
Hi,
	I want to write some music that has the structure:

	Intro
	\repeat 4 { Chorus [first-ending] verse }
	fifth-ending final

	The obvious:

	\repeat 4 { Chorus \alternative{{first-ending}{}} verse}
	\alternative{{}{fifth-ending}}
	final

	doesn't work.

	And the (logically correct but ugly)

	\repeat 4 {Chorus}
	\alternative {{first-ending verse}{fifth ending}}
	final

	is very ugly, because the volta bracket keeps going for so
	long.

	Peter C
%}

\score{
	<
		\context Staff \notes\relative c''{
			c c c c
			% coda-klugde: let volta span only one bar
			\property Staff.voltaSpannerDuration = #(ly:make-moment 1 1)
			\repeat "volta" 5 { d d d d }
				\alternative { { e e e e f f f f }
			{ g g g g } }
		}
		\context Lyrics \lyrics{
			intro1
			\repeat fold 5 {}
			\alternative {
				{ chorus1 one verse1 }
				{ chorus1 two verse1 }
				{ chorus1 three verse }
				{ chorus1 four verse }
			}
			five1
		}
	>
\paper{raggedright = ##t}
}


% 
%% new-chords-done %%
