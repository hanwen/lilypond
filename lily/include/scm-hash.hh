/*
  This file is part of LilyPond, the GNU music typesetter.

  Copyright (C) 1999--2020 Han-Wen Nienhuys <hanwen@xs4all.nl>

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

#ifndef SCM_HASH_HH
#define SCM_HASH_HH

#include "small-smobs.hh"

/*
  Used for looking up symbol keyed values.
*/
class Scheme_hash_table : public Smob<Scheme_hash_table>
{
  struct Entry {
    // A free entry is indicated by NULL (which is assumed to never
    // coincide with a symbol).  This is correct in GUILE 1.8. For 2.x
    // and beyond, the GUILE API promises to use the Boehm GC, so
    // values are considered pointers too.  Note that we take care to
    // never pass NULL back to GUILE.
    SCM key;
    SCM val;
  };

  SCM *values_;
  uint16_t *keys_;
  size_t count_;
  size_t cap_;

  void alloc (size_t);
  void maybe_grow();
  bool find_entry(uint16_t key, size_t *idx) const;
  static uint16_t hash(SCM key);
  static Entry empty_entry;
  void internal_set(uint16_t key, SCM val);
public:
  class Iterator {
    const Scheme_hash_table *tab_;
    size_t idx_;

    void skip() {
      while (ok()) {
        if (tab_->keys_[idx_]) {
          break;
        }
        idx_++;
      }
    }

    Iterator(Scheme_hash_table const& t) {
      tab_ = &t;
      idx_ = 0;
      skip();
    }
    friend class Scheme_hash_table;

  public:
    bool ok() const {
      return idx_ < tab_->cap_;
    }

    void next() {
      idx_++;
      skip();
    }

    SCM key() const;
    SCM val() const {
      return tab_->values_[idx_];
    }
  };

  Iterator iter() const {
    return Iterator(*this);
  }

  Scheme_hash_table(size_t initial_size = 0);
  ~Scheme_hash_table();
  size_t size() const { return count_; }
  void clear();
  void swap(Scheme_hash_table*);
  void merge_from(Scheme_hash_table const*);
  int print_smob (SCM, scm_print_state *) const;
  bool try_retrieve (SCM key, SCM *val);
  bool contains (SCM key) const;
  void set (SCM k, SCM v);
  SCM get (SCM k) const;
  void remove (SCM k);
  void operator = (Scheme_hash_table const &);
  SCM to_alist () const;
  SCM mark_smob () const;
  static SCM make_smob ();
};

#endif /* SCM_HASH_HH */
