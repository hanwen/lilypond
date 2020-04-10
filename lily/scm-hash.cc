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

#include "scm-hash.hh"
#include "benchmark-timestamp.hh"
#include "string-convert.hh"

#include <cassert>

Scheme_hash_table::~Scheme_hash_table () { free (table_); }

Scheme_hash_table::Scheme_hash_table (size_t initial_size)
{
  table_ = NULL;
  count_ = 0;
  cap_ = 0;
  smobify_self ();
  if (initial_size > 0)
    {
      cap_ = initial_size;
      table_ = (Entry *) calloc (cap_, sizeof (Entry));
    }
}

void
Scheme_hash_table::swap (Scheme_hash_table *other)
{
  size_t count = count_;
  size_t cap = cap_;
  Entry *tab = table_;

  table_ = other->table_;
  cap_ = other->cap_;
  count_ = other->count_;

  other->table_ = tab;
  other->cap_ = cap;
  other->count_ = count;
}

void
Scheme_hash_table::clear ()
{
  memset (table_, 0, sizeof (Entry) * cap_);
  count_ = 0;
}

void
Scheme_hash_table::maybe_grow ()
{
  if (2 * count_ <= cap_ && cap_ > 0)
    {
      return;
    }

  size_t oldcap = cap_;
  // This yields size of 2^n-1, but we can select other strategies to
  // control the time/space tradeoff.
  size_t newcap = 2 * cap_ + 1;
  size_t old_count = count_;
  Entry *old_table = table_;

  table_ = (Entry *) calloc (newcap, sizeof (Entry));
  // subtle: if using scm_gc_calloc, must assign after alloc, because
  // alloc can trigger GC, and mark will inspect cap_.
  cap_ = newcap;
  count_ = 0;
  for (size_t i = 0; i < oldcap; i++)
    {
      if (old_table[i].key != NULL)
        {
          internal_set (old_table[i].key, old_table[i].val);
        }
    }
  assert (old_count == count_);
  free (old_table);
}

uintptr_t
Scheme_hash_table::hash (SCM key)
{
  uintptr_t x = SCM_UNPACK (key);

  // see
  // https://stackoverflow.com/questions/664014/what-integer-hash-function-are-good-that-accepts-an-integer-hash-key
#if SCM_SIZEOF_UINTPTR_T == 4
  x = ((x >> 16) ^ x) * 0x45d9f3b;
  x = ((x >> 16) ^ x) * 0x45d9f3b;
  x = (x >> 16) ^ x;
#elif SCM_SIZEOF_UINTPTR_T == 8
  x = (x ^ (x >> 30)) * UINT64_C (0xbf58476d1ce4e5b9);
  x = (x ^ (x >> 27)) * UINT64_C (0x94d049bb133111eb);
  x = x ^ (x >> 31);
#else
#error unsupported word size
#endif
  return x;
}

SCM
Scheme_hash_table::mark_smob () const
{
  for (size_t i = 0; i < cap_; i++)
    {
      if (table_[i].key != NULL)
        {
          scm_gc_mark (table_[i].key);
          scm_gc_mark (table_[i].val);
        }
    }
  return SCM_EOL;
}

/* Finds the key, or returns the place where we'd insert the key.  If
   inserting, there should be at least one entry free.
 */
bool
Scheme_hash_table::find_entry (SCM key, size_t *idx) const
{
  if (cap_ == 0)
    {
      return false;
    }
  *idx = size_t (hash (key) % cap_);
  size_t start = *idx;
  do
    {
      if (table_[*idx].key == NULL)
        {
          return false;
        }

      if (scm_is_eq (table_[*idx].key, key))
        {
          return true;
        }

      *idx = (*idx + 1) % cap_;
    }
  while (*idx != start);
  return false;
}

Scheme_hash_table::Entry Scheme_hash_table::empty_entry;

void
Scheme_hash_table::remove (SCM k)
{
  if (count_ == 0)
    {
      return;
    }
  size_t start = 0;
  if (!find_entry (k, &start))
    {
      return;
    }

  count_--;

  // Clear the entry
  table_[start] = empty_entry;

  // See https://en.wikipedia.org/wiki/Linear_probing#Deletion. In
  // linear probing, the collisions appear in clusters. By removing,
  // we leave a in the middle of a cluster. If subsequent entries in
  // the cluster were placed beyond their original position,
  // we can't find them anymore, so move them.
  size_t gap = start;
  for (size_t next = (start + 1) % cap_; next != start;
       next = (next + 1) % cap_)
    {
      SCM nk = table_[next].key;
      if (nk == NULL)
        {
          return;
        }

      size_t j = size_t (hash (nk) % cap_);
      if (j == next)
        {
          // this one wasn't moved, so leave it alone
          continue;
        }

      bool move = false;
      if (gap < next)
        {
          // normal case:
          move = (j <= gap);
        }
      else if (gap > next)
        {
          // we have wrapped around. We only want to move the entry if
          // it also wrapped.
          move = (j > next && j <= gap);
        }

      if (move)
        {
          table_[gap] = table_[next];
          table_[next] = empty_entry;
          gap = next;
        }
    }

  // If the table is completely full, and all entries hash to 0, but
  // we remove cap_-1, we'd arrive here.
}

