
\version "1.3.96"
	%
% setup for Request->Element conversion. Guru-only
%

StaffContext=\translator {
	\type "Engraver_group_engraver";
	\name Staff ;
	\consists "Output_property_engraver";	
	Generic_property_list = #generic-staff-properties
	\consists "Property_engraver";
	
	\consists "Multi_measure_rest_engraver";

	\consists "Bar_engraver";
 % Bar_engraver must be first so default bars aren't overwritten
% with empty ones.


%	\consists "Repeat_engraver";
	\consists "Volta_engraver";
	\consists "Separating_line_group_engraver";	



	\consists "Clef_engraver";
	\consists "Key_engraver";
	\consists "Time_signature_engraver";
	\consists "Staff_symbol_engraver";
	\consists "Collision_engraver";
	\consists "Rest_collision_engraver";
	\consists "Local_key_engraver";
	\consists "Piano_pedal_engraver";

	\consistsend "Axis_group_engraver";

%{
	The Instrument_name_engraver puts the name of the instrument
	(\property Staff.instrument; Staff.instr for subsequent lines)
	to the left of a staff.

	This is commented out, so you don't get funny things on the
	PianoStaff	
	\consists "Instrument_name_engraver";
%}


	  
	\accepts "Voice";
}

ChoirStaffContext = \translator {
	\type "Engraver_group_engraver";
	\name ChoirStaff;
	alignmentReference = \center;
	\consists "System_start_delimiter_engraver";
	systemStartDelimiterGlyph = #'bracket

	\accepts "Staff";
	\accepts "RhythmicStaff";
	\accepts "GrandStaff";
	\accepts "PianoStaff";
	\accepts "Lyrics";
	\accepts "ChordNames";
}


RhythmicStaffContext=\translator{
	\type "Engraver_group_engraver";
	
	\consists "Property_engraver";
	\consists "Output_property_engraver";	

	Generic_property_list = #generic-staff-properties

	\consists "Pitch_squash_engraver";
	\consists "Separating_line_group_engraver";	
	\name RhythmicStaff;
	Bar \push #'bar-size = #4
	VoltaBracket \push #'minimum-space =  #15  % urg, in \pt
	VoltaBracket \push #'padding =  #5  % urg, in \pt
	StaffSymbol \push #'line-count = #1	

%	\consists "Repeat_engraver";
	\consists "Volta_engraver";
	\consists "Bar_engraver";
	\consists "Time_signature_engraver";
	\consists "Staff_symbol_engraver";
	\consistsend "Axis_group_engraver";
	\accepts "Voice";
}


VoiceContext = \translator {
	\type "Engraver_group_engraver";
	\name Voice;

	Generic_property_list = #generic-voice-properties
	
	\consists "Output_property_engraver";	
	\consists "Arpeggio_engraver";

	\consists "Dynamic_engraver";   % must come before text_engraver.
	\consists "Text_spanner_engraver";
	\consists "Property_engraver";
	
	\consists "Breathing_sign_engraver";
 	\consists "Rest_engraver";
	\consists "Dot_column_engraver";
	\consists "Stem_engraver";
	\consists "Beam_engraver";
	\consists "Auto_beam_engraver";

	\consists "Chord_tremolo_engraver";
	\consists "Melisma_engraver";
	\consists "Text_engraver";
	\consists "A2_engraver";
	\consists "Voice_devnull_engraver";

	\consists "Script_engraver";
	\consists "Script_column_engraver";
	\consists "Rhythmic_column_engraver";
	\consists "Slur_engraver";
	\consists "Tie_engraver";
	\consists "Tuplet_engraver";
	\consists "Grace_position_engraver";
	\consists "Skip_req_swallow_translator";
	\accepts Thread; % bug if you leave out this!
	\accepts Grace;
}

