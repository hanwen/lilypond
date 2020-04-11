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

Mutable_properties::Mutable_properties () { alist_ = SCM_EOL; }

void
Mutable_properties::clear ()
{
  alist_ = SCM_EOL;
}

void
Mutable_properties::swap (Mutable_properties *other)
{
  SCM a = alist_;
  alist_ = other->alist_;
  other->alist_ = a;
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
Mutable_properties::try_retrieve (SCM key, SCM *val) const
{
  SCM entry = scm_assq (key, alist_);
  if (!scm_is_pair (entry))
    {
      return false;
    }

  *val = scm_cdr (entry);
  return true;
}

bool
Mutable_properties::contains (SCM key) const
{
  for (auto it = iter (); it.ok (); it.next ())
    {
      if (SCM_EQ_P (it.key (), key))
        {
          return true;
        }
    }
  return false;
}

void
Mutable_properties::set (SCM k, SCM v)
{
  alist_ = scm_assq_set_x (alist_, k, v);
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
  alist_ = scm_assq_remove_x (alist_, k);
}