int
Scheme_hash_table::print_smob (SCM p, scm_print_state *) const
{
  scm_puts (
    String_convert::form_string ("#<Scheme_hash_table %lu/%lu>", count_, cap_)
      .c_str (),
    p);
  return 1;
}

bool
Scheme_hash_table::try_retrieve (SCM k, SCM *v)
{
  assert (scm_is_symbol (k));
  size_t idx = 0;
  if (find_entry (k, &idx))
    {
      *v = table_[idx].val;
      return true;
    }

  return false;
}

bool
Scheme_hash_table::contains (SCM k) const
{
  assert (scm_is_symbol (k));
  size_t unused;
  return find_entry (k, &unused);
}

void
Scheme_hash_table::set (SCM k, SCM v)
{
  assert (scm_is_symbol (k));
  maybe_grow ();
  internal_set (k, v);
}

void
Scheme_hash_table::merge_from (Scheme_hash_table const *src)
{
  for (auto it = src->iter (); it.ok (); it.next ())
    {
      set (it.key (), it.val ());
    }
}

void
Scheme_hash_table::internal_set (SCM k, SCM v)
{
  size_t idx = 0;
  find_entry (k, &idx);
  if (table_[idx].key == NULL)
    {
      count_++;
    }
  table_[idx].key = k;
  table_[idx].val = v;
}

SCM
Scheme_hash_table::get (SCM k) const
{
  size_t i;
  if (find_entry (k, &i))
    {
      return table_[i].val;
    }

  return SCM_UNDEFINED;
}

SCM
Scheme_hash_table::to_alist () const
{
  SCM alist = SCM_EOL;
  for (auto it = iter (); it.ok (); it.next ())
    {
      alist = scm_acons (it.key (), it.val (), alist);
    }
  return alist;
}

SCM
Scheme_hash_table::make_smob ()
{
  Scheme_hash_table *t = new Scheme_hash_table ();
  SCM result = t->self_scm ();
  t->unprotect ();
  return result;
}

// Use ly:test: as prefix?
LY_DEFINE (ly_test_scheme_hash_table, "ly:test-scheme-hash-table", 0, 0, 0, (),
           "Test Scheme_hash_table")
{
  SCM sht = Scheme_hash_table::make_smob ();
  Scheme_hash_table *ht = unsmob<Scheme_hash_table> (sht);

  SCM s1 = ly_symbol2scm ("s1");
  SCM s2 = ly_symbol2scm ("s2");

  SCM v1 = ly_symbol2scm ("v1");
  SCM v2 = ly_symbol2scm ("v1");
  ht->set (s1, v1);
  ht->set (s2, v2);

  SCM l = ht->to_alist ();
  assert (scm_ilength (l) == 2);
  assert (scm_cdr (scm_assq (s1, l)) == v1);
  assert (scm_cdr (scm_assq (s2, l)) == v2);

  assert (ht->contains (s1));
  SCM r;
  assert (ht->try_retrieve (s2, &r));
  assert (r == v2);

  ht->remove (s2);
  assert (!ht->contains (s2));
  ht->remove (s2);
  ht->remove (s1);

  SCM syms[10];
  int arr_size = sizeof (syms) / sizeof (SCM);
  for (int i = 0; i < arr_size; i++)
    {
      syms[i] = ly_symbol2scm (String_convert::form_string ("s%d", i).c_str ());
      ht->set (syms[i], SCM_BOOL_T);
    }
  for (int i = 0; i < arr_size; i++)
    {
      ht->remove (syms[i]);
      for (int j = 0; j < arr_size; j++)
        {
          assert (ht->contains (syms[j]) == (i != j));
        }
      ht->set (syms[i], SCM_BOOL_T);
    }

  scm_remember_upto_here (sht);
  return SCM_EOL;
}

LY_DEFINE (ly_benchmark_scheme_hash_table, "ly:benchmark-scheme-hash-table", 0,
           0, 0, (), "Test Scheme_hash_table")
{
  SCM sht = Scheme_hash_table::make_smob ();
  Scheme_hash_table *ht = unsmob<Scheme_hash_table> (sht);

  SCM syms[10000];
  SCM classic = scm_c_make_hash_table (1);
  int arr_size = sizeof (syms) / sizeof (SCM);
  for (int i = 0; i < arr_size; i++)
    {
      syms[i] = ly_symbol2scm (String_convert::form_string ("s%d", i).c_str ());
      SCM val = scm_from_int (i);
      ht->set (syms[i], val);
      scm_hashq_set_x (classic, syms[i], val);
    }

  uint64_t total = 0;
  auto t1 = Timestamp::now ();
  for (int i = 0; i < arr_size; i++)
    {
      total += scm_to_int (ht->get (syms[i]));
    }
  auto t2 = Timestamp::now ();
  for (int i = 0; i < arr_size; i++)
    {
      total += scm_to_int (scm_hashq_ref (classic, syms[i], SCM_BOOL_F));
    }
  auto t3 = Timestamp::now ();

  Real dt1 = t2.sub (t1).seconds ();
  Real dt2 = t3.sub (t1).seconds ();

  // can't print this into regtest output, or it would generate noise.
  printf ("Scheme_hash_table: %g, GUILE hash: %g (GUILE %f x slower)\n", dt1,
          dt2, dt2 / dt1);

  scm_remember_upto_here (sht);
  // make sure value isn't optimized away.
  return scm_from_uint64 (total);
}
