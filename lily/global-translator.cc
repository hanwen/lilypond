/*
  global-translator.cc -- implement Global_translator

  source file of the GNU LilyPond music typesetter

  (c)  1997--1999 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "global-translator.hh"
#include "music-iterator.hh"
#include "debug.hh"

Global_translator::Global_translator()
{
  last_mom_ = 0;
}

void
Global_translator::add_moment_to_process (Moment m)
{
  if (m  > last_mom_)
    return;
  
  for (int i=0; i <  extra_mom_pq_.size(); i++)
    if (extra_mom_pq_[i] == m)
      return;
  extra_mom_pq_.insert (m);
}

void
Global_translator::modify_next (Moment &w)
{
  while (extra_mom_pq_.size() && 
	 extra_mom_pq_.front() <= w)
	
    w =extra_mom_pq_.get();
}

int
Global_translator::moments_left_i() const
{
  return extra_mom_pq_.size();
}

void
Global_translator::prepare (Moment m)
{
  now_mom_ = m;
}

Moment
Global_translator::now_mom () const
{
  return now_mom_;
}



Music_output*
Global_translator::get_output_p()
{
  return 0;
}

void
Global_translator::process ()
{
}
void
Global_translator::start ()
{
}
void
Global_translator::finish ()
{
}

void
Global_translator::run_iterator_on_me (Music_iterator * iter)
{
  while (iter->ok() || moments_left_i ())
    {
      Moment w;
      w.set_infinite (1);
      if (iter->ok())
	{
	  w = iter->next_moment();
	  DOUT << "proccing: " << w << '\n';
	  if (!lily_monitor->silent_b ("walking"))
	    iter->print();
	}
      
      modify_next (w);
      prepare (w);
      
      if (!lily_monitor->silent_b ("walking"))
	print();

      iter->process_and_next (w);
      process();
    }
}