GraceContext=\translator {
	\type "Grace_engraver_group";
	\name "Grace";
	\consists "Output_property_engraver";	

	Generic_property_list = #generic-grace-properties
	
	\consists "Note_heads_engraver";
	\consists "Local_key_engraver";
	\consists "Stem_engraver";
	\consists "Beam_engraver";
	\consists "Slur_engraver";
	
	\consists "Auto_beam_engraver";
	\consists "Align_note_column_engraver";

	\consists "Rhythmic_column_engraver";

	\consists "Dynamic_engraver";% in Grace ???
	\consists "Text_engraver"; % in Grace ???

	\consists "Property_engraver";

	Stem \push  #'style = #"grace"
	Stem \push  #'flag-style = #"grace"
	Stem \push  #'stem-length = #6.0
	Stem \push  #'direction = #1

	NoteHead \push #'font-size = #-1
	Stem \push #'font-size = #-1
	Stem \push #'stem-shorten = #'(0)
	Beam \push #'font-size = #-1
	TextScript \push #'font-size = #-1
	Slur \push #'font-size = #-1
	Accidentals \push #'font-size = #-1
	Beam \push #'thickness = #0.3
	Beam \push #'space-function = #(lambda (x) 0.5)

	Stem \push #'lengths = #(map (lambda (x) (* 0.8 x)) '(3.5 3.5 3.5 4.5 5.0))
	Stem \push #'beamed-lengths =
		#'(0.0 2.5 2.0 1.5)
	Stem \push #'beamed-minimum-lengths
		 = #(map (lambda (x) (* 0.8 x)) '(0.0 2.5 2.0 1.5))

	weAreGraceContext = ##t   
	graceAccidentalSpace= 1.5 ; % in staff space
}

ThreadContext = \translator{
	\type Engraver_group_engraver;
	\consists "Thread_devnull_engraver";
	\consists "Note_heads_engraver";
	\consists "Output_property_engraver";	
	Generic_property_list = #generic-thread-properties
	\consists "Property_engraver";
	\name Thread;
}

GrandStaffContext=\translator{
	\type "Engraver_group_engraver";
	\name GrandStaff;
	\consists "Span_bar_engraver";
	\consists "Span_arpeggio_engraver";
	\consists "System_start_delimiter_engraver";
	systemStartDelimiterGlyph = #'brace
	
	\consists "Property_engraver";	
	Generic_property_list = #generic-grand-staff-properties
	\accepts "Staff";
}

PianoStaffContext = \translator{
	\GrandStaffContext
	\name "PianoStaff";

	\consists "Vertical_align_engraver";

	alignmentReference = \center;
	VerticalAlignment \push #'threshold = #'(12 . 12) 

%	\consistsend "Axis_group_engraver";
}

StaffGroupContext= \translator {
	\type "Engraver_group_engraver";
	\name StaffGroup;

	\consists "Span_bar_engraver";
	\consists "Span_arpeggio_engraver";
	\consists "Output_property_engraver";	
	systemStartDelimiterGlyph = #'bracket
	\consists "System_start_delimiter_engraver";
	\accepts "Staff";
	\accepts "RhythmicStaff";
	\accepts "GrandStaff";
	\accepts "PianoStaff";
	
	\accepts "Lyrics";
	\accepts "ChordNames";
}


% UGH! JUNKME
LyricsVoiceContext= \translator{
	\type "Engraver_group_engraver";
	\consistsend "Axis_group_engraver";
	LyricVoiceMinimumVerticalExtent = #(cons -1.2 1.2)

	\name LyricVoice ;
	\consists "Separating_line_group_engraver";
	\consists "Lyric_engraver";
	\consists "Extender_engraver";
	\consists "Hyphen_engraver";
	\consists "Stanza_number_engraver";
	phrasingPunctuation = #".,;:!?\""
	
}
NoteNamesContext = \translator {
	\type "Engraver_group_engraver";
	\name NoteNames;
	\consistsend "Axis_group_engraver";
	\consists "Note_name_engraver";
	\consists "Separating_line_group_engraver";
}

LyricsContext = \translator {
	\type "Engraver_group_engraver";
	\name Lyrics;
	\consists Vertical_align_engraver; %need this for getting folded repeats right.
	Generic_property_list = #generic-lyrics-properties
	\consists "Property_engraver";
	\consistsend "Axis_group_engraver";
	
	\accepts "LyricVoice";
}

ChordNamesVoiceContext = \translator {
	\type "Engraver_group_engraver";
	\name ChordNamesVoice ;

	\consists "Output_property_engraver";	
	\consistsend "Axis_group_engraver";
	\consists "Separating_line_group_engraver";
	\consists "Chord_name_engraver";
}
ChordNamesContext = \translator {
	\type "Engraver_group_engraver";
	\name ChordNames;

	Generic_property_list = #generic-chord-staff-properties

	\consists "Property_engraver";	
	\consists "Output_property_engraver";	
	\accepts "ChordNamesVoice";

	VerticalAxisGroup \push #'invisible-staff = ##t
	\consistsend "Axis_group_engraver";
	}


ScoreWithNumbers = \translator {
 	\type "Score_engraver";

	% uncomment to bar numbers on a whole system.
	\consists "Bar_number_engraver";
}

