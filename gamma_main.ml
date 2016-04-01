
let print_gamma d t p =
  Gamma.gamma_label d t p |> print_string;
  print_string "\n";
  Gamma.gamma d t p |> Matrix.print_matrix (Index.pow 2 ((d+t)/2))

let main d t p =
  if p > 0
  then print_gamma d t p
  else
    Index.range 1 (d + t)
    |> List.iter (print_gamma d t)

let _ = 
  let d = ref 3 in
  let t = ref 0 in
  let p = ref 0 in
  Arg.(parse [
      "-d", Set_int d, "<n> dimension";
      "-t", Set_int t, "<n> time dimensions";
    ] (fun s -> p := int_of_string s)
    ("fun with supersymmetry 0.1\nusage: gamma [-d n] [-t n] [n]")
  );
  Printexc.record_backtrace true;
  try main !d !t !p with
  | e -> 
    let bt = Printexc.get_backtrace () in (* get backtrace *before* calling Printexc.to_string! *)
    let es = Printexc.to_string e in
    print_string es;
    print_string "\n";
    print_string bt;
    print_string "\n"
