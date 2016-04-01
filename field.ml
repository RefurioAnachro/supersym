
module ComplexUnit = struct
  type t = Zero | One | I | MinusOne | MinusI

  let zero = Zero
  let one = One
  let i = I

  let neg a =
    match a with
    | Zero     -> Zero
    | One      -> MinusOne
    | I        -> MinusI
    | MinusOne -> One
    | MinusI   -> I
  let mul a b =
    match a, b with
    | Zero, _ | _, Zero         -> Zero
    | One, x | x, One           -> x
    | MinusOne, x | x, MinusOne -> neg x
    | I, MinusI | MinusI, I     -> One
    | I, I | MinusI, MinusI     -> MinusOne
  let add a b =
    match a, b with
    | Zero, r | r, Zero -> r
    | One, MinusOne | MinusOne, One
    | I, MinusI | MinusI, I     -> Zero
    | _ -> raise (Invalid_argument "ComplexUnit.add")

  let to_string a =
    match a with
    | Zero     -> "."
    | One      -> ">"
    | I        -> "^"
    | MinusOne -> "<"
    | MinusI   -> "v"
  let print_field a = to_string a |> print_string
end

module ComplexFloat = struct
  type t = Complex.t

  let zero = Complex.zero
  let one = Complex.one
  let i = Complex.i

  let neg = Complex.neg
  let mul = Complex.mul
  let add = Complex.add

  let fp_to_string f =
    match classify_float f with
    | FP_normal -> "FP_normal"
    | FP_subnormal -> "FP_subnormal"
    | FP_zero -> "FP_zero"
    | FP_infinite -> "FP_infinite"
    | FP_nan -> "FP_nan"
  let print_float x =
    let f, i = modf x in
    match classify_float f with
    | FP_normal -> print_float x
    | _ -> print_int (int_of_float x)

  let re c = c.Complex.re
  let im c = c.Complex.im
  let print_complex c =
    let re , im = re c , im c in
    match (classify_float re), (classify_float im) with
    | FP_zero   , FP_zero   -> print_string "0"
    | FP_normal , FP_zero   -> print_float re
    | FP_zero   , FP_normal -> print_float im; print_string "i"
    | FP_normal , FP_normal -> print_float re; print_string "+"; print_float im; print_string "i"
    | _ -> raise (Failure ("classify problem: "^ (fp_to_string re) ^" "^ (fp_to_string im)))
  let print_field c = print_complex c; print_string "\t"
end

module ComplexInt = struct
  type t = int * int
  let zero = 0,0
  let one = 1,0
  let i = 0,1
  let neg (re,im) = -re, -im
  let mul (ar, ai) (br, bi) = ar*br - ai*bi, ai*br + ar*bi
  let add (ar, ai) (br, bi) = ar+br, ai+bi

  let re (r,i) = r
  let im (r,i) = i

  let im_to_string i =
    match i with
    | 1 -> "i"
    | -1 -> "-i"
    | _ -> (string_of_int i) ^ "i"
  let to_string c =
    match c with
    | 0, 0 -> "0"
    | 0, 1 -> "i"
    | 0, -1 -> "-i"
    | 0, i -> im_to_string i
    | r, 0 -> string_of_int r
    | r, i when i > 0 -> (string_of_int r) ^"+"^ (im_to_string i)
    | r, i -> (string_of_int r) ^"-"^ (im_to_string (-i))
  let print_field c = to_string c |> print_string; print_string "\t"
end

include ComplexInt