StupidScore = \translator {
 	\type "Score_engraver";
	\name Score;
	\consists "Note_heads_engraver";
}



BarNumberingStaffContext = \translator {
	\StaffContext
	\consists "Mark_engraver";
}

HaraKiriStaffContext = \translator {
	\StaffContext
	\remove "Axis_group_engraver";
	\consistsend "Hara_kiri_engraver";	  
	\consists "Instrument_name_engraver";
	\accepts "Voice";
}
%{
  The HaraKiriStaffContexts doesn't override \name,
  so it is still named `Staff'.

  %\translator { \HaraKiriStaffContext }
%}

OrchestralPartStaffContext = \translator {
	\StaffContext
	\consists "Mark_engraver";
}

ScoreContext = \translator {
	\type Score_engraver;
	\name Score;
	

	\consists "Repeat_acknowledge_engraver";
	\consists "Timing_engraver";
	\consists "Output_property_engraver";	
	\consists "System_start_delimiter_engraver";
	\consists "Mark_engraver";	
	\consists "Break_align_engraver";
	\consists "Spacing_engraver";
	\consists "Vertical_align_engraver";

	\consists "Lyric_phrasing_engraver";
	\consists "Bar_number_engraver";
	\consists "Span_arpeggio_engraver";

	
	\accepts "Staff";
	\accepts "StaffGroup";
	\accepts "RhythmicStaff";	
	\accepts "Lyrics";
	\accepts "ChordNames";
	\accepts "GrandStaff";
	\accepts "ChoirStaff";
	\accepts "PianoStaff";
	\accepts "NoteNames";

	soloText = #"Solo"
	soloIIText = #"Solo II"
	aDueText = #"\\`a2"
	soloADue = ##t
	splitInterval = #'(0 . 1)
	changeMoment = #`(,(make-moment 0 0) . ,(make-moment 1 512))

	defaultClef = #"treble"

	StaffMinimumVerticalExtent = #(cons -4.0 4.0)

	barAuto = ##t
	voltaVisibility = ##t
	%  name, glyph id, c0 position
	supportedClefTypes = #'(
	  ("treble" . ("clefs-G" -2))
	  ("violin" . ("clefs-G" -2))
	  ("G" . ("clefs-G" -2))
	  ("G2" . ("clefs-G" -2))
	  ("french" . ("clefs-G" -4 ))
	  ("soprano" . ("clefs-C" -4 ))
	  ("mezzosoprano" . ("clefs-C" -2 ))
	  ("alto" . ("clefs-C" 0 ))
	  ("tenor" . ("clefs-C" 2 ))
	  ("baritone" . ("clefs-C" 4 ))
	  ("varbaritone"  . ("clefs-F" 0))
	  ("bass" . ("clefs-F" 2 ))
	  ("F" . ( "clefs-F" 2))
	  ("subbass" . ("clefs-F" 4))
	)
	% where is c0 in this clef?
	clefPitches = #'(("clefs-G" . -4)
	  ("clefs-C" . 0)
	  ("clefs-F" . 4))
	  	

        automaticPhrasing = ##t;
	alignmentReference = \down;
	defaultClef = #"treble"
	defaultBarType = #"|"
	systemStartDelimiterGlyph = #'bar-line
	explicitClefVisibility = #all-visible
	explicitKeySignatureVisibility = #all-visible
	
	scriptDefinitions = #default-script-alist

	startSustain = #"Ped."
	stopSustain = #"*"
	stopStartSustain = #"*Ped."
	startUnaChorda = #"una chorda"
	stopUnaChorda = #"tre chorde"
	% should make separate lists for stopsustain and startsustain 


       %
       % what order to print accs.  We could compute this, 
       % but computing is more work than putting it here.
       %
       % Flats come first, then sharps.
       keyAccidentalOrder = #'(
         (6 . -1) (2  . -1) (5 . -1 ) (1  . -1) (4  . -1) (0  . -1) (3  . -1)
	 (3  . 1) (0 . 1) (4 . 1) (1 . 1) (5 . 1) (2 . 1) (6 . 1)
       )
	breakAlignOrder = #'(
	  Instrument_name
	  Left_edge_item
	  Span_bar
	  Breathing_sign
	  Clef_item
	  Key_item
	  Staff_bar
	  Time_signature
	  Stanza_number
	)


	\elementdescriptions #all-element-descriptions
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO: uniform naming.;  
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	


	\include "auto-beam-settings.ly";

}

OrchestralScoreContext= \translator {
	\ScoreContext
}

