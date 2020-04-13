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

#include <vector>

#include "lily-guile.hh"

class Mutable_properties
{
  std::vector<SCM> entries_;

  bool find_entry(SCM key, size_t *idx) const;
  SCM key(size_t i) const {
    return entries_[2*i];
  }
  SCM& key(size_t i) {
    return entries_[2*i];
  }
  SCM& val(size_t i) {
    return entries_[2*i+1];
  }
  SCM val(size_t i) const {
    return entries_[2*i+1];
  }
public:
  class Iterator {
    Mutable_properties const* props_;
    size_t i_;

    Iterator(Mutable_properties const& t) {
      props_ = &t;
      i_ = 0;
    }
    friend class Mutable_properties;

  public:
    bool ok() const {
      return i_ < props_->size();
    }

    void next() {
      i_++;
    }

    SCM key() {
      return props_->key(i_);
    }

    SCM val() {
      return props_->val(i_);
    }
  };
  Iterator iter() const {
    return Iterator(*this);
  }

  size_t size() const {
    return entries_.size() / 2;
  }
  Mutable_properties(vsize sz = 0);
  void clear();
  void swap(Mutable_properties*);
  void merge_from(Mutable_properties const &);
  bool try_retrieve (SCM key, SCM *val) const;
  bool contains (SCM key) const;
  void set (SCM k, SCM v);
  SCM get (SCM k) const;
  void remove (SCM k);
  void mark() const;
  SCM to_alist () const;
};

#endif /* MUTABLE_PROPERTIES_HH */
