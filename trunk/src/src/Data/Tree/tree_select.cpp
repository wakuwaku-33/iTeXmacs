
/******************************************************************************
* MODULE     : tree_select.cpp
* DESCRIPTION: abstract cursor handling
* COPYRIGHT  : (C) 1999  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#include "tree_select.hpp"
#include "drd_std.hpp"
#include "analyze.hpp"

/******************************************************************************
* Structural correction of the selection
******************************************************************************/

static void
selection_adjust_border (tree t, path i1, path i2, path& o1, path& o2)
{
  o1= i1; o2= i2;
  if (is_compound (t) && !is_atom (i1) && !is_atom (i2) &&
      i1->item == i2->item) {
    path O1, O2;
    selection_adjust_border (t[i1->item], i1->next, i2->next, O1, O2);
    if (the_drd->var_without_border (L(t[i1->item])) &&
        (O1->item != O2->item)) {
      o1= path (0);
      o2= path (1);
    }
    else {
      o1= path (i1->item, O1);
      o2= path (i1->item, O2);
    }
  }
}

static void
adjust_right_script (tree t, path& o1) {
  while (is_concat (t) && o1->item > 0 && o1->next == path (0)) {
    tree st= t[o1->item];
    if (is_func (st, RSUB) || is_func (st, RSUP) || is_func (st, RPRIME)) {
      tree pt= t[o1->item-1];
      if (!is_atomic (pt))
        o1= path (o1->item-1, start (pt));
      else {
        string s= pt->label;
        int pos= N(s);
        while (pos > 0) {
          int prev= pos;
          tm_char_backwards (s, prev);
          if (pos == N(s));
          else if (is_numeric (s (prev, N(s))));
          else if (is_iso_alpha (s (prev, N(s))));
          else break;
          pos= prev;
        }
        o1= path (o1->item-1, pos);
      }
    }
    else break;
  }
}

static void
adjust_left_script (tree t, path& o2) {
  while (is_concat (t) && o2->item + 1 < N(t) && o2->next == path (1)) {
    tree st= t[o2->item];
    if (is_func (st, LSUB) || is_func (st, LSUP) || is_func (st, LPRIME)) {
      tree nt= t[o2->item+1];
      if (!is_atomic (nt)) o2= path (o2->item+1, end (nt));
      else {
        string s= nt->label;
        int pos= 0;
        while (pos < N(s)) {
          int next= pos;
          tm_char_forwards (s, next);
          if (pos == 0);
          else if (is_numeric (s (0, next)));
          else if (is_iso_alpha (s (0, next)));
          else break;
          pos= next;
        }
        o2= path (o2->item+1, pos);
      }
    }
    else break;
  }
}

static void
selection_adjust (tree t, path i1, path i2, path& o1, path& o2) {
  //cout << "Adjust " << i1 << " -- " << i2 << " in " << t << "\n";
  if (i1 == i2) {
    o1= i1;
    o2= i2;
  }
  else if (is_atom (i1) || is_atom (i2)) {
    if (is_atomic (t)) {
      o1= i1;
      o2= i2;
    }
    else {
      o1= start (t);
      o2= end (t);
    }
  }
  else if (i1->item == i2->item) {
    selection_adjust (t[i1->item], i1->next, i2->next, o1, o2);
    o1= path (i1->item, o1);
    o2= path (i2->item, o2);
    adjust_right_script (t, o1);
    adjust_left_script (t, o2);
  }
  else {
    tree_label l= L(t);
    if ((l==DOCUMENT) || (l==PARA) || (l==CONCAT)) {
      if (is_compound (t[i1->item])) {
	path mid;
	selection_adjust (t[i1->item], i1->next, end (t[i1->item]), o1, mid);
	o1= path (i1->item, o1);
      }
      else o1= i1;
      if (is_compound (t[i2->item])) {
	path mid;
	selection_adjust (t[i2->item], start(t[i2->item]), i2->next, mid, o2);
	o2= path (i2->item, o2);
      }
      else o2= i2;
      if (l == CONCAT) {
        adjust_right_script (t, o1);
        adjust_left_script (t, o2);
      }
    }
    else {
      o1= start (t);
      o2= end (t);
    }
  }
  //cout << "Adjusted " << o1 << " -- " << o2 << " in " << t << "\n";
}

static void
selection_make_accessible (tree t, path i1, path i2, path& o1, path& o2) {
  o1= i1; o2= i2;
  if (!is_accessible_cursor (t, o1))
    o1= previous_accessible (t, o1);
  if (!is_accessible_cursor (t, o1))
    o1= next_accessible (t, o1);
  if (!is_accessible_cursor (t, o2))
    o2= next_accessible (t, o2);
  if (!is_accessible_cursor (t, o2))
    o2= previous_accessible (t, o2);
  if (path_inf (o1, o2))
    o1= shift (t, o1, 1);
}

void
selection_correct (tree t, path i1, path i2, path& o1, path& o2) {
  o1= i1; o2= i2;
  while (true) {
    i1= o1; i2= o2;
    selection_adjust_border (t, i1, i2, o1, o2);
    i1= o1; i2= o2;
    selection_adjust (t, i1, i2, o1, o2);
    i1= o1; i2= o2;
    selection_make_accessible (t, i1, i2, o1, o2);
    if (o1 == i1 && o2 == i2) break;
  }
}

/******************************************************************************
* Computation of the selected tree
******************************************************************************/

tree
selection_compute (tree t, path start, path end) {
  int  i1= start->item;
  int  i2= end->item;
  path p1= start->next;
  path p2= end->next;

  if (is_nil (p1) || is_nil (p2)) {
    if (start == path (right_index (t))) return "";
    if (end == path (0)) return "";
    if (start == end) return "";
    if (is_nil (p1) && is_nil (p2)) {
      if (is_compound (t)) return copy (t);
      if (i1>=i2) return "";
      return t->label (i1, i2);
    }
    if (is_compound (t) && (!is_format (t))) return copy (t);
    if (is_nil (p1)) {
      i1= 0;
      p1= (start->item==0? 0: right_index (t[i1]));
    }
    if (is_nil (p2)) {
      i2= N(t)-1;
      p2= (end->item==0? 0: right_index (t[i2]));
    }
  }

  if (i1==i2) return selection_compute (t[i1], p1, p2);
  if (is_compound (t) && (!is_format (t))) return copy (t);

  int i;
  tree r (t, i2-i1+1);
  r[0]     = selection_compute (t[i1], p1, path (right_index (t[i1])));
  r[N(r)-1]= selection_compute (t[i2], path (0), p2);
  for (i=1; i<N(r)-1; i++) r[i]= copy (t[i+i1]);
  return r;
}