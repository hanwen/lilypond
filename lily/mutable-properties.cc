/*
  This file is part of LilyPond, the GNU music typesetter.

  Copyright (C) 2020 Han-Wen Nienhuys <hanwen@xs4all.nl>

  LilyPond is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  LilyPond is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with LilyPond.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "mutable-properties.hh"

Mutable_properties::Mutable_properties (vsize sz) { entries_.reserve (sz); }

void
Mutable_properties::clear ()
{
  entries_.resize (0);
}

void
Mutable_properties::swap (Mutable_properties *other)
{
  std::swap (entries_, other->entries_);
}

void
Mutable_properties::merge_from (Mutable_properties const &src)
{
  for (auto it = src.iter (); it.ok (); it.next ())
    {
      set (it.key (), it.val ());
    }
}

bool
Mutable_properties::try_retrieve (SCM k, SCM *v) const
{
  for (vsize i = 0; i < size (); i++)
    {
      if (SCM_EQ_P (key (i), k))
        {
          *v = val (i);
          return true;
        }
    }
  return false;
}

bool
Mutable_properties::contains (SCM key) const
{
  SCM unused;
  return try_retrieve (key, &unused);
}

void
Mutable_properties::set (SCM k, SCM v)
{
  for (vsize i = 0; i < size (); i++)
    {
      if (SCM_EQ_P (key (i), k))
        {
          val (i) = v;
          break;
        }
    }
  entries_.push_back (k);
  entries_.push_back (v);
}

SCM
Mutable_properties::get (SCM k) const
{
  SCM v = SCM_UNDEFINED;
  try_retrieve (k, &v);
  return v;
}

void
Mutable_properties::remove (SCM k)
{
  if (size () == 0)
    return;

  for (vsize i = 0; i < size (); i++)
    {
      if (SCM_EQ_P (key (i), k))
        {
          size_t last = size () - 1;
          key (i) = key (last);
          val (i) = val (last);
          entries_.resize (last * 2);
          return;
        }
    }
}

void
Mutable_properties::mark () const
{
  for (vsize i = 0; i < size (); i++)
    {
      scm_gc_mark (key (i));
      scm_gc_mark (val (i));
    }
}

SCM
Mutable_properties::to_alist () const
{
  SCM result = SCM_EOL;
  for (vsize i = 0; i < size (); i++)
    {
      result = scm_acons (key (i), val (i), result);
    }
  return result;
}
