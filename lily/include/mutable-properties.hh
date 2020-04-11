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

#ifndef MUTABLE_PROPERTIES_HH
#define MUTABLE_PROPERTIES_HH

#include "lily-guile.hh"

class Mutable_properties
{
  SCM alist_;

  bool find_entry(SCM key, size_t *idx) const;
public:
  class Iterator {
    SCM p_;
    Iterator(Mutable_properties const& t) {
      p_ = t.alist_;
    }
    friend class Mutable_properties;
  public:
    bool ok() const {
      return scm_is_pair(p_);
    }

    void next() {
      p_ = scm_cdr(p_);
    }

    SCM key() {
      return scm_caar(p_);
    }

    SCM val() {
      return scm_cdar(p_);
    }
  };
  Iterator iter() const {
    return Iterator(*this);
  }

  Mutable_properties();
  void clear();
  void swap(Mutable_properties*);
  void merge_from(Mutable_properties const &);
  bool try_retrieve (SCM key, SCM *val) const;
  bool contains (SCM key) const;
  void set (SCM k, SCM v);
  SCM get (SCM k) const;
  void remove (SCM k);
  void mark() const {
    scm_gc_mark(alist_);
  }
  SCM to_alist () const { return alist_; }
};

#endif /* MUTABLE_PROPERTIES_HH */
