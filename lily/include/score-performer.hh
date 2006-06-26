/*
  score-performer.hh -- declare Score_performer

  (c) 1996--2006 Han-Wen Nienhuys <hanwen@xs4all.nl>
  Jan Nieuwenhuizen <janneke@gnu.org>
*/

#ifndef SCORE_PERFORMER_HH
#define SCORE_PERFORMER_HH

#include "moment.hh"
#include "performer-group.hh"
#include "score-translator.hh"

/**
   Top level performer. Completely takes care of MIDI output
*/
class Score_performer : public Score_translator,
			public virtual Performer_group
{
public:
  VIRTUAL_COPY_CONSTRUCTOR (Translator_group, Score_performer);
  ~Score_performer ();
  Performance *performance_;

  Score_performer ();
protected:
  DECLARE_LISTENER (finish);
  DECLARE_LISTENER (prepare);
  DECLARE_LISTENER (one_time_step);

  /* Engraver_group_engraver interface */
  virtual void connect_to_context (Context *);
  virtual void disconnect_from_context ();
  virtual void initialize ();
  virtual void announce_element (Audio_element_info);
  virtual int get_tempo () const;
  virtual void play_element (Audio_element *p);
  virtual SCM get_output ();
  virtual void derived_mark () const;
private:
  void header (Midi_stream &);

  Audio_column *audio_column_;
  bool skipping_;
  Moment skip_start_mom_;
  Moment offset_mom_;
};

#endif // SCORE_PERFORMER_HH
