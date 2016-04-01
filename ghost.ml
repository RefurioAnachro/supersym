
open Field
open Index

(** the metric eta_ij, 2.1 *)
let eta d t i j =
  if not i = j
  then zero
  else if i < t (* literature says i<=t, but our indices start at 0 *)
  then one
  else neg one

(** charge conjugation matrices C for the standard spin representation *)
let alternate s1 s2 k =
  let e = Tensor.pow 4 (Tensor.prod 2 s1 s2) (k/2) in
  match k mod 2 with
  | 0 -> e
  | _ -> Tensor.prod (pow 4 (k/2)) e s1
let sigma = Gamma.sigma
let charge d t = 
  let k = (d + t)/2 in
  match (d+t) mod 2 with
  | 0 -> alternate (sigma 2) (sigma 1) k
  | _ -> alternate (sigma 1) (sigma 2) k
let alternate_str s1 s2 k =
  range 1 k |> List.map (fun i ->
    match i mod 2 with
    | 0 -> s2
    | _ -> s1
  )
  |> String.concat ""
let charge_label d t =
  let k = (d + t)/2 in
  match (d+t) mod 2 with
  | 0 -> alternate_str "2" "1" k
  | _ -> alternate_str "1" "2" k

let charge d t = 
  let n = Index.pow 2 ((d+t)/2) in
  charge d t
  |> Matrix.cache n

(** we define M_i_j = identity to simplify things *)
