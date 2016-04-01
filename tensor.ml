
let prod d a b i j =
  Field.mul (a (i mod d) (j mod d)) (b (i / d) (j / d))

let rec pow d m e =
  match e with
  | 0 -> Matrix.identity
  | 1 -> m
  | _ ->
    match e mod 2 with
    | 0 ->
       let q = pow d m (e/2) in
       prod (Index.pow d (e/2)) q q
    | _ -> prod d m (pow d m (e-1))

let left l = List.fold_left (fun ret (d,m) -> prod d m ret) Matrix.identity l
