
let main d t expr =
  let n = Index.pow 2 ((d+t)/2) in
  List.map (Matrix.prod n) expr
  |> Matrix.sum n
  |> Matrix.print_matrix n

let _ = 
  let d = ref 3 in
  let t = ref 0 in
  let expr = ref [] in
  let subexpr = ref [] in
  let flush_subexpr () = 
    match !subexpr with
    | [] -> ()
    | _ ->
      expr := !subexpr :: !expr;
      subexpr := []
  in
  Arg.(parse [
      "-d", Set_int d, "<n> dimension";
      "-t", Set_int t, "<n> time dimensions";
    ] (fun s ->
      match s with
      | "+" -> flush_subexpr ()
      | "c" -> subexpr := Ghost.charge !d !t :: !subexpr
      | s -> subexpr := Gamma.gamma !d !t (int_of_string s) :: !subexpr
    )
    ("fun with supersymmetry 0.1\nusage: gamma [-d n] [-t n] [n]")
  );
  flush_subexpr ();
  Printexc.record_backtrace true;
  try main !d !t !expr with
  | e -> 
    let bt = Printexc.get_backtrace () in (* get backtrace *before* calling Printexc.to_string! *)
    let es = Printexc.to_string e in
    print_string es;
    print_string "\n";
    print_string bt;
    print_string "\n"
