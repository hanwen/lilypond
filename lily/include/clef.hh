/*   
  clef.hh -- declare 
  
  source file of the GNU LilyPond music typesetter
  
  (c) 2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  
 */

#ifndef CLEF_HH
#define CLEF_HH
#include "lily-guile.hh"
#include "lily-proto.hh"

struct Clef 
{
  DECLARE_SCHEME_CALLBACK(before_line_breaking, (SCM ));
  static bool has_interface (Score_element*);
  static void set_interface (Score_element*);
};


#endif /* CLEF_HH */

