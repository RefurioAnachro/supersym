
let rec pow ret b e =
  match e with
  | 0 -> ret
  | _ ->
    match e mod 2 with
    | 0 -> pow ret (b * b) (e lsr 1)
    | _ -> pow (ret * b) b (e-1)
let pow b e = pow 1 b e

(* count from a to b, inclusive *)
let rec range a b r =
  if a <= b
  then range a (b-1) (b :: r)
  else r
let range a b = range a b []
