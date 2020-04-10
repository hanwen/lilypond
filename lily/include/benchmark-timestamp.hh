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

#ifndef TIMESTAMP_HH
#define TIMESTAMP_HH

#include <time.h>

class Timestamp
{
  timespec spec_;
  Timestamp (timespec s) { spec_ = s; }

public:
  static Timestamp now ()
  {
    timespec s;
    clock_gettime (CLOCK_PROCESS_CPUTIME_ID, &s);
    return Timestamp (s);
  }

  Timestamp sub (Timestamp start) const
  {
    timespec temp;
    if ((spec_.tv_nsec - start.spec_.tv_nsec) < 0)
      {
        temp.tv_sec = spec_.tv_sec - start.spec_.tv_sec - 1;
        temp.tv_nsec = 1000000000 + spec_.tv_nsec - start.spec_.tv_nsec;
      }
    else
      {
        temp.tv_sec = spec_.tv_sec - start.spec_.tv_sec;
        temp.tv_nsec = spec_.tv_nsec - start.spec_.tv_nsec;
      }
    return Timestamp (temp);
  }

  Real seconds () const
  {
    return Real (spec_.tv_nsec) * 1e-9 + Real (spec_.tv_sec);
  }
};

#endif
