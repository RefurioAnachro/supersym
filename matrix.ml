
open Field
open Index

type t = int -> int -> Field.t

(** matrix indices range from 0..(D-1) *)

let zero i j = Field.zero
let delta i j = if i = j then Field.one else Field.zero
let identity = delta

let make d l =
  fun i j ->
  let i = (i mod d) in
  let j = (j mod d) in
  List.nth l (i*d + j)

let smul s a i j = mul s (a i j)
let mul d a b i j =
  range 0 (d-1) |> List.fold_left (fun ret k ->
    add ret (mul (a i k) (b k j))
  ) Field.zero
let add d a b i j = add (a i j) (b i j)

let transpose m i j = m j i

(** commutator (m1,m2) and anticommutator {m1,m2} *)
let comm m1 m2 i j = (m1 i j) * (m2 j i) - (m1 j i) * (m2 i j)
let anti m1 m2 i j = (m1 i j) * (m2 j i) + (m1 j i) * (m2 i j)

let cache d m =
  let a = Array.make (d*d) Field.zero in
  range 0 (d-1) |> List.iter (fun i ->
    range 0 (d-1) |> List.iter (fun j ->
      Array.set a (i + j*d) (m i j)
    )
  );
  fun i j ->
  Array.get a (i + j*d)

let prod n l =
  List.fold_left (fun ret m ->
    mul n ret m |> cache n
  ) identity l
let sum n l = List.fold_left (add n) zero l

let print_matrix d f =
  Index.range 0 (d-1) |> List.iter (fun i ->
    Index.range 0 (d-1) |> List.iter (fun j ->
      Field.print_field (f i j);
    );
    print_string "\n"
  )
