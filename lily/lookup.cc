/*
  lookup.cc -- implement simple Lookup methods.

  source file of the GNU LilyPond music typesetter

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>

  TODO
  This doth suck. We should have PS output, and read spacing info from TFMs
  
  Glissando, bracket
  
*/

#include "lookup.hh"
#include "debug.hh"
#include "symtable.hh"
#include "dimen.hh"
#include "tex.hh"
#include "scalar.hh"
#include "paper-def.hh"

Lookup::Lookup()
{
  paper_l_ = 0;
  texsetting = "\\unknowntexsetting";
  symtables_ = new Symtables;
}

Lookup::Lookup (Lookup const &s)
{
  paper_l_ = s.paper_l_;
  texsetting = s.texsetting;
  symtables_ = new Symtables (*s.symtables_);
}
Lookup::~Lookup()
{
  delete symtables_;
}

void
Lookup::add (String s, Symtable*p)
{
  symtables_->add (s, p);
}

void
Lookup::print() const
{
#ifndef NPRINT
  DOUT << "Lookup: " << texsetting << " {\n";
  symtables_->print();
  DOUT << "}\n";
#endif
}

Atom
Lookup::text (String style, String text, int dir) const
{
  Array<String> a;
 
  a.push (text);
  Atom tsym =  (*symtables_)("style")->lookup (style);
  a[0] = substitute_args (tsym.tex_,a);

  Atom s = (*symtables_)("align")->lookup (dir);
  s.tex_ = substitute_args (s.tex_,a);
  s.dim_ = tsym.dim_;
  return s;
}



Atom
Lookup::ball (int j) const
{
  if (j > 2)
    j = 2;

  Symtable * st = (*symtables_)("balls");
  return st->lookup (String (j));
}

Atom
Lookup::rest (int j, bool o) const
{
  return (*symtables_)("rests")->lookup (String (j) + (o ? "o" : ""));
}

Atom
Lookup::fill (Box b) const
{
  Atom s ((*symtables_)("param")->lookup ("fill"));
  s.dim_ = b;
  return s;
}

Atom
Lookup::accidental (int j) const
{
  return (*symtables_)("accidentals")->lookup (String (j));
}


Atom
Lookup::bar (String s, Real h) const
{
  Array<String> a;
  a.push (print_dimen (h));
  Atom ret=(*symtables_)("bars")->lookup (s);;
  ret.tex_ = substitute_args (ret.tex_, a);
  ret.dim_.y() = Interval (0, h);
  return ret;
}

Atom
Lookup::script (String s) const
{
  return (*symtables_)("scripts")->lookup (s);
}

Atom
Lookup::dynamic (String s) const
{
  return (*symtables_)("dynamics")->lookup (s);
}

Atom
Lookup::clef (String s) const
{
  return (*symtables_)("clefs")->lookup (s);
}
 
Atom
Lookup::dots (int j) const
{
  if (j>3) 
    {
      j = 3;
      warning ("max 3 dots");	// todo
    }
  return (*symtables_)("dots")->lookup (j);
}

Atom
Lookup::flag (int j, Direction d) const
{
  char c = (d == UP) ? 'u' : 'd';
  return (*symtables_)("flags")->lookup (c + String (j));
}

Atom
Lookup::streepjes (int type, int i) const
{
  assert (i);
  
  int arg;
  String idx;
  
  if (i < 0) 
    {
      idx = "botlines";
      arg = -i;
    }
  else 
    {
      arg = i;
      idx = "toplines";
    }

  // ugh
  Real w = paper_l_->note_width ();
  if (type <= 0)
    w *= 1.46;

  Atom ret = (*symtables_)("streepjes")->lookup (idx);
  
  Array<String> a;
  a.push (String (w) + "pt");
  a.push (arg);
  ret.tex_ = substitute_args (ret.tex_, a);

  return ret;
}

Atom
Lookup::hairpin (Real &wid, bool decresc) const
{
  int idx = int (rint (wid / 6 PT));
  if (!idx) idx ++;
  wid = idx*6 PT;
  String idxstr = (decresc)? "decrescendosym" : "crescendosym";
  Atom ret=(*symtables_)("param")->lookup (idxstr);
     
  Array<String> a;
  a.push (idx);
  ret.tex_ = substitute_args (ret.tex_, a);
  ret.dim_.x() = Interval (0,wid);
  return ret;
}

Atom
Lookup::linestaff (int lines, Real wid) const
{
  Real internote_f = paper_l_ ->internote_f();
  Atom s;
  Real dy = (lines >0) ? (lines-1)*internote_f : 0;
  s.dim_ = Box (Interval (0,wid), Interval (0,dy));

  Array<String> a;
  a.push (lines);
  a.push (print_dimen (wid));

  s.tex_ = (*symtables_)("param")->lookup ("linestaf").tex_;
  s.tex_ = substitute_args (s.tex_, a);

  return s;
}


Atom
Lookup::meter (Array<Scalar> a) const
{
  Atom s;
  s.dim_.x() = Interval (0 PT, 10 PT);
  s.dim_.y() = Interval (0, 20 PT);	// todo
  String src = (*symtables_)("param")->lookup ("meter").tex_;
  s.tex_ = substitute_args (src,a);
  return s;    
}


Atom
Lookup::stem (Real y1,Real y2) const
{
  if (y1 > y2) 
    {
      Real t = y1;
      y1 = y2;
      y2 = t;
    }
  Atom s;
  
  s.dim_.x() = Interval (0,0);
  s.dim_.y() = Interval (y1,y2);
  
  Array<String> a;
  a.push (print_dimen (y1));
  a.push (print_dimen (y2));
	
  String src = (*symtables_)("param")->lookup ("stem").tex_;
  s.tex_ = substitute_args (src,a);
  return s;
}

/*
  should be handled via Tex_ code and Lookup::bar()
 */
Atom
Lookup::vbrace (Real &y) const
{
  if (y < 2* 20 PT) 
    {
      warning ("piano brace too small (" + print_dimen (y)+ ")");
      y = 2*20 PT;
    }
  if (y > 67 * 2 PT) 
    {
      warning ("piano brace too big (" + print_dimen (y)+ ")");	
      y = 67 *2 PT;
    }
  
  int idx = int (rint ((y/2.0 - 20) + 148));
  
  Atom s = (*symtables_)("param")->lookup ("brace");
  {
    Array<String> a;
    a.push (idx);
    s.tex_ = substitute_args (s.tex_,a);
    s.dim_.y() = Interval (0,y);
  }
  {
    Array<String> a;
    a.push (print_dimen (y/2));
    a.push (print_dimen (0));
    a.push (s.tex_);
    s.tex_ = substitute_args ("\\placebox{%}{%}{%}", a);
  }

	
  return s;
}
