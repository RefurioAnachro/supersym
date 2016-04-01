
open Field
open Index

(** pauli matrices, 2.12 *)
let sigma k =
  match k with
  | 0 ->
    Matrix.make 2 [
      one;  zero;
      zero; one;
    ]
  | 1 ->
    Matrix.make 2 [
      zero; one;
      one;  zero;
    ]
  | 2 ->
    Matrix.make 2 [
      zero; neg i;
      i;    zero;
    ]
  | 3 ->
    Matrix.make 2 [
      one;  zero;
      zero; neg one;
    ]
  | _ -> raise (Invalid_argument "Gamma.sigma")

(** compute gamma matrices according to 2.13, apparently these give the "chiral" Weyl basis for d even *)
let info d p =
  let k = d / 2 in
  let e3 = (p-1) / 2 in
  e3 , 2 - (p mod 2) , k - e3 - 1
let gamma d p =
  let e3, s, e0 = info d p in
  Tensor.left [
    pow 2 e3, Tensor.pow 2 (sigma 3) e3;
    2, sigma s;
    pow 2 e0, Tensor.pow 2 (sigma 0) e0;
  ]
let gamma_label d p =
  let e3, s, e0 = info d p in
  String.concat "" [
    "Gamma_"; string_of_int p; ": ";
    String.make e3 '3';
    string_of_int s;
    String.make e0 '0';
  ]

(** generalize gamma for odd dimension according to 2.13 *)
let gamma_hat d =
  let k = d/2 in
  Tensor.pow 2 (sigma 3) k
let gamma d p =
  if d = p && d mod 2 = 1
  then gamma_hat d
  else gamma d p
let gamma_label d p =
  let k = d/2 in
  if d = p && d mod 2 = 1
  then String.concat "" [
    "Gamma_"; string_of_int d; ": ";
    String.make k '3';
  ]
  else gamma_label d p

(** generalize gamma for > 0 time dimensions according to k_a in 2.13 *)
let k t a = if a <= t then i else one
let gamma d t p = Matrix.smul (k t p) (gamma (d+t) p)
let gamma_label d t p = gamma_label (d+t) p

(** performance: *)
let gamma d t p =
  let n = Index.pow 2 ((d+t)/2) in
  gamma d t p
  |> Matrix.cache n
